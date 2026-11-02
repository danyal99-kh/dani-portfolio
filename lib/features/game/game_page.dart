import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

import '../../app/localization/app_localizations.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_theme.dart';
import '../../core/utils/responsive.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/reveal_on_mount.dart';
import '../../core/widgets/section_header.dart';

enum _GamePhase { idle, playing, over }

class GamePage extends StatefulWidget {
  const GamePage({super.key});

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  static const _cellCount = 16;
  static const _gameSeconds = 30;

  final _random = Random();
  final Map<int, DateTime> _bugs = {};

  Timer? _spawnTimer;
  Timer? _cleanupTimer;
  Timer? _countdownTimer;

  _GamePhase _phase = _GamePhase.idle;
  int _score = 0;
  int _seconds = _gameSeconds;
  int _best = 0;
  bool _newBest = false;

  @override
  void dispose() {
    _cancelTimers();
    super.dispose();
  }

  void _cancelTimers() {
    _spawnTimer?.cancel();
    _cleanupTimer?.cancel();
    _countdownTimer?.cancel();
    _spawnTimer = null;
    _cleanupTimer = null;
    _countdownTimer = null;
  }

  void _startGame() {
    _cancelTimers();
    setState(() {
      _bugs.clear();
      _score = 0;
      _seconds = _gameSeconds;
      _newBest = false;
      _phase = _GamePhase.playing;
    });
    _spawnBug();
    _spawnTimer = Timer.periodic(
      const Duration(milliseconds: 680),
      (_) => _spawnBug(),
    );
    _cleanupTimer = Timer.periodic(
      const Duration(milliseconds: 160),
      (_) => _removeExpiredBugs(),
    );
    _countdownTimer = Timer.periodic(
      const Duration(seconds: 1),
      (_) => _tick(),
    );
  }

  void _spawnBug() {
    if (!mounted || _phase != _GamePhase.playing) return;
    if (_bugs.length >= 5) return;
    final freeCells = [
      for (var i = 0; i < _cellCount; i++)
        if (!_bugs.containsKey(i)) i,
    ];
    if (freeCells.isEmpty) return;
    final cell = freeCells[_random.nextInt(freeCells.length)];
    setState(() {
      _bugs[cell] = DateTime.now().add(const Duration(milliseconds: 1650));
    });
  }

  void _removeExpiredBugs() {
    if (!mounted || _phase != _GamePhase.playing) return;
    final now = DateTime.now();
    final expired = _bugs.entries
        .where((entry) => entry.value.isBefore(now))
        .map((entry) => entry.key)
        .toList();
    if (expired.isEmpty) return;
    setState(() {
      for (final cell in expired) {
        _bugs.remove(cell);
      }
    });
  }

  void _tick() {
    if (!mounted || _phase != _GamePhase.playing) return;
    if (_seconds <= 1) {
      _endGame();
      return;
    }
    setState(() => _seconds -= 1);
  }

  void _tapCell(int cell) {
    if (_phase != _GamePhase.playing || !_bugs.containsKey(cell)) return;
    setState(() {
      _bugs.remove(cell);
      _score += 1;
    });
  }

