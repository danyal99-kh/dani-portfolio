import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../app/localization/app_localizations.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_theme.dart';
import '../../core/utils/link_service.dart';
import '../../core/utils/responsive.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/app_image.dart';
import '../../core/widgets/empty_state.dart';
import '../../core/widgets/hover_card.dart';
import '../../core/widgets/responsive_grid.dart';
import '../../core/widgets/reveal_on_mount.dart';
import '../../core/widgets/status_badge.dart';
import '../../core/widgets/tech_chip.dart';
import '../../data/content/projects_data.dart';
import '../../data/models/project.dart';

class CaseStudyPage extends StatelessWidget {
  const CaseStudyPage({super.key, required this.projectId});

  final String projectId;

  @override
  Widget build(BuildContext context) {
    final project = projectById(projectId);
    if (project == null) {
      return _NotFound();
    }
    return _CaseStudyContent(project: project);
  }
}

class _NotFound extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return ContentContainer(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 80),
        child: EmptyState(
          icon: Icons.work_off_outlined,
          title: l10n.t('case.notFound'),
          message: l10n.t('common.noResultsHint'),
          actionLabel: l10n.t('common.backToProjects'),
          onAction: () => context.go('/projects'),
        ),
      ),
    );
  }
}

class _CaseStudyContent extends StatelessWidget {
  const _CaseStudyContent({required this.project});

  final Project project;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    final isFa = l10n.isFa;
    final index = projects.indexWhere((item) => item.id == project.id);
    final previous = index > 0 ? projects[index - 1] : null;
    final next = index < projects.length - 1 ? projects[index + 1] : null;

