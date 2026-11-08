import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../app/localization/app_localizations.dart';
import '../../app/theme/app_colors.dart';
import '../../core/utils/responsive.dart';
import '../../data/models/project.dart';
import 'app_image.dart';
import 'status_badge.dart';
import 'tech_chip.dart';

class ProjectCard extends StatefulWidget {
  const ProjectCard({
    super.key,
    required this.project,
    required this.index,
    this.entrance,
  });

  final Project project;
  final int index;
  final Animation<double>? entrance;

  @override
  State<ProjectCard> createState() => _ProjectCardState();
}

class _ProjectCardState extends State<ProjectCard> {
  bool _hovered = false;
  bool _pressed = false;

  bool get _active => _hovered || _pressed;

  void _setHovered(bool value) {
    if (_hovered == value) return;
    setState(() => _hovered = value);
  }

  void _setPressed(bool value) {
    if (_pressed == value) return;
    setState(() => _pressed = value);
  }

  void _openCaseStudy() => context.go('/projects/${widget.project.id}');

  @override
  Widget build(BuildContext context) {
    final project = widget.project;
    final colors = context.colors;
    final l10n = context.l10n;
    final isFa = l10n.isFa;
    final accent = _projectAccent(context, project.id);
    final reduceMotion = context.reduceMotion;
    final radius = BorderRadius.circular(context.isMobile ? 20 : 22);
    final duration = reduceMotion
        ? Duration.zero
        : const Duration(milliseconds: 180);

    return Semantics(
      button: true,
      label: '${project.name} — ${l10n.t('common.viewCaseStudy')}',
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => _setHovered(true),
        onExit: (_) => _setHovered(false),
        child: AnimatedScale(
          scale: reduceMotion || !_pressed ? 1 : 0.986,
          duration: const Duration(milliseconds: 120),
          curve: Curves.easeOutCubic,
          child: AnimatedContainer(
            duration: duration,
            curve: Curves.easeOutCubic,
            decoration: BoxDecoration(
              color: colors.surface,
              borderRadius: radius,
              border: Border.all(
                color: _active
                    ? accent.withValues(alpha: 0.55)
                    : colors.border.withValues(alpha: 0.55),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(
                    alpha: context.isDark ? 0.22 : 0.08,
                  ),
                  blurRadius: _active ? 24 : 14,
                  offset: Offset(0, _active ? 12 : 8),
                ),
                BoxShadow(
                  color: accent.withValues(alpha: _active ? 0.14 : 0.06),
                  blurRadius: _active ? 28 : 18,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: radius,
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: _openCaseStudy,
                  onHighlightChanged: _setPressed,
                  borderRadius: radius,
                  splashColor: accent.withValues(alpha: 0.1),
                  highlightColor: accent.withValues(alpha: 0.05),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _ProjectCover(
                        project: project,
                        index: widget.index,
                        accent: accent,
                        active: _active,
                        entrance:
                            widget.entrance ??
                            const AlwaysStoppedAnimation<double>(1),
                      ),
                      _ProjectInfo(
                        project: project,
                        accent: accent,
                        active: _active,
                        isFa: isFa,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ProjectCover extends StatelessWidget {
  const _ProjectCover({
    required this.project,
    required this.index,
    required this.accent,
    required this.active,
    required this.entrance,
  });

  final Project project;
  final int index;
  final Color accent;
  final bool active;
  final Animation<double> entrance;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;
    final reduceMotion = context.reduceMotion;
    final number = '${index + 1}'.padLeft(2, '0');
    final numberLabel = l10n
        .t('projects.cardNumber')
        .replaceAll('{number}', number);
    final isRtl = Directionality.of(context) == TextDirection.rtl;

    return AspectRatio(
      aspectRatio: 16 / 10,
      child: Stack(
        fit: StackFit.expand,
        children: [
          ColoredBox(
            color: accent.withValues(alpha: context.isDark ? 0.2 : 0.1),
          ),
          ScaleTransition(
            scale: entrance
                .drive(
                  CurveTween(
                    curve: Interval(0, 0.8, curve: Curves.easeOutCubic),
                  ),
                )
                .drive(Tween<double>(begin: 1.045, end: 1)),
            child: AnimatedScale(
              scale: reduceMotion || !active ? 1 : 1.035,
              duration: reduceMotion
                  ? Duration.zero
                  : const Duration(milliseconds: 480),
              curve: Curves.easeOutCubic,
              child: AppImage(
                asset: project.imageAsset,
                borderRadius: 0,
                semanticLabel: project.name,
              ),
            ),
          ),
          PositionedDirectional(
            top: -42,
            end: -28,
            child: IgnorePointer(
              child: Container(
                width: 168,
                height: 168,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      accent.withValues(alpha: context.isDark ? 0.3 : 0.2),
                      accent.withValues(alpha: 0),
                    ],
                  ),
                ),
              ),
            ),
          ),
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withValues(alpha: 0.18),
                  Colors.transparent,
                  accent.withValues(alpha: context.isDark ? 0.46 : 0.3),
                ],
                stops: const [0, 0.52, 1],
              ),
            ),
          ),
          PositionedDirectional(
            top: 12,
            start: 12,
            child: _CoverPill(
              accent: accent,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: accent,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    numberLabel,
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: accent,
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.7,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (project.featured)
            PositionedDirectional(
              top: 12,
              end: 12,
              child: _CoverPill(
                accent: accent,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.star_rounded, size: 11, color: colors.warning),
                    const SizedBox(width: 4),
                    Text(
                      l10n.t('common.featured'),
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: colors.text,
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          PositionedDirectional(
            bottom: 12,
            start: 12,
            child: StatusBadge(
              status: project.status,
              compact: true,
              accentColor: accent,
            ),
          ),
          PositionedDirectional(
            bottom: 0,
            start: 0,
            end: 0,
            child: IgnorePointer(
              child: Container(
                height: 2,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      accent.withValues(alpha: 0.7),
                      accent.withValues(alpha: 0),
                    ],
                    begin: isRtl ? Alignment.centerRight : Alignment.centerLeft,
                    end: isRtl ? Alignment.centerLeft : Alignment.centerRight,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CoverPill extends StatelessWidget {
  const _CoverPill({required this.accent, required this.child});

  final Color accent;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: colors.background.withValues(alpha: 0.86),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: accent.withValues(alpha: 0.38)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.12),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _ProjectInfo extends StatelessWidget {
  const _ProjectInfo({
    required this.project,
    required this.accent,
    required this.active,
    required this.isFa,
  });

  final Project project;
  final Color accent;
  final bool active;
  final bool isFa;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final remainingTech = project.tech.skip(3).toList();
    final mobile = context.isMobile;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(
        mobile ? 16 : 18,
        mobile ? 14 : 16,
        mobile ? 16 : 18,
        mobile ? 16 : 18,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            colors.surfaceAlt.withValues(alpha: context.isDark ? 0.45 : 0.55),
            colors.surface,
          ],
        ),
        border: Border(
          top: BorderSide(color: colors.border.withValues(alpha: 0.45)),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 6,
                height: 6,
                decoration: BoxDecoration(
                  color: accent,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 7),
              Expanded(
                child: Text(
                  project.category(isFa).toUpperCase(),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: accent,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.9,
                    fontSize: 10,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 7),
          Text(
            project.name,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.titleLarge
                ?.copyWith(fontWeight: FontWeight.w700, height: 1.18),
          ),
          const SizedBox(height: 6),
          Text(
            project.summary(isFa),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodySmall
                ?.copyWith(color: colors.muted, height: 1.55),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [
              for (final tech in project.tech.take(3))
                TechChip(
                  label: tech,
                  compact: true,
                  icon: _techIcon(tech),
                  accentColor: accent,
                  raised: true,
                ),
              if (remainingTech.isNotEmpty)
                Tooltip(
                  message: remainingTech.join(', '),
                  child: TechChip(
                    label: '+${remainingTech.length}',
                    compact: true,
                    icon: Icons.more_horiz_rounded,
                    accentColor: accent,
                    raised: true,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 14),
          _CaseStudyAction(
            accent: accent,
            active: active,
            reduceMotion: context.reduceMotion,
          ),
        ],
      ),
    );
  }
}

class _CaseStudyAction extends StatelessWidget {
  const _CaseStudyAction({
    required this.accent,
    required this.active,
    required this.reduceMotion,
  });

  final Color accent;
  final bool active;
  final bool reduceMotion;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final isRtl = Directionality.of(context) == TextDirection.rtl;
    final duration = reduceMotion
        ? Duration.zero
        : const Duration(milliseconds: 180);

    return AnimatedContainer(
      duration: duration,
      curve: Curves.easeOutCubic,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
      decoration: BoxDecoration(
        color: accent.withValues(alpha: active ? 0.18 : 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: accent.withValues(alpha: active ? 0.55 : 0.3),
        ),
        boxShadow: active
            ? [
                BoxShadow(
                  color: accent.withValues(alpha: 0.12),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ]
            : const [],
      ),
      child: Row(
        children: [
          Flexible(
            child: Text(
              l10n.t('common.viewCaseStudy'),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.labelLarge
                  ?.copyWith(color: accent, fontWeight: FontWeight.w700),
            ),
          ),
          const SizedBox(width: 8),
          AnimatedSlide(
            offset: reduceMotion || !active
                ? Offset.zero
                : Offset(isRtl ? -0.18 : 0.18, 0),
            duration: duration,
            curve: Curves.easeOutCubic,
            child: Icon(
              isRtl ? Icons.arrow_back_rounded : Icons.arrow_forward_rounded,
              size: 18,
              color: accent,
            ),
          ),
        ],
      ),
    );
  }
}

Color _projectAccent(BuildContext context, String id) {
  if (context.isDark) {
    return switch (id) {
      'lawin' => const Color(0xFF71D8CB),
      'azmode' => const Color(0xFFC0A6FF),
      'chatbot' => const Color(0xFF8CCBFF),
      'language-learning' => const Color(0xFFFFB877),
      'personal-accounting' => const Color(0xFFF1D37D),
      _ => context.colors.accent,
    };
  }
  return switch (id) {
    'lawin' => const Color(0xFF207F78),
    'azmode' => const Color(0xFF6D4BC3),
    'chatbot' => const Color(0xFF2E6FAE),
    'language-learning' => const Color(0xFFB86721),
    'personal-accounting' => const Color(0xFF8A6A1F),
    _ => context.colors.accent,
  };
}

IconData _techIcon(String tech) {
  final normalized = tech.toLowerCase();
  if (normalized.contains('flutter')) return Icons.flutter_dash_rounded;
  if (normalized.contains('dart')) return Icons.data_object_rounded;
  if (normalized.contains('django')) return Icons.api_rounded;
  if (normalized.contains('postgres') || normalized.contains('database')) {
    return Icons.storage_rounded;
  }
  if (normalized.contains('jwt') || normalized.contains('auth')) {
    return Icons.lock_outline_rounded;
  }
  if (normalized.contains('rest') || normalized.contains('api')) {
    return Icons.cloud_outlined;
  }
  if (normalized.contains('local data')) return Icons.save_outlined;
  return Icons.terminal_rounded;
}
