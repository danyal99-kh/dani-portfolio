import 'dart:async';

import 'package:flutter/material.dart';

import '../../app/localization/app_localizations.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_theme.dart';
import '../utils/responsive.dart';
import 'ambient_background.dart';

class TerminalWelcomeScreen extends StatefulWidget {
  const TerminalWelcomeScreen({
    super.key,
    required this.isReady,
    required this.onFinished,
  });

  final bool isReady;
  final VoidCallback onFinished;

  @override
  State<TerminalWelcomeScreen> createState() => _TerminalWelcomeScreenState();
}

class _TerminalWelcomeScreenState extends State<TerminalWelcomeScreen>
    with TickerProviderStateMixin {
  static const _commandCount = 6;

  late final AnimationController _life;
  late final AnimationController _cursor;
  late final Animation<double> _cursorOpacity;

  Timer? _tickTimer;
  Timer? _successTimer;
  Timer? _exitTimer;
  int _visibleCommands = 0;
  bool _showSuccess = false;
  bool _showWelcome = false;
  bool _completionScheduled = false;
  bool _sequenceStarted = false;
  bool _exiting = false;
  bool _reduceMotion = false;

  @override
  void initState() {
    super.initState();
    _life = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 520),
    )..addStatusListener(_handleStatus);
    _cursor = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 820),
    );
    _cursorOpacity = _cursor.drive(Tween<double>(begin: 0.2, end: 1));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_sequenceStarted) return;
    _sequenceStarted = true;
    _reduceMotion = context.reduceMotion;

    if (_reduceMotion) {
      _life.value = 1;
      _cursor.value = 1;
      setState(() => _visibleCommands = _commandCount);
      _maybeComplete();
      return;
    }

    _life.forward();
    _cursor.repeat(reverse: true);
    _tickTimer = Timer.periodic(const Duration(milliseconds: 105), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      setState(() => _visibleCommands++);
      if (_visibleCommands >= _commandCount) {
        timer.cancel();
        _cursor.stop();
        _cursor.value = 1;
        _maybeComplete();
      }
    });
  }

  @override
  void didUpdateWidget(covariant TerminalWelcomeScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!oldWidget.isReady && widget.isReady) {
      _maybeComplete();
    }
  }

  @override
  void dispose() {
    _tickTimer?.cancel();
    _successTimer?.cancel();
    _exitTimer?.cancel();
    _life.dispose();
    _cursor.dispose();
    super.dispose();
  }

  void _maybeComplete() {
    if (_completionScheduled ||
        !widget.isReady ||
        _visibleCommands < _commandCount) {
      return;
    }
    _completionScheduled = true;
    _cursor.stop();
    _cursor.value = 1;
    setState(() => _showSuccess = true);

    _successTimer = Timer(
      Duration(milliseconds: _reduceMotion ? 120 : 220),
      () {
        if (!mounted) return;
        setState(() => _showWelcome = true);
        _exitTimer = Timer(
          Duration(milliseconds: _reduceMotion ? 520 : 680),
          _beginExit,
        );
      },
    );
  }

  void _beginExit() {
    if (_exiting || !mounted) return;
    setState(() => _exiting = true);
    _cursor.stop();
    _life.duration = Duration(milliseconds: _reduceMotion ? 180 : 560);
    _life.reverse();
  }

  void _handleStatus(AnimationStatus status) {
    if (status == AnimationStatus.dismissed && _exiting && mounted) {
      widget.onFinished();
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;
    final panelProgress = _exiting
        ? ((_life.value - 0.4) / 0.6).clamp(0.0, 1.0)
        : _life.value;
    final backgroundOpacity = _exiting
        ? (_life.value / 0.4).clamp(0.0, 1.0)
        : 1.0;

    return Semantics(
      container: true,
      liveRegion: true,
      label: l10n.t('terminal.a11yLabel'),
      child: Opacity(
        opacity: backgroundOpacity,
        child: AmbientBackground(
          child: Material(
            color: Colors.transparent,
            child: SafeArea(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final horizontal = context.isMobile ? 20.0 : 32.0;
                  return SingleChildScrollView(
                    padding: EdgeInsets.symmetric(
                      horizontal: horizontal,
                      vertical: 24,
                    ),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: (constraints.maxHeight - 48).clamp(
                          0.0,
                          double.infinity,
                        ),
                      ),
                      child: Center(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 640),
                          child: SizedBox(
                            width: double.infinity,
                            child: Opacity(
                              opacity: panelProgress,
                              child: Transform.scale(
                                scale: 0.96 + (0.04 * panelProgress),
                                child: _TerminalPanel(
                                  colors: colors,
                                  reduceMotion: _reduceMotion,
                                  visibleCommands: _visibleCommands,
                                  showSuccess: _showSuccess,
                                  showWelcome: _showWelcome,
                                  cursorOpacity: _cursorOpacity,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _TerminalPanel extends StatelessWidget {
  const _TerminalPanel({
    required this.colors,
    required this.reduceMotion,
    required this.visibleCommands,
    required this.showSuccess,
    required this.showWelcome,
    required this.cursorOpacity,
  });

  final PortfolioColors colors;
  final bool reduceMotion;
  final int visibleCommands;
  final bool showSuccess;
  final bool showWelcome;
  final Animation<double> cursorOpacity;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final radius = BorderRadius.circular(18);
    final commands = [
      l10n.t('terminal.initPortfolio'),
      l10n.t('terminal.loadProfile'),
      l10n.t('terminal.prepareProjects'),
      l10n.t('terminal.initInterface'),
      l10n.t('terminal.loadResources'),
      l10n.t('terminal.checkState'),
    ];
    final monoSize = context.isMobile ? 12.0 : 13.0;

    return Container(
      decoration: BoxDecoration(
        color: colors.codeBackground.withValues(alpha: 0.97),
        borderRadius: radius,
        border: Border.all(color: colors.accent.withValues(alpha: 0.34)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: context.isDark ? 0.34 : 0.16),
            blurRadius: 30,
            offset: const Offset(0, 16),
          ),
          BoxShadow(
            color: colors.accent.withValues(alpha: 0.1),
            blurRadius: 34,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: radius,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: colors.surfaceAlt.withValues(alpha: 0.78),
                border: Border(
                  bottom: BorderSide(
                    color: colors.border.withValues(alpha: 0.45),
                  ),
                ),
              ),
              child: Row(
                children: [
                  _WindowDot(color: colors.danger),
                  const SizedBox(width: 6),
                  _WindowDot(color: colors.warning),
                  const SizedBox(width: 6),
                  _WindowDot(color: colors.success),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      l10n.t('terminal.windowTitle'),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: AppTheme.mono(
                        color: colors.muted,
                        size: 10.5,
                        weight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Icon(
                    Icons.terminal_rounded,
                    size: 15,
                    color: colors.accent.withValues(alpha: 0.75),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(context.isMobile ? 18 : 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.t('terminal.name'),
                    style: AppTheme.mono(
                      color: colors.accent,
                      size: context.isMobile ? 19 : 22,
                      weight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    l10n.t('terminal.subtitle'),
                    style: AppTheme.mono(
                      color: colors.muted,
                      size: context.isMobile ? 10 : 11,
                      weight: FontWeight.w600,
                    ).copyWith(letterSpacing: 1.1),
                  ),
                  const SizedBox(height: 14),
                  Container(
                    height: 1,
                    color: colors.border.withValues(alpha: 0.55),
                  ),
                  const SizedBox(height: 14),
                  _MessagesSize(
                    reduceMotion: reduceMotion,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        for (var i = 0; i < visibleCommands; i++)
                          _TerminalLineReveal(
                            key: ValueKey('command-$i'),
                            reduceMotion: reduceMotion,
                            child: _CommandLine(
                              text: commands[i],
                              monoSize: monoSize,
                              showCursor:
                                  i == visibleCommands - 1 && !showSuccess,
                              cursorOpacity: cursorOpacity,
                            ),
                          ),
                        if (showSuccess)
                          _TerminalLineReveal(
                            key: const ValueKey('success'),
                            reduceMotion: reduceMotion,
                            child: _SuccessLine(
                              monoSize: monoSize,
                              tag: l10n.t('terminal.successTag'),
                              message: l10n.t('terminal.success'),
                            ),
                          ),
                        if (showWelcome)
                          _TerminalLineReveal(
                            key: const ValueKey('welcome'),
                            reduceMotion: reduceMotion,
                            child: Container(
                              margin: const EdgeInsets.only(top: 10),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 10,
                              ),
                              decoration: BoxDecoration(
                                color: colors.accent.withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: colors.accent.withValues(alpha: 0.32),
                                ),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.check_circle_outline_rounded,
                                    size: 16,
                                    color: colors.accent,
                                  ),
                                  const SizedBox(width: 8),
                                  Flexible(
                                    child: Text(
                                      l10n.t('terminal.welcome'),
                                      style: AppTheme.mono(
                                        color: colors.accent,
                                        size: context.isMobile ? 11 : 12,
                                        weight: FontWeight.w800,
                                      ).copyWith(letterSpacing: 0.5),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),
                  _TerminalProgress(
                    complete: showSuccess,
                    reduceMotion: reduceMotion,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MessagesSize extends StatelessWidget {
  const _MessagesSize({required this.reduceMotion, required this.child});

  final bool reduceMotion;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    if (reduceMotion) return child;
    return AnimatedSize(
      alignment: Alignment.topCenter,
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOutCubic,
      child: child,
    );
  }
}

class _CommandLine extends StatelessWidget {
  const _CommandLine({
    required this.text,
    required this.monoSize,
    required this.showCursor,
    required this.cursorOpacity,
  });

  final String text;
  final double monoSize;
  final bool showCursor;
  final Animation<double> cursorOpacity;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Padding(
      padding: const EdgeInsets.only(bottom: 7),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '>',
            style: AppTheme.mono(
              color: colors.accent,
              size: monoSize,
              weight: FontWeight.w700,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: AppTheme.mono(
                color: colors.text,
                size: monoSize,
                weight: FontWeight.w500,
              ),
            ),
          ),
          if (showCursor) ...[
            const SizedBox(width: 4),
            FadeTransition(
              opacity: cursorOpacity,
              child: Container(
                width: 7,
                height: monoSize + 3,
                margin: const EdgeInsets.only(top: 3),
                decoration: BoxDecoration(
                  color: colors.accent,
                  borderRadius: BorderRadius.circular(1.5),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _SuccessLine extends StatelessWidget {
  const _SuccessLine({
    required this.monoSize,
    required this.tag,
    required this.message,
  });

  final double monoSize;
  final String tag;
  final String message;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Padding(
      padding: const EdgeInsets.only(top: 4, bottom: 7),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '[$tag]',
            style: AppTheme.mono(
              color: colors.success,
              size: monoSize,
              weight: FontWeight.w800,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              message,
              style: AppTheme.mono(
                color: colors.success,
                size: monoSize,
                weight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TerminalLineReveal extends StatelessWidget {
  const _TerminalLineReveal({
    super.key,
    required this.child,
    required this.reduceMotion,
  });

  final Widget child;
  final bool reduceMotion;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0, end: 1),
      duration: reduceMotion
          ? Duration.zero
          : const Duration(milliseconds: 220),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, (1 - value) * 6),
            child: child,
          ),
        );
      },
      child: child,
    );
  }
}

class _TerminalProgress extends StatelessWidget {
  const _TerminalProgress({required this.complete, required this.reduceMotion});

  final bool complete;
  final bool reduceMotion;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;
    final bar = ClipRRect(
      borderRadius: BorderRadius.circular(999),
      child: complete
          ? LinearProgressIndicator(
              value: 1,
              minHeight: 4,
              backgroundColor: colors.accent.withValues(alpha: 0.12),
              valueColor: AlwaysStoppedAnimation<Color>(colors.success),
            )
          : reduceMotion
          ? Container(height: 4, color: colors.accent.withValues(alpha: 0.3))
          : LinearProgressIndicator(
              minHeight: 4,
              backgroundColor: colors.accent.withValues(alpha: 0.12),
              valueColor: AlwaysStoppedAnimation<Color>(colors.accent),
            ),
    );

    return Row(
      children: [
        Expanded(child: bar),
        const SizedBox(width: 12),
        AnimatedSwitcher(
          duration: reduceMotion
              ? Duration.zero
              : const Duration(milliseconds: 200),
          child: complete
              ? Row(
                  key: const ValueKey('ready'),
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.check_rounded, size: 14, color: colors.success),
                    const SizedBox(width: 4),
                    Text(
                      l10n.t('terminal.ready'),
                      style: AppTheme.mono(
                        color: colors.success,
                        size: 9.5,
                        weight: FontWeight.w800,
                      ),
                    ),
                  ],
                )
              : Text(
                  l10n.t('terminal.initializing'),
                  key: const ValueKey('initializing'),
                  style: AppTheme.mono(
                    color: colors.muted,
                    size: 9.5,
                    weight: FontWeight.w700,
                  ),
                ),
        ),
      ],
    );
  }
}

class _WindowDot extends StatelessWidget {
  const _WindowDot({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 9,
      height: 9,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.8),
        shape: BoxShape.circle,
      ),
    );
  }
}
