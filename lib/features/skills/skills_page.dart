import 'package:flutter/material.dart';

import '../../app/localization/app_localizations.dart';
import '../../app/theme/app_colors.dart';
import '../../core/utils/responsive.dart';
import '../../core/widgets/hover_card.dart';
import '../../core/widgets/responsive_grid.dart';
import '../../core/widgets/reveal_on_visible.dart';
import '../../core/widgets/section_header.dart';
import '../../core/widgets/tech_chip.dart';
import '../../data/content/skills_data.dart';
import '../../data/models/skill.dart';

class SkillsPage extends StatelessWidget {
  const SkillsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    final isFa = l10n.isFa;

    return ContentContainer(
      maxWidth: 1180,
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
            eyebrow: l10n.t('nav.skills'),
            title: l10n.t('skills.title'),
            subtitle: l10n.t('skills.subtitle'),
            icon: Icons.auto_awesome_outlined,
          ),
          const SizedBox(height: 20),
          RevealOnVisible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
              decoration: BoxDecoration(
                color: colors.accent.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: colors.accent.withValues(alpha: 0.22),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline_rounded,
                    size: 17,
                    color: colors.accent,
                  ),
                  const SizedBox(width: 9),
                  Expanded(
                    child: Text(
                      l10n.t('skills.noPercent'),
                      style: Theme.of(context).textTheme.bodySmall
                          ?.copyWith(color: colors.muted, height: 1.6),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: context.sectionGap),
          for (var i = 0; i < SkillCategory.values.length; i++) ...[
            if (i > 0) SizedBox(height: context.sectionGap),
            _CategorySection(
              category: SkillCategory.values[i],
              accent: _categoryColors(colors)[i],
              index: i,
            ),
          ],
          SizedBox(height: context.sectionGap),
          RevealOnVisible(child: _LearningCard(isFa: isFa)),
        ],
      ),
    );
  }

  static List<Color> _categoryColors(PortfolioColors colors) => [
    colors.accent,
    colors.accentStrong,
    colors.warning,
    colors.success,
  ];
}

class _CategorySection extends StatelessWidget {
  const _CategorySection({
    required this.category,
    required this.accent,
    required this.index,
  });

  final SkillCategory category;
  final Color accent;
  final int index;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    final isFa = l10n.isFa;
    final items = skills.where((skill) => skill.category == category).toList();

    return RevealOnVisible(
      delay: Duration(milliseconds: 50 * index),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: accent.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(13),
                  border: Border.all(color: accent.withValues(alpha: 0.28)),
                ),
                child: Icon(_categoryIcon(category), color: accent, size: 23),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.t(category.translationKey),
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      l10n.t(category.descriptionKey),
                      style: Theme.of(context).textTheme.bodySmall
                          ?.copyWith(color: colors.muted),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
                decoration: BoxDecoration(
                  color: colors.surfaceAlt,
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(
                    color: colors.border.withValues(alpha: 0.5),
                  ),
                ),
                child: Text(
                  '${items.length}',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: colors.muted,
                    fontFamily: 'JetBrainsMono',
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          ResponsiveGrid(
            minItemWidth: 210,
            maxColumns: 4,
            spacing: 14,
            children: [
              for (final skill in items)
                HoverCard(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 38,
                        height: 38,
                        decoration: BoxDecoration(
                          color: accent.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(skill.icon, color: accent, size: 19),
                      ),
                      const SizedBox(height: 13),
                      Text(
                        skill.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.titleSmall
                            ?.copyWith(fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        skill.note(isFa),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodySmall
                            ?.copyWith(color: colors.muted, height: 1.5),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  static IconData _categoryIcon(SkillCategory category) => switch (category) {
    SkillCategory.backend => Icons.dns_outlined,
    SkillCategory.mobile => Icons.phone_iphone_rounded,
    SkillCategory.database => Icons.storage_rounded,
    SkillCategory.tools => Icons.handyman_outlined,
  };
}

class _LearningCard extends StatelessWidget {
  const _LearningCard({required this.isFa});

  final bool isFa;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    final topics = isFa ? learningTopicsFa : learningTopicsEn;
    return Container(
      padding: EdgeInsets.all(context.isMobile ? 22 : 28),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        gradient: LinearGradient(
          colors: [colors.accent.withValues(alpha: 0.13), colors.surface],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(color: colors.border.withValues(alpha: 0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.auto_awesome_outlined, color: colors.accent, size: 22),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.t('skills.learningTitle'),
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 3),
                    Text(
                      l10n.t('skills.learningDesc'),
                      style: Theme.of(context).textTheme.bodySmall
                          ?.copyWith(color: colors.muted),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final topic in topics)
                TechChip(label: topic, icon: Icons.arrow_outward_rounded),
            ],
          ),
        ],
      ),
    );
  }
}
