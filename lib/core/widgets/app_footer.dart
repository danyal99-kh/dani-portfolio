import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../app/localization/app_localizations.dart';
import '../../app/navigation.dart';
import '../../app/theme/app_colors.dart';
import '../utils/responsive.dart';
import 'social_links_row.dart';

class AppFooter extends StatelessWidget {
  const AppFooter({super.key, required this.onBackToTop});

  final VoidCallback onBackToTop;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;

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
          vertical: context.isMobile ? 32 : 40,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (context.isMobile)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _QuickLinks(l10n: l10n),
                  const SizedBox(height: 28),
                  _SocialBlock(l10n: l10n),
                ],
              )
            else
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(flex: 6, child: _QuickLinks(l10n: l10n)),
                  const SizedBox(width: 32),
                  Expanded(flex: 4, child: _SocialBlock(l10n: l10n)),
                ],
              ),
            const SizedBox(height: 24),
            Divider(color: colors.border.withValues(alpha: 0.4)),
            const SizedBox(height: 8),
            Align(
              alignment: AlignmentDirectional.centerEnd,
              child: TextButton.icon(
                onPressed: onBackToTop,
                icon: const Icon(Icons.arrow_upward_rounded, size: 16),
                label: Text(l10n.t('footer.backToTop')),
              ),
            ),
          ],
        ),
      ),
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
      ],
    );
  }
}
