import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../app/app_state.dart';
import '../../app/localization/app_localizations.dart';
import '../../app/navigation.dart';
import '../../app/theme/app_colors.dart';
import '../../data/content/profile_data.dart';
import '../utils/responsive.dart';

class AppHeader extends StatelessWidget {
  const AppHeader({super.key, required this.location, required this.onMenuTap});

  final String location;
  final VoidCallback onMenuTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;
    final appState = AppStateScope.of(context);
    final isMobile = context.isMobile;

    return Container(
      decoration: BoxDecoration(
        color: colors.background.withValues(alpha: 0.94),
        border: Border(
          bottom: BorderSide(color: colors.border.withValues(alpha: 0.4)),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1280),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: context.pageHorizontalPadding,
                vertical: 12,
              ),
              child: Row(
                children: [
                  _Logo(onTap: () => context.go('/')),
                  const Spacer(),
                  if (!isMobile)
                    Flexible(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            for (final item in navItems)
                              _NavButton(
                                item: item,
                                active: item.isActive(location),
                                onTap: () => context.go(item.path),
                              ),
                          ],
                        ),
                      ),
                    ),
                  if (!isMobile) const Spacer(),
                  const SizedBox(width: 8),
                  _IconAction(
                    key: const Key('theme-toggle'),
                    tooltip: l10n.t('a11y.toggleTheme'),
                    icon: context.isDark
                        ? Icons.light_mode_outlined
                        : Icons.dark_mode_outlined,
                    onTap: () =>
                        appState.toggleTheme(Theme.of(context).brightness),
                  ),
                  _LanguageAction(appState: appState),
                  if (isMobile) ...[
                    const SizedBox(width: 2),
                    _IconAction(
                      key: const Key('menu-button'),
                      tooltip: l10n.t('a11y.openMenu'),
                      icon: Icons.menu_rounded,
                      onTap: onMenuTap,
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Logo extends StatefulWidget {
  const _Logo({required this.onTap});

  final VoidCallback onTap;

  @override
  State<_Logo> createState() => _LogoState();
}

class _LogoState extends State<_Logo> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [colors.accent, colors.accentStrong],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12),
                boxShadow: _hovered
                    ? [
                        BoxShadow(
                          color: colors.accent.withValues(alpha: 0.3),
                          blurRadius: 16,
                          offset: const Offset(0, 5),
                        ),
                      ]
                    : const [],
              ),
              alignment: Alignment.center,
              child: Text(
                profile.initialsEn,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: context.isDark
                      ? const Color(0xFF152426)
                      : Colors.white,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.5,
                ),
              ),
            ),
            if (!context.isMobile) ...[
              const SizedBox(width: 12),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 230),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      profile.name(l10n.isFa),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleSmall
                          ?.copyWith(fontWeight: FontWeight.w700),
                    ),
                    Text(
                      profile.role(l10n.isFa),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: colors.muted,
                        fontFamily: 'JetBrainsMono',
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _NavButton extends StatefulWidget {
  const _NavButton({
    required this.item,
    required this.active,
    required this.onTap,
  });

  final NavItem item;
  final bool active;
  final VoidCallback onTap;

  @override
  State<_NavButton> createState() => _NavButtonState();
}

class _NavButtonState extends State<_NavButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;
    final active = widget.active;
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          margin: const EdgeInsets.symmetric(horizontal: 2),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
          decoration: BoxDecoration(
            color: active
                ? colors.accent.withValues(alpha: 0.14)
                : (_hovered ? colors.surfaceAlt : Colors.transparent),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                widget.item.icon,
                size: 15,
                color: active ? colors.accent : colors.muted,
              ),
              const SizedBox(width: 6),
              Text(
                l10n.t(widget.item.labelKey),
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: active ? colors.accent : colors.text,
                  fontWeight: active ? FontWeight.w700 : FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _IconAction extends StatelessWidget {
  const _IconAction({
    super.key,
    required this.tooltip,
    required this.icon,
    required this.onTap,
  });

  final String tooltip;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Tooltip(
      message: tooltip,
      child: IconButton(
        onPressed: onTap,
        icon: Icon(icon, size: 20),
        color: colors.text,
        style: IconButton.styleFrom(
          backgroundColor: colors.surfaceAlt,
          minimumSize: const Size(44, 44),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: colors.border.withValues(alpha: 0.5)),
          ),
        ),
      ),
    );
  }
}

class _LanguageAction extends StatelessWidget {
  const _LanguageAction({required this.appState});

  final AppState appState;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;
    final target = l10n.isFa ? 'EN' : 'FA';
    return Padding(
      padding: const EdgeInsetsDirectional.only(start: 8),
      child: Tooltip(
        message: l10n.t('a11y.switchLanguage'),
        child: InkWell(
          key: const Key('language-toggle'),
          onTap: appState.toggleLocale,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            height: 44,
            constraints: const BoxConstraints(minWidth: 46),
            padding: const EdgeInsets.symmetric(horizontal: 11),
            decoration: BoxDecoration(
              color: colors.surfaceAlt,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: colors.border.withValues(alpha: 0.5)),
            ),
            alignment: Alignment.center,
            child: Text(
              target,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: colors.text,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
