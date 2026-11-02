import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../app/localization/app_localizations.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_theme.dart';
import '../../core/utils/responsive.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/code_panel.dart';
import '../../core/widgets/hover_card.dart';
import '../../core/widgets/profile_avatar.dart';
import '../../core/widgets/project_card.dart';
import '../../core/widgets/responsive_grid.dart';
import '../../core/widgets/reveal_on_mount.dart';
import '../../core/widgets/section_header.dart';
import '../../core/widgets/social_links_row.dart';
import '../../core/widgets/tech_chip.dart';
import '../../data/content/profile_data.dart';
import '../../data/content/projects_data.dart';
import '../../data/content/skills_data.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    final stacked = context.screenWidth < 980;

    return ContentContainer(
      maxWidth: 1240,
      padding: EdgeInsets.only(
        left: context.pageHorizontalPadding,
        right: context.pageHorizontalPadding,
        top: context.isMobile ? 28 : 44,
        bottom: context.isMobile ? 56 : 80,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (stacked)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _HeroText(l10n: l10n),
                const SizedBox(height: 40),
                _HeroVisual(l10n: l10n),
              ],
            )
          else
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(flex: 6, child: _HeroText(l10n: l10n)),
                const SizedBox(width: 52),
                Expanded(flex: 4, child: _HeroVisual(l10n: l10n)),
              ],
            ),
          SizedBox(height: context.sectionGap),
          RevealOnMount(
            child: SectionHeader(
              eyebrow: l10n.t('dashboard.whatIDo'),
              title: l10n.t('dashboard.role'),
              subtitle: l10n.t('dashboard.cta'),
            ),
          ),
          const SizedBox(height: 26),
          ResponsiveGrid(
            minItemWidth: 250,
            maxColumns: 3,
            children: [
              RevealOnMount(
                delay: const Duration(milliseconds: 60),
                child: _FocusCard(
                  icon: Icons.api_rounded,
                  title: l10n.t('dashboard.focusApiTitle'),
                  description: l10n.t('dashboard.focusApiDesc'),
                  accent: colors.accent,
                ),
              ),
              RevealOnMount(
                delay: const Duration(milliseconds: 120),
                child: _FocusCard(
                  icon: Icons.phone_iphone_rounded,
                  title: l10n.t('dashboard.focusMobileTitle'),
                  description: l10n.t('dashboard.focusMobileDesc'),
                  accent: colors.accentStrong,
                ),
              ),
              RevealOnMount(
                delay: const Duration(milliseconds: 180),
                child: _FocusCard(
                  icon: Icons.account_tree_rounded,
                  title: l10n.t('dashboard.focusArchTitle'),
                  description: l10n.t('dashboard.focusArchDesc'),
                  accent: colors.success,
                ),
              ),
            ],
          ),
          SizedBox(height: context.sectionGap),
          RevealOnMount(
            child: SectionHeader(
              eyebrow: l10n.t('common.featured'),
              title: l10n.t('dashboard.selectedWork'),
              subtitle: l10n.t('dashboard.selectedWorkSubtitle'),
              trailing: AppButton(
                label: l10n.t('common.viewAllProjects'),
                onPressed: () => context.go('/projects'),
                variant: AppButtonVariant.secondary,
                icon: Icons.arrow_forward_rounded,
                trailingIcon: true,
              ),
            ),
          ),
          const SizedBox(height: 26),
          ResponsiveGrid(
            minItemWidth: 360,
            maxColumns: 2,
            children: [
              for (var i = 0; i < featuredProjects.length; i++)
                RevealOnMount(
                  delay: Duration(milliseconds: 70 * i),
                  child: ProjectCard(project: featuredProjects[i]),
                ),
            ],
          ),
          SizedBox(height: context.sectionGap),
          if (context.isMobile)
            Column(
              children: [
                _ToolboxCard(l10n: l10n),
                const SizedBox(height: 20),
                _ResumeCard(l10n: l10n),
              ],
            )
          else
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(flex: 6, child: _ToolboxCard(l10n: l10n)),
                const SizedBox(width: 20),
                Expanded(flex: 4, child: _ResumeCard(l10n: l10n)),
              ],
            ),
          SizedBox(height: context.sectionGap),
          RevealOnMount(child: _CtaBanner(l10n: l10n)),
        ],
      ),
    );
  }
}

