import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../app/localization/app_localizations.dart';
import '../../app/navigation.dart';
import '../../app/theme/app_colors.dart';
import '../../data/content/profile_data.dart';
import '../utils/responsive.dart';
import 'social_links_row.dart';

class AppFooter extends StatelessWidget {
  const AppFooter({super.key, required this.onBackToTop});

  final VoidCallback onBackToTop;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;
    final isFa = l10n.isFa;

    return Container(
      decoration: BoxDecoration(
        color: colors.surfaceAlt.withValues(alpha: 0.5),
        border: Border(
          top: BorderSide(color: colors.border.withValues(alpha: 0.4)),
        ),
      ),
      child: ContentContainer(
        maxWidth: 1280,
        padding: EdgeInsets.symmetric(
          horizontal: context.pageHorizontalPadding,
          vertical: context.isMobile ? 36 : 48,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (context.isMobile)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _Brand(l10n: l10n, isFa: isFa),
                  const SizedBox(height: 28),
                  _QuickLinks(l10n: l10n),
                  const SizedBox(height: 28),
                  _SocialBlock(l10n: l10n),
                ],
              )
            else
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 4,
                    child: _Brand(l10n: l10n, isFa: isFa),
                  ),
                  const SizedBox(width: 32),
                  Expanded(flex: 3, child: _QuickLinks(l10n: l10n)),
                  const SizedBox(width: 32),
                  Expanded(flex: 3, child: _SocialBlock(l10n: l10n)),
                ],
              ),
            const SizedBox(height: 32),
            Divider(color: colors.border.withValues(alpha: 0.4)),
            const SizedBox(height: 18),
            Wrap(
              spacing: 16,
              runSpacing: 12,
              alignment: WrapAlignment.spaceBetween,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Text(
                  '© ${DateTime.now().year} ${profile.name(isFa)} — ${l10n.t('footer.rights')}',
                  style: Theme.of(context).textTheme.bodySmall
                      ?.copyWith(color: colors.muted),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.flutter_dash_rounded,
                      size: 16,
                      color: colors.accent,
                    ),
                    const SizedBox(width: 6),
                    Flexible(
                      child: Text(
                        l10n.t('footer.builtWith'),
                        style: Theme.of(context).textTheme.bodySmall
                            ?.copyWith(color: colors.muted),
                      ),
                    ),
                    const SizedBox(width: 12),
                    TextButton.icon(
                      onPressed: onBackToTop,
                      icon: const Icon(Icons.arrow_upward_rounded, size: 16),
                      label: Text(l10n.t('footer.backToTop')),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              l10n.t('footer.visitNote'),
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: colors.muted.withValues(alpha: 0.8),
                fontSize: 11,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Brand extends StatelessWidget {
  const _Brand({required this.l10n, required this.isFa});

  final AppLocalizations l10n;
  final bool isFa;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [colors.accent, colors.accentStrong],
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              alignment: Alignment.center,
              child: Text(
                profile.initialsEn,
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: context.isDark
                      ? const Color(0xFF152426)
                      : Colors.white,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Text(
              profile.name(isFa),
              style: Theme.of(context).textTheme.titleMedium
                  ?.copyWith(fontWeight: FontWeight.w700),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 300),
          child: Text(
            l10n.t('footer.tagline'),
            style: Theme.of(context).textTheme.bodySmall
                ?.copyWith(color: colors.muted, height: 1.7),
          ),
        ),
      ],
    );
  }
}

class _QuickLinks extends StatelessWidget {
  const _QuickLinks({required this.l10n});

  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.t('footer.quickLinks'),
          style: Theme.of(context).textTheme.labelLarge
              ?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 6,
          runSpacing: 2,
          children: [
            for (final item in navItems)
              TextButton(
                onPressed: () => context.go(item.path),
                style: TextButton.styleFrom(
                  foregroundColor: colors.muted,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 6,
                  ),
                  minimumSize: const Size(0, 36),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Text(l10n.t(item.labelKey)),
              ),
          ],
        ),
      ],
    );
  }
}

class _SocialBlock extends StatelessWidget {
  const _SocialBlock({required this.l10n});

  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.t('footer.social'),
          style: Theme.of(context).textTheme.labelLarge
              ?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 12),
        const SocialLinksRow(),
        const SizedBox(height: 12),
        Text(
          l10n.t('contact.linksNote'),
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: context.colors.muted,
            fontSize: 11,
            height: 1.6,
          ),
        ),
      ],
    );
  }
}
