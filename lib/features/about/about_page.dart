import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../app/localization/app_localizations.dart';
import '../../app/theme/app_colors.dart';
import '../../core/utils/responsive.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/hover_card.dart';
import '../../core/widgets/profile_avatar.dart';
import '../../core/widgets/responsive_grid.dart';
import '../../core/widgets/reveal_on_visible.dart';
import '../../core/widgets/section_header.dart';
import '../../core/widgets/social_links_row.dart';
import '../../core/widgets/tech_chip.dart';
import '../../data/content/profile_data.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

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
            eyebrow: l10n.t('nav.about'),
            title: l10n.t('about.title'),
            subtitle: l10n.t('about.subtitle'),
            icon: Icons.person_outline_rounded,
          ),
          SizedBox(height: context.sectionGap),
          if (context.isMobile)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _PortraitCard(l10n: l10n),
                const SizedBox(height: 28),
                _BioSection(l10n: l10n),
              ],
            )
          else
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(width: 330, child: _PortraitCard(l10n: l10n)),
                const SizedBox(width: 48),
                Expanded(child: _BioSection(l10n: l10n)),
              ],
            ),
          SizedBox(height: context.sectionGap),
          RevealOnVisible(
            child: SectionHeader(
              eyebrow: l10n.t('about.journey'),
              title: l10n.t('about.journey'),
              subtitle: l10n.t('about.journeySubtitle'),
            ),
          ),
          const SizedBox(height: 28),
          _JourneyTimeline(l10n: l10n),
          SizedBox(height: context.sectionGap),
          RevealOnVisible(
            child: SectionHeader(
              eyebrow: l10n.t('about.interests'),
              title: l10n.t('about.interests'),
            ),
          ),
          const SizedBox(height: 20),
          Wrap(
            spacing: 9,
            runSpacing: 9,
            children: [
              for (var i = 1; i <= 6; i++)
                TechChip(
                  label: l10n.t('about.interest$i'),
                  icon: _interestIcons[i - 1],
                ),
            ],
          ),
          SizedBox(height: context.sectionGap),
          RevealOnVisible(
            child: SectionHeader(
              eyebrow: l10n.t('about.goals'),
              title: l10n.t('about.goals'),
            ),
          ),
          const SizedBox(height: 24),
          ResponsiveGrid(
            minItemWidth: 250,
            maxColumns: 3,
            children: [
              for (var i = 1; i <= 3; i++)
                RevealOnVisible(
                  delay: Duration(milliseconds: 60 * i),
                  child: _InfoCard(
                    icon: _goalIcons[i - 1],
                    title: l10n.t('about.goal${i}Title'),
                    description: l10n.t('about.goal${i}Desc'),
                    accent: _goalColors(colors)[i - 1],
                  ),
                ),
            ],
          ),
          SizedBox(height: context.sectionGap),
          RevealOnVisible(
            child: SectionHeader(
              eyebrow: l10n.t('about.principles'),
              title: l10n.t('about.principles'),
            ),
          ),
          const SizedBox(height: 24),
          ResponsiveGrid(
            minItemWidth: 250,
            maxColumns: 3,
            children: [
              for (var i = 1; i <= 3; i++)
                RevealOnVisible(
                  delay: Duration(milliseconds: 60 * i),
                  child: _PrincipleCard(
                    index: i,
                    title: l10n.t('about.principle${i}Title'),
                    description: l10n.t('about.principle${i}Desc'),
                  ),
                ),
            ],
          ),
          SizedBox(height: context.sectionGap),
          RevealOnVisible(
            child: _LearningBanner(l10n: l10n, isFa: isFa),
          ),
        ],
      ),
    );
  }

  static const _interestIcons = [
    Icons.api_rounded,
    Icons.account_tree_rounded,
    Icons.phone_iphone_rounded,
    Icons.touch_app_outlined,
    Icons.storage_rounded,
    Icons.school_outlined,
  ];

  static const _goalIcons = [
    Icons.rocket_launch_outlined,
    Icons.build_outlined,
    Icons.groups_outlined,
  ];

  static List<Color> _goalColors(PortfolioColors colors) => [
    colors.accent,
    colors.accentStrong,
    colors.success,
  ];
}