class _HeroText extends StatelessWidget {
  const _HeroText({required this.l10n});

  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final textTheme = Theme.of(context).textTheme;
    final isFa = l10n.isFa;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RevealOnMount(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
            decoration: BoxDecoration(
              color: colors.success.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(999),
              border: Border.all(color: colors.success.withValues(alpha: 0.35)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 7,
                  height: 7,
                  decoration: BoxDecoration(
                    color: colors.success,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  l10n.t('dashboard.available'),
                  style: textTheme.labelSmall?.copyWith(
                    color: colors.success,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),
        RevealOnMount(
          delay: const Duration(milliseconds: 60),
          child: Text(
            l10n.t('dashboard.greeting'),
            style: textTheme.titleMedium?.copyWith(
              color: colors.muted,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        const SizedBox(height: 2),
        RevealOnMount(
          delay: const Duration(milliseconds: 90),
          child: ShaderMask(
            shaderCallback: (bounds) {
              return LinearGradient(
                colors: [colors.text, colors.accentStrong, colors.accent],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ).createShader(bounds);
            },
            child: Text(
              profile.name(isFa),
              style:
                  (context.isMobile
                          ? textTheme.displayMedium
                          : textTheme.displayLarge)
                      ?.copyWith(color: Colors.white),
            ),
          ),
        ),
        const SizedBox(height: 12),
        RevealOnMount(
          delay: const Duration(milliseconds: 130),
          child: Text(
            profile.role(isFa),
            style: textTheme.titleLarge?.copyWith(
              color: colors.accent,
              fontWeight: FontWeight.w600,
              height: 1.5,
            ),
          ),
        ),
        const SizedBox(height: 14),
        RevealOnMount(
          delay: const Duration(milliseconds: 170),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 620),
            child: Text(
              profile.shortBio(isFa),
              style: textTheme.bodyLarge?.copyWith(color: colors.muted),
            ),
          ),
        ),
        const SizedBox(height: 26),
        RevealOnMount(
          delay: const Duration(milliseconds: 210),
          child: Wrap(
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
                label: l10n.t('common.openResume'),
                onPressed: () => context.go('/resume'),
                variant: AppButtonVariant.secondary,
                icon: Icons.description_outlined,
              ),
              AppButton(
                label: l10n.t('common.letsTalk'),
                onPressed: () => context.go('/contact'),
                variant: AppButtonVariant.ghost,
                icon: Icons.chat_bubble_outline_rounded,
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        RevealOnMount(
          delay: const Duration(milliseconds: 250),
          child: Wrap(
            spacing: 18,
            runSpacing: 12,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              const SocialLinksRow(),
              _InfoItem(
                icon: Icons.location_on_outlined,
                label: profile.location(isFa),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _InfoItem extends StatelessWidget {
  const _InfoItem({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: colors.muted),
        const SizedBox(width: 6),
        Flexible(
          child: Text(
            label,
            style: Theme.of(context).textTheme.bodySmall
                ?.copyWith(color: colors.muted),
          ),
        ),
      ],
    );
  }
}

class _HeroVisual extends StatelessWidget {
  const _HeroVisual({required this.l10n});

  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final avatarSize = context.isMobile ? 240.0 : 300.0;
    return RevealOnMount(
      delay: const Duration(milliseconds: 120),
      offset: const Offset(0.04, 0.04),
      child: Column(
        children: [
          SizedBox(
            width: avatarSize + 40,
            height: avatarSize + 40,
            child: Stack(
              alignment: Alignment.center,
              clipBehavior: Clip.none,
              children: [
                Transform.rotate(
                  angle: -0.06,
                  child: Container(
                    width: avatarSize + 18,
                    height: avatarSize + 18,
                    decoration: BoxDecoration(
                      color: colors.surfaceAlt,
                      borderRadius: BorderRadius.circular(46),
                      border: Border.all(
                        color: colors.border.withValues(alpha: 0.55),
                      ),
                    ),
                  ),
                ),
                ProfileAvatar(imageAsset: profile.imageAsset, size: avatarSize),
                Positioned(
                  top: 2,
                  right: 4,
                  child: _FloatingIcon(
                    icon: Icons.api_rounded,
                    color: colors.accent,
                    label: 'API',
                  ),
                ),
                Positioned(
                  bottom: 10,
                  left: -4,
                  child: _FloatingIcon(
                    icon: Icons.phone_iphone_rounded,
                    color: colors.accentStrong,
                    label: 'Flutter',
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          CodePanel(
            title: 'danyal.profile.dart',
            lines: [
              CodeLine(
                '// ${profile.firstNameEn.toLowerCase()}.profile',
                dim: true,
              ),
              CodeLine('const developer = {', color: colors.accent),
              const CodeLine("  name: 'Danyal Khodai',"),
              const CodeLine("  role: 'backend + flutter',"),
              const CodeLine("  stack: ['django', 'flutter'],"),
              const CodeLine("  focus: 'clean APIs',"),
              CodeLine('};', color: colors.accent),
              CodeLine('// open to collaboration', dim: true),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            l10n.t('dashboard.samplePortrait'),
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

class _FloatingIcon extends StatelessWidget {
  const _FloatingIcon({
    required this.icon,
    required this.color,
    required this.label,
  });

  final IconData icon;
  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colors.border.withValues(alpha: 0.7)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 15, color: color),
          const SizedBox(width: 6),
          Text(
            label,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: colors.text,
              fontWeight: FontWeight.w700,
              fontSize: 10.5,
            ),
          ),
        ],
      ),
    );
  }
}

class _FocusCard extends StatelessWidget {
  const _FocusCard({
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
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: accent.withValues(alpha: 0.13),
              borderRadius: BorderRadius.circular(13),
              border: Border.all(color: accent.withValues(alpha: 0.28)),
            ),
            child: Icon(icon, color: accent, size: 22),
          ),
          const SizedBox(height: 18),
          Text(title, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
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

class _ToolboxCard extends StatelessWidget {
  const _ToolboxCard({required this.l10n});

  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final names = <String>[];
    for (final skill in skills) {
      if (!names.contains(skill.name)) names.add(skill.name);
    }
    return HoverCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: colors.accent.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.handyman_outlined,
                  color: colors.accent,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.t('dashboard.techStack'),
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    Text(
                      l10n.t('dashboard.techStackSubtitle'),
                      style: Theme.of(context).textTheme.bodySmall
                          ?.copyWith(color: colors.muted),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Wrap(
            spacing: 7,
            runSpacing: 7,
            children: [
              for (final name in names) TechChip(label: name, compact: true),
            ],
          ),
          const SizedBox(height: 16),
          TextButton.icon(
            onPressed: () => context.go('/skills'),
            icon: const Icon(Icons.arrow_forward_rounded, size: 16),
            label: Text(l10n.t('nav.skills')),
          ),
        ],
      ),
    );
  }
}

class _ResumeCard extends StatelessWidget {
  const _ResumeCard({required this.l10n});

  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return HoverCard(
      gradient: LinearGradient(
        colors: [colors.accent.withValues(alpha: 0.14), colors.surface],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.description_outlined, color: colors.accent, size: 28),
          const SizedBox(height: 16),
          Text(
            l10n.t('dashboard.resumeTitle'),
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(
            l10n.t('dashboard.resumeDesc'),
            style: Theme.of(context).textTheme.bodySmall
                ?.copyWith(color: colors.muted, height: 1.7),
          ),
          const SizedBox(height: 18),
          AppButton(
            label: l10n.t('common.openResume'),
            onPressed: () => context.go('/resume'),
            variant: AppButtonVariant.secondary,
            icon: Icons.arrow_forward_rounded,
            trailingIcon: true,
          ),
        ],
      ),
    );
  }
}

class _CtaBanner extends StatelessWidget {
  const _CtaBanner({required this.l10n});

  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final isMobile = context.isMobile;
    final content = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.rocket_launch_outlined, color: colors.accent, size: 20),
            const SizedBox(width: 8),
            Text(
              l10n.t('game.easterEgg').toUpperCase(),
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: colors.accent,
                fontWeight: FontWeight.w800,
                letterSpacing: 1.2,
                fontSize: 10,
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        Text(
          l10n.t('dashboard.ctaTitle'),
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const SizedBox(height: 10),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 620),
          child: Text(
            l10n.t('dashboard.ctaDesc'),
            style: Theme.of(context).textTheme.bodyMedium
                ?.copyWith(color: colors.muted),
          ),
        ),
      ],
    );

    final actions = Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [
        AppButton(
          label: l10n.t('common.contactMe'),
          onPressed: () => context.go('/contact'),
          icon: Icons.mail_outline_rounded,
        ),
        AppButton(
          label: l10n.t('nav.game'),
          onPressed: () => context.go('/game'),
          variant: AppButtonVariant.ghost,
          icon: Icons.sports_esports_outlined,
        ),
      ],
    );

    return Container(
      padding: EdgeInsets.all(isMobile ? 24 : 34),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(26),
        gradient: LinearGradient(
          colors: [
            colors.accent.withValues(alpha: 0.18),
            colors.surfaceAlt,
            colors.accentStrong.withValues(alpha: 0.1),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(color: colors.accent.withValues(alpha: 0.3)),
      ),
      child: Stack(
        children: [
          Positioned(
            right: isMobile ? -10 : 30,
            top: -20,
            child: IgnorePointer(
              child: Text(
                '</>',
                style: AppTheme.mono(
                  color: colors.accent.withValues(alpha: 0.12),
                  size: isMobile ? 54 : 92,
                ),
              ),
            ),
          ),
          if (isMobile)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [content, const SizedBox(height: 22), actions],
            )
          else
            Row(
              children: [
                Expanded(child: content),
                const SizedBox(width: 32),
                actions,
              ],
            ),
        ],
      ),
    );
  }
}