    return ContentContainer(
      maxWidth: 1120,
      padding: EdgeInsets.only(
        left: context.pageHorizontalPadding,
        right: context.pageHorizontalPadding,
        top: context.isMobile ? 24 : 40,
        bottom: context.isMobile ? 56 : 80,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: TextButton.icon(
              onPressed: () => context.go('/projects'),
              icon: Icon(
                Directionality.of(context) == TextDirection.rtl
                    ? Icons.arrow_forward_rounded
                    : Icons.arrow_back_rounded,
                size: 17,
              ),
              label: Text(l10n.t('common.backToProjects')),
            ),
          ),
          const SizedBox(height: 14),
          RevealOnMount(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    StatusBadge(status: project.status),
                    const SizedBox(width: 8),
                    if (project.featured)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 9,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: colors.warning.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(999),
                          border: Border.all(
                            color: colors.warning.withValues(alpha: 0.4),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.star_rounded,
                              size: 12,
                              color: colors.warning,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              l10n.t('common.featured'),
                              style: Theme.of(context).textTheme.labelSmall
                                  ?.copyWith(
                                    color: colors.warning,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 10,
                                  ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 14),
                Text(
                  project.category(isFa).toUpperCase(),
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: colors.accent,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.1,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  project.name,
                  style: context.isMobile
                      ? Theme.of(context).textTheme.displaySmall
                      : Theme.of(context).textTheme.displayMedium,
                ),
                const SizedBox(height: 12),
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 780),
                  child: Text(
                    project.summary(isFa),
                    style: Theme.of(context).textTheme.bodyLarge
                        ?.copyWith(color: colors.muted),
                  ),
                ),
                const SizedBox(height: 18),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _MetaChip(
                      icon: Icons.work_outline_rounded,
                      label: project.role(isFa),
                    ),
                    _MetaChip(
                      icon: Icons.schedule_rounded,
                      label: project.timeline(isFa),
                    ),
                    _MetaChip(
                      icon: Icons.category_outlined,
                      label: project.category(isFa),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 28),
          RevealOnMount(
            delay: const Duration(milliseconds: 80),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: Stack(
                children: [
                  AppImage(
                    asset: project.imageAsset,
                    width: double.infinity,
                    height: context.isMobile ? 220 : 380,
                    borderRadius: 24,
                  ),
                  Positioned(
                    bottom: 14,
                    left: 14,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: colors.background.withValues(alpha: 0.82),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        l10n.t('common.sampleContent'),
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: colors.muted,
                          fontWeight: FontWeight.w600,
                          fontSize: 10,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: context.sectionGap),
          RevealOnMount(
            child: _SectionBlock(
              number: '01',
              title: l10n.t('case.overview'),
              child: Text(
                project.caseStudy.intro(isFa),
                style: Theme.of(context).textTheme.bodyLarge
                    ?.copyWith(color: colors.muted),
              ),
            ),
          ),
          const SizedBox(height: 20),
          ResponsiveGrid(
            minItemWidth: 320,
            maxColumns: 2,
            children: [
              RevealOnMount(
                child: _TextCard(
                  icon: Icons.report_problem_outlined,
                  title: l10n.t('case.problem'),
                  body: project.caseStudy.problem(isFa),
                  accent: colors.warning,
                ),
              ),
              RevealOnMount(
                delay: const Duration(milliseconds: 70),
                child: _TextCard(
                  icon: Icons.lightbulb_outline_rounded,
                  title: l10n.t('case.solution'),
                  body: project.caseStudy.solution(isFa),
                  accent: colors.success,
                ),
              ),
            ],
          ),
          SizedBox(height: context.sectionGap),
          RevealOnMount(
            child: _SectionBlock(
              number: '02',
              title: l10n.t('case.highlights'),
              child: ResponsiveGrid(
                minItemWidth: 220,
                maxColumns: 3,
                children: [
                  for (final highlight in project.caseStudy.highlights)
                    HoverCard(
                      lift: false,
                      padding: const EdgeInsets.all(18),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.check_circle_outline_rounded,
                            color: colors.accent,
                            size: 20,
                          ),
                          const SizedBox(height: 10),
                          Text(
                            highlight.title(isFa),
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                          const SizedBox(height: 5),
                          Text(
                            highlight.description(isFa),
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(color: colors.muted, height: 1.6),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),
          SizedBox(height: context.sectionGap),
          RevealOnMount(
            child: _SectionBlock(
              number: '03',
              title: l10n.t('case.architecture'),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _ArchitectureDiagram(project: project),
                  const SizedBox(height: 16),
                  Text(
                    project.caseStudy.architecture(isFa),
                    style: Theme.of(context).textTheme.bodyLarge
                        ?.copyWith(color: colors.muted),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    l10n.t('case.architectureNote'),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: colors.muted.withValues(alpha: 0.8),
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: context.sectionGap),
          RevealOnMount(
            child: _SectionBlock(
              number: '04',
              title: l10n.t('case.challenges'),
              child: _TextCard(
                icon: Icons.route_outlined,
                title: l10n.t('case.challenges'),
                body: project.caseStudy.challenges(isFa),
                accent: colors.accentStrong,
              ),
            ),
          ),
          SizedBox(height: context.sectionGap),
          RevealOnMount(
            child: _SectionBlock(
              number: '05',
              title: l10n.t('case.techStack'),
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final tech in project.tech) TechChip(label: tech),
                ],
              ),
            ),
          ),
          SizedBox(height: context.sectionGap),
          RevealOnMount(
            child: _SectionBlock(
              number: '06',
              title: l10n.t('case.gallery'),
              child: _Gallery(project: project),
            ),
          ),
          SizedBox(height: context.sectionGap),
          RevealOnMount(
            child: _SectionBlock(
              number: '07',
              title: l10n.t('case.links'),
              child: _Links(project: project),
            ),
          ),
          SizedBox(height: context.sectionGap),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: colors.surfaceAlt,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: colors.border.withValues(alpha: 0.5)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.info_outline_rounded, size: 18, color: colors.muted),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    l10n.t('case.sampleNote'),
                    style: Theme.of(context).textTheme.bodySmall
                        ?.copyWith(color: colors.muted, height: 1.6),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 28),
          _ProjectPager(previous: previous, next: next),
        ],
      ),
    );
  }
}

class _MetaChip extends StatelessWidget {
  const _MetaChip({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: colors.surfaceAlt,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: colors.border.withValues(alpha: 0.5)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: colors.muted),
          const SizedBox(width: 6),
          Flexible(
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodySmall
                  ?.copyWith(color: colors.muted),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionBlock extends StatelessWidget {
  const _SectionBlock({
    required this.number,
    required this.title,
    required this.child,
  });

  final String number;
  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Text(
              number,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: colors.accent,
                fontFamily: 'JetBrainsMono',
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(width: 10),
            Container(
              width: 28,
              height: 1,
              color: colors.accent.withValues(alpha: 0.5),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                title,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        child,
      ],
    );
  }
}

class _TextCard extends StatelessWidget {
  const _TextCard({
    required this.icon,
    required this.title,
    required this.body,
    required this.accent,
  });

  final IconData icon;
  final String title;
  final String body;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return HoverCard(
      lift: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: accent.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: accent, size: 20),
          ),
          const SizedBox(height: 14),
          Text(title, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          Text(
            body,
            style: Theme.of(context).textTheme.bodySmall
                ?.copyWith(color: colors.muted, height: 1.75),
          ),
        ],
      ),
    );
  }
}