  void _endGame() {
    _cancelTimers();
    final newBest = _score > _best;
    setState(() {
      _phase = _GamePhase.over;
      _seconds = 0;
      _bugs.clear();
      _newBest = newBest;
      if (newBest) _best = _score;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;

    return ContentContainer(
      maxWidth: 1040,
      padding: EdgeInsets.only(
        left: context.pageHorizontalPadding,
        right: context.pageHorizontalPadding,
        top: context.isMobile ? 28 : 48,
        bottom: context.isMobile ? 56 : 80,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          PageHeader(
            eyebrow: l10n.t('game.easterEgg'),
            title: l10n.t('game.title'),
            subtitle: l10n.t('game.subtitle'),
            icon: Icons.sports_esports_outlined,
          ),
          SizedBox(height: context.sectionGap),
          if (context.isMobile)
            Column(
              children: [
                _GameBoard(
                  phase: _phase,
                  bugs: _bugs.keys.toSet(),
                  score: _score,
                  seconds: _seconds,
                  best: _best,
                  newBest: _newBest,
                  onStart: _startGame,
                  onTapCell: _tapCell,
                ),
                const SizedBox(height: 20),
                _SidePanel(l10n: l10n),
              ],
            )
          else
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 7,
                  child: _GameBoard(
                    phase: _phase,
                    bugs: _bugs.keys.toSet(),
                    score: _score,
                    seconds: _seconds,
                    best: _best,
                    newBest: _newBest,
                    onStart: _startGame,
                    onTapCell: _tapCell,
                  ),
                ),
                const SizedBox(width: 24),
                Expanded(flex: 4, child: _SidePanel(l10n: l10n)),
              ],
            ),
          const SizedBox(height: 20),
          Text(
            l10n.t('game.footer'),
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: colors.muted.withValues(alpha: 0.8),
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}

class _GameBoard extends StatelessWidget {
  const _GameBoard({
    required this.phase,
    required this.bugs,
    required this.score,
    required this.seconds,
    required this.best,
    required this.newBest,
    required this.onStart,
    required this.onTapCell,
  });

  final _GamePhase phase;
  final Set<int> bugs;
  final int score;
  final int seconds;
  final int best;
  final bool newBest;
  final VoidCallback onStart;
  final ValueChanged<int> onTapCell;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;

    return RevealOnMount(
      child: Container(
        padding: EdgeInsets.all(context.isMobile ? 16 : 20),
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: colors.border.withValues(alpha: 0.55)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 24,
              offset: const Offset(0, 12),
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              children: [
                _StatTile(
                  label: l10n.t('game.score'),
                  value: '$score',
                  icon: Icons.bolt_rounded,
                ),
                const SizedBox(width: 8),
                _StatTile(
                  label: l10n.t('game.time'),
                  value: '$seconds',
                  icon: Icons.timer_outlined,
                  warning: seconds <= 10 && phase == _GamePhase.playing,
                ),
                const SizedBox(width: 8),
                _StatTile(
                  label: l10n.t('game.bestScore'),
                  value: '$best',
                  icon: Icons.emoji_events_outlined,
                ),
              ],
            ),
            const SizedBox(height: 14),
            AspectRatio(
              aspectRatio: 1,
              child: Stack(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: colors.codeBackground,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(
                        color: colors.border.withValues(alpha: 0.5),
                      ),
                    ),
                    child: GridView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.zero,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 4,
                            mainAxisSpacing: 7,
                            crossAxisSpacing: 7,
                          ),
                      itemCount: _GamePageState._cellCount,
                      itemBuilder: (context, index) {
                        return _BugCell(
                          hasBug: bugs.contains(index),
                          enabled: phase == _GamePhase.playing,
                          onTap: () => onTapCell(index),
                        );
                      },
                    ),
                  ),
                  if (phase != _GamePhase.playing)
                    Positioned.fill(
                      child: _Overlay(
                        phase: phase,
                        score: score,
                        best: best,
                        newBest: newBest,
                        onStart: onStart,
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.touch_app_outlined, size: 15, color: colors.muted),
                const SizedBox(width: 6),
                Flexible(
                  child: Text(
                    l10n.t('game.instructions'),
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodySmall
                        ?.copyWith(color: colors.muted, fontSize: 11),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _BugCell extends StatefulWidget {
  const _BugCell({
    required this.hasBug,
    required this.enabled,
    required this.onTap,
  });

  final bool hasBug;
  final bool enabled;
  final VoidCallback onTap;

  @override
  State<_BugCell> createState() => _BugCellState();
}

class _BugCellState extends State<_BugCell> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return MouseRegion(
      cursor: widget.hasBug
          ? SystemMouseCursors.click
          : SystemMouseCursors.basic,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: Semantics(
        button: widget.hasBug,
        label: widget.hasBug ? 'Bug' : 'Empty cell',
        child: GestureDetector(
          onTap: widget.enabled && widget.hasBug ? widget.onTap : null,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 140),
            decoration: BoxDecoration(
              color: widget.hasBug
                  ? colors.accent.withValues(alpha: _hovered ? 0.24 : 0.16)
                  : colors.surfaceAlt.withValues(alpha: 0.6),
              borderRadius: BorderRadius.circular(13),
              border: Border.all(
                color: widget.hasBug
                    ? colors.accent.withValues(alpha: 0.65)
                    : colors.border.withValues(alpha: 0.35),
                width: widget.hasBug ? 1.4 : 1,
              ),
              boxShadow: widget.hasBug
                  ? [
                      BoxShadow(
                        color: colors.accent.withValues(alpha: 0.16),
                        blurRadius: 12,
                      ),
                    ]
                  : const [],
            ),
            child: Center(
              child: AnimatedScale(
                scale: widget.hasBug ? 1 : 0.7,
                duration: const Duration(milliseconds: 140),
                child: Icon(
                  widget.hasBug ? Icons.bug_report_rounded : Icons.code_rounded,
                  size: widget.hasBug ? 31 : 14,
                  color: widget.hasBug
                      ? colors.accent
                      : colors.muted.withValues(alpha: 0.25),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile({
    required this.label,
    required this.value,
    required this.icon,
    this.warning = false,
  });

  final String label;
  final String value;
  final IconData icon;
  final bool warning;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final color = warning ? colors.danger : colors.accent;
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.09),
          borderRadius: BorderRadius.circular(11),
          border: Border.all(color: color.withValues(alpha: 0.22)),
        ),
        child: Row(
          children: [
            Icon(icon, size: 15, color: color),
            const SizedBox(width: 6),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.labelSmall
                        ?.copyWith(color: colors.muted, fontSize: 9.5),
                  ),
                  Text(
                    value,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: color,
                      fontWeight: FontWeight.w800,
                      fontFamily: 'JetBrainsMono',
                    ),
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

class _Overlay extends StatelessWidget {
  const _Overlay({
    required this.phase,
    required this.score,
    required this.best,
    required this.newBest,
    required this.onStart,
  });

  final _GamePhase phase;
  final int score;
  final int best;
  final bool newBest;
  final VoidCallback onStart;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    final idle = phase == _GamePhase.idle;

    return Container(
      decoration: BoxDecoration(
        color: colors.background.withValues(alpha: 0.82),
        borderRadius: BorderRadius.circular(18),
      ),
      padding: const EdgeInsets.all(18),
      child: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 54,
                height: 54,
                decoration: BoxDecoration(
                  color: colors.accent.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Icon(
                  idle
                      ? Icons.sports_esports_outlined
                      : Icons.emoji_events_outlined,
                  color: colors.accent,
                  size: 27,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                idle ? l10n.t('game.ready') : l10n.t('game.timeUp'),
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 5),
              Text(
                idle
                    ? l10n.t('game.idleText')
                    : '${l10n.t('game.yourScore')}: $score',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodySmall
                    ?.copyWith(color: colors.muted, height: 1.6),
              ),
              if (!idle && newBest) ...[
                const SizedBox(height: 6),
                Text(
                  l10n.t('game.newBest'),
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: colors.success,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
              if (!idle) ...[
                const SizedBox(height: 4),
                Text(
                  '${l10n.t('game.bestScore')}: $best',
                  style: Theme.of(context).textTheme.labelSmall
                      ?.copyWith(color: colors.muted),
                ),
              ],
              const SizedBox(height: 14),
              AppButton(
                label: idle ? l10n.t('game.start') : l10n.t('game.restart'),
                onPressed: onStart,
                icon: idle ? Icons.play_arrow_rounded : Icons.refresh_rounded,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SidePanel extends StatelessWidget {
  const _SidePanel({required this.l10n});

  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return RevealOnMount(
      delay: const Duration(milliseconds: 100),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: colors.codeBackground,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: colors.border.withValues(alpha: 0.5)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.terminal_rounded, size: 18, color: colors.accent),
                const SizedBox(width: 8),
                Text(
                  l10n.t('game.bugSquasher'),
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
            const SizedBox(height: 14),
            Text(
              '// ${l10n.t('game.instructions')}',
              style: AppTheme.mono(color: colors.muted, size: 11),
            ),
            const SizedBox(height: 16),
            _RuleRow(
              icon: Icons.bug_report_rounded,
              text: l10n.t('game.tapBug'),
            ),
            const SizedBox(height: 10),
            _RuleRow(
              icon: Icons.timer_outlined,
              text:
                  '${_GamePageState._gameSeconds} ${l10n.t('common.seconds')}',
            ),
            const SizedBox(height: 10),
            _RuleRow(
              icon: Icons.emoji_events_outlined,
              text: l10n.t('game.bestScore'),
            ),
            const SizedBox(height: 18),
            Divider(color: colors.border.withValues(alpha: 0.4)),
            const SizedBox(height: 12),
            Text(
              l10n.t('game.footer'),
              style: Theme.of(context).textTheme.bodySmall
                  ?.copyWith(color: colors.muted, fontSize: 11, height: 1.6),
            ),
          ],
        ),
      ),
    );
  }
}

class _RuleRow extends StatelessWidget {
  const _RuleRow({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Row(
      children: [
        Icon(icon, size: 16, color: colors.accent),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: Theme.of(context).textTheme.bodySmall
                ?.copyWith(color: colors.muted),
          ),
        ),
      ],
    );
  }
}