class _PortraitCard extends StatelessWidget {
  const _PortraitCard({required this.l10n});

  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return RevealOnVisible(
      child: HoverCard(
        padding: const EdgeInsets.all(22),
        child: Column(
          children: [
            ProfileAvatar(
              imageAsset: profile.imageAsset,
              size: context.isMobile ? 220 : 260,
              borderRadius: 28,
            ),
            const SizedBox(height: 20),
            Text(
              profile.name(l10n.isFa),
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 4),
            Text(
              profile.role(l10n.isFa),
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall
                  ?.copyWith(color: colors.accent, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.location_on_outlined, size: 15, color: colors.muted),
                const SizedBox(width: 5),
                Flexible(
                  child: Text(
                    profile.location(l10n.isFa),
                    style: Theme.of(context).textTheme.bodySmall
                        ?.copyWith(color: colors.muted),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            SocialLinksRow(alignment: WrapAlignment.center),
          ],
        ),
      ),
    );
  }
}

class _BioSection extends StatelessWidget {
  const _BioSection({required this.l10n});

  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final isFa = l10n.isFa;
    return RevealOnVisible(
      delay: const Duration(milliseconds: 80),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.t('about.introTitle'),
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 18),
          Text(
            profile.aboutBio1(isFa),
            style: Theme.of(context).textTheme.bodyLarge
                ?.copyWith(color: colors.muted),
          ),
          const SizedBox(height: 14),
          Text(
            profile.aboutBio2(isFa),
            style: Theme.of(context).textTheme.bodyLarge
                ?.copyWith(color: colors.muted),
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: colors.surfaceAlt,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: colors.accent.withValues(alpha: 0.25)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.format_quote_rounded,
                  color: colors.accent,
                  size: 26,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    l10n.t('skills.note'),
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: colors.text,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              AppButton(
                label: l10n.t('common.viewProjects'),
                onPressed: () => context.go('/projects'),
                icon: Icons.arrow_forward_rounded,
                trailingIcon: true,
              ),
              AppButton(
                label: l10n.t('common.letsTalk'),
                onPressed: () => context.go('/contact'),
                variant: AppButtonVariant.secondary,
                icon: Icons.chat_bubble_outline_rounded,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _JourneyTimeline extends StatelessWidget {
  const _JourneyTimeline({required this.l10n});

  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (var i = 1; i <= 4; i++)
          RevealOnVisible(
            delay: Duration(milliseconds: 60 * i),
            child: _TimelineRow(
              index: i,
              title: l10n.t('about.journey${i}Title'),
              description: l10n.t('about.journey${i}Desc'),
              isLast: i == 4,
            ),
          ),
      ],
    );
  }
}

class _TimelineRow extends StatelessWidget {
  const _TimelineRow({
    required this.index,
    required this.title,
    required this.description,
    required this.isLast,
  });

  final int index;
  final String title;
  final String description;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            width: 44,
            child: Column(
              children: [
                Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    color: colors.accent.withValues(alpha: 0.14),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: colors.accent.withValues(alpha: 0.5),
                    ),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    '$index',
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: colors.accent,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                if (!isLast)
                  Expanded(
                    child: Container(
                      width: 2,
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      color: colors.border.withValues(alpha: 0.5),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: isLast ? 0 : 20),
              child: HoverCard(
                padding: const EdgeInsets.all(18),
                lift: false,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 5),
                    Text(
                      description,
                      style: Theme.of(context).textTheme.bodySmall
                          ?.copyWith(color: colors.muted, height: 1.7),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.accent,
  });

  final IconData icon;
  final String title;
  final String description;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return HoverCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: accent.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: accent, size: 21),
          ),
          const SizedBox(height: 16),
          Text(title, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 7),
          Text(
            description,
            style: Theme.of(context).textTheme.bodySmall
                ?.copyWith(color: colors.muted, height: 1.7),
          ),
        ],
      ),
    );
  }
}

class _PrincipleCard extends StatelessWidget {
  const _PrincipleCard({
    required this.index,
    required this.title,
    required this.description,
  });

  final int index;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return HoverCard(
      lift: false,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '0$index',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: colors.accent.withValues(alpha: 0.55),
              fontFamily: 'JetBrainsMono',
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 6),
                Text(
                  description,
                  style: Theme.of(context).textTheme.bodySmall
                      ?.copyWith(color: colors.muted, height: 1.7),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _LearningBanner extends StatelessWidget {
  const _LearningBanner({required this.l10n, required this.isFa});

  final AppLocalizations l10n;
  final bool isFa;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      padding: EdgeInsets.all(context.isMobile ? 22 : 28),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: colors.border.withValues(alpha: 0.55)),
        gradient: LinearGradient(
          colors: [colors.accent.withValues(alpha: 0.1), colors.surface],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: colors.accent.withValues(alpha: 0.13),
              borderRadius: BorderRadius.circular(13),
            ),
            child: Icon(
              Icons.auto_awesome_outlined,
              color: colors.accent,
              size: 22,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.t('about.currentlyLearning'),
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 6),
                Text(
                  l10n.t('about.currentlyLearningDesc'),
                  style: Theme.of(context).textTheme.bodySmall
                      ?.copyWith(color: colors.muted, height: 1.7),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