class _ArchitectureDiagram extends StatelessWidget {
  const _ArchitectureDiagram({required this.project});

  final Project project;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    final layers = [
      (Icons.phone_iphone_rounded, l10n.t('case.architectureClient')),
      (Icons.api_rounded, l10n.t('case.architectureApi')),
      (Icons.storage_rounded, l10n.t('case.architectureData')),
    ];

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colors.surfaceAlt,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: colors.border.withValues(alpha: 0.5)),
      ),
      child: context.isMobile
          ? Column(
              children: [
                for (var i = 0; i < layers.length; i++) ...[
                  _LayerBox(
                    icon: layers[i].$1,
                    label: layers[i].$2,
                    project: project,
                  ),
                  if (i < layers.length - 1)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: Icon(
                        Icons.south_rounded,
                        size: 18,
                        color: colors.accent,
                      ),
                    ),
                ],
              ],
            )
          : Row(
              children: [
                for (var i = 0; i < layers.length; i++) ...[
                  Expanded(
                    child: _LayerBox(
                      icon: layers[i].$1,
                      label: layers[i].$2,
                      project: project,
                    ),
                  ),
                  if (i < layers.length - 1)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Icon(
                        Directionality.of(context) == TextDirection.rtl
                            ? Icons.west_rounded
                            : Icons.east_rounded,
                        size: 18,
                        color: colors.accent,
                      ),
                    ),
                ],
              ],
            ),
    );
  }
}

class _LayerBox extends StatelessWidget {
  const _LayerBox({
    required this.icon,
    required this.label,
    required this.project,
  });

  final IconData icon;
  final String label;
  final Project project;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(13),
        border: Border.all(color: colors.accent.withValues(alpha: 0.25)),
      ),
      child: Column(
        children: [
          Icon(icon, color: colors.accent, size: 22),
          const SizedBox(height: 8),
          Text(
            label,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.labelMedium
                ?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 4),
          Text(
            project.tech.take(2).join(' · '),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodySmall
                ?.copyWith(color: colors.muted, fontSize: 10),
          ),
        ],
      ),
    );
  }
}

class _Gallery extends StatelessWidget {
  const _Gallery({required this.project});

  final Project project;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    final isFa = l10n.isFa;

    return ResponsiveGrid(
      minItemWidth: 320,
      maxColumns: 2,
      children: [
        AppImage(
          asset: project.imageAsset,
          height: 230,
          width: double.infinity,
          borderRadius: 18,
        ),
        Container(
          height: 230,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: colors.codeBackground,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: colors.border.withValues(alpha: 0.5)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: colors.success,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 7),
                  Text(
                    '${project.name.toLowerCase().replaceAll(' ', '-')}.ui',
                    style: AppTheme.mono(color: colors.muted, size: 11),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: colors.surface,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.phone_iphone_rounded,
                      size: 17,
                      color: colors.accent,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        project.category(isFa),
                        style: Theme.of(context).textTheme.labelSmall
                            ?.copyWith(color: colors.muted),
                      ),
                    ),
                    Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: colors.accent,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: colors.surface,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 7,
                        width: 120,
                        decoration: BoxDecoration(
                          color: colors.accent.withValues(alpha: 0.4),
                          borderRadius: BorderRadius.circular(99),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        height: 6,
                        width: 180,
                        decoration: BoxDecoration(
                          color: colors.border.withValues(alpha: 0.6),
                          borderRadius: BorderRadius.circular(99),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        height: 6,
                        width: 140,
                        decoration: BoxDecoration(
                          color: colors.border.withValues(alpha: 0.4),
                          borderRadius: BorderRadius.circular(99),
                        ),
                      ),
                      const Spacer(),
                      Align(
                        alignment: AlignmentDirectional.centerEnd,
                        child: Icon(
                          Icons.touch_app_outlined,
                          size: 18,
                          color: colors.muted,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                l10n.t('common.sampleContent'),
                style: Theme.of(context).textTheme.bodySmall
                    ?.copyWith(color: colors.muted, fontSize: 10),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _Links extends StatelessWidget {
  const _Links({required this.project});

  final Project project;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            if (project.hasRepo)
              AppButton(
                label: l10n.t('common.sourceCode'),
                onPressed: () => openExternalLink(
                  context,
                  project.repoUrl!,
                  isPlaceholder: project.repoIsPlaceholder,
                ),
                icon: project.repoIsPlaceholder
                    ? Icons.link_off_rounded
                    : Icons.code_rounded,
                variant: AppButtonVariant.secondary,
              ),
            if (project.hasDemo)
              AppButton(
                label: l10n.t('common.liveDemo'),
                onPressed: () => openExternalLink(
                  context,
                  project.demoUrl!,
                  isPlaceholder: project.demoIsPlaceholder,
                ),
                icon: project.demoIsPlaceholder
                    ? Icons.link_off_rounded
                    : Icons.open_in_new_rounded,
              ),
          ],
        ),
        if (project.repoIsPlaceholder || project.demoIsPlaceholder) ...[
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.info_outline_rounded, size: 16, color: colors.muted),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  l10n.t('common.placeholderLinkNotice'),
                  style: Theme.of(context).textTheme.bodySmall
                      ?.copyWith(color: colors.muted, height: 1.6),
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }
}

class _ProjectPager extends StatelessWidget {
  const _ProjectPager({required this.previous, required this.next});

  final Project? previous;
  final Project? next;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    if (previous == null && next == null) return const SizedBox.shrink();
    return Row(
      children: [
        if (previous != null)
          Expanded(
            child: _PagerCard(
              project: previous!,
              label: l10n.t('case.prevProject'),
              alignment: AlignmentDirectional.centerStart,
              icon: Directionality.of(context) == TextDirection.rtl
                  ? Icons.arrow_forward_rounded
                  : Icons.arrow_back_rounded,
            ),
          ),
        if (previous != null && next != null) const SizedBox(width: 14),
        if (next != null)
          Expanded(
            child: _PagerCard(
              project: next!,
              label: l10n.t('case.nextProject'),
              alignment: AlignmentDirectional.centerEnd,
              icon: Directionality.of(context) == TextDirection.rtl
                  ? Icons.arrow_back_rounded
                  : Icons.arrow_forward_rounded,
            ),
          ),
      ],
    );
  }
}

class _PagerCard extends StatelessWidget {
  const _PagerCard({
    required this.project,
    required this.label,
    required this.alignment,
    required this.icon,
  });

  final Project project;
  final String label;
  final AlignmentGeometry alignment;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return HoverCard(
      onTap: () => context.go('/projects/${project.id}'),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: alignment,
            child: Icon(icon, size: 17, color: colors.accent),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: Theme.of(context).textTheme.labelSmall
                ?.copyWith(color: colors.muted),
          ),
          const SizedBox(height: 3),
          Text(
            project.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.titleSmall
                ?.copyWith(fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}
