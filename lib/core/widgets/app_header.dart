import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../app/app_state.dart';
import '../../app/localization/app_localizations.dart';
import '../../app/navigation.dart';
import '../../app/theme/app_colors.dart';
import '../../data/content/profile_data.dart';
import '../utils/responsive.dart';
import 'pressable_scale.dart';

/// Floating glass navbar (top-center). Route state comes only from [location].
class AppHeader extends StatelessWidget {
  const AppHeader({
    super.key,
    required this.location,
    required this.scrolled,
    required this.menuOpen,
    required this.onMenuToggle,
    required this.onMenuClose,
  });

  final String location;
  final bool scrolled;
  final bool menuOpen;
  final VoidCallback onMenuToggle;
  final VoidCallback onMenuClose;

  /// Space the page content must reserve at the top (used by the shell).
  static double reservedHeight(BuildContext context) =>
      MediaQuery.paddingOf(context).top + (context.isMobile ? 88 : 112);

  @override
  Widget build(BuildContext context) {
    final isMobile = context.isMobile;
    final isTablet = context.isTablet;
    final wide = context.screenWidth >= 1180;
    final reduce = context.reduceMotion;
    final duration = reduce ? Duration.zero : const Duration(milliseconds: 240);
    final appState = AppStateScope.of(context);

    final sideGap = isMobile ? 12.0 : 24.0;
    final topGap = scrolled ? 10.0 : (isMobile ? 12.0 : 22.0);
    final barHeight = isMobile
        ? (scrolled ? 52.0 : 58.0)
        : (scrolled ? 58.0 : 68.0);

    final bar = _GlassBar(
      scrolled: scrolled,
      radius: isMobile ? 22 : 28,
      height: barHeight,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: isMobile ? 10 : 14),
        child: isMobile
            ? Row(
                children: [
                  Expanded(
                    child: _Brand(showSubtitle: false, onClose: onMenuClose),
                  ),
                  _LanguageAction(appState: appState),
                  const SizedBox(width: 6),
                  _ThemeAction(appState: appState),
                  const SizedBox(width: 6),
                  _IconAction(
                    key: const Key('menu-button'),
                    tooltip: context.l10n.t(
                      menuOpen ? 'a11y.closeMenu' : 'a11y.openMenu',
                    ),
                    icon: menuOpen ? Icons.close_rounded : Icons.menu_rounded,
                    onTap: onMenuToggle,
                  ),
                ],
              )
            : Row(
                children: [
                  _Brand(showSubtitle: wide, onClose: onMenuClose),
                  Expanded(
                    child: Center(
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: _NavLinks(
                          location: location,
                          showIcons: !isTablet,
                        ),
                      ),
                    ),
                  ),
                  _LanguageAction(appState: appState),
                  const SizedBox(width: 6),
                  _ThemeAction(appState: appState),
                ],
              ),
      ),
    );

    return SafeArea(
      bottom: false,
      child: Align(
        alignment: Alignment.topCenter,
        heightFactor: 1,
        child: AnimatedPadding(
          duration: duration,
          curve: Curves.easeOutCubic,
          padding: EdgeInsets.fromLTRB(sideGap, topGap, sideGap, 0),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1160),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                bar,
                if (isMobile)
                  AnimatedSize(
                    duration: duration,
                    curve: Curves.easeOutCubic,
                    alignment: Alignment.topCenter,
                    child: menuOpen
                        ? Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: _MobileMenu(
                              location: location,
                              onSelect: (path) {
                                onMenuClose();
                                context.go(path);
                              },
                            ),
                          )
                        : const SizedBox(width: double.infinity),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ───────────────────────── Glass container ─────────────────────────

class _GlassBar extends StatelessWidget {
  const _GlassBar({
    required this.scrolled,
    required this.radius,
    required this.child,
    this.height,
  });

  final bool scrolled;
  final double radius;
  final double? height;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final dark = context.isDark;
    final duration = context.reduceMotion
        ? Duration.zero
        : const Duration(milliseconds: 240);
    final borderRadius = BorderRadius.circular(radius);

    return AnimatedContainer(
      duration: duration,
      curve: Curves.easeOutCubic,
      height: height,
      decoration: BoxDecoration(
        borderRadius: borderRadius,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(
              alpha: dark ? (scrolled ? 0.34 : 0.22) : (scrolled ? 0.14 : 0.08),
            ),
            blurRadius: scrolled ? 26 : 18,
            offset: Offset(0, scrolled ? 8 : 12),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: borderRadius,
        child: TweenAnimationBuilder<double>(
          tween: Tween<double>(end: scrolled ? 18 : 10),
          duration: duration,
          curve: Curves.easeOutCubic,
          builder: (context, sigma, inner) => BackdropFilter(
            filter: ImageFilter.blur(sigmaX: sigma, sigmaY: sigma),
            child: inner,
          ),
          child: AnimatedContainer(
            duration: duration,
            curve: Curves.easeOutCubic,
            decoration: BoxDecoration(
              color: colors.surface.withValues(alpha: scrolled ? 0.9 : 0.66),
              borderRadius: borderRadius,
              border: Border.all(color: colors.border.withValues(alpha: 0.55)),
              // subtle inner top highlight (skeuomorphic touch)
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.white.withValues(alpha: dark ? 0.05 : 0.28),
                  Colors.white.withValues(alpha: 0),
                ],
              ),
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}

// ───────────────────────── Brand ─────────────────────────

class _Brand extends StatelessWidget {
  const _Brand({required this.showSubtitle, required this.onClose});

  final bool showSubtitle;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;
    final isFa = l10n.isFa;
    final name = isFa ? profile.nameFa.split(' ').first : profile.firstNameEn;
    final monogram = '${profile.firstNameEn.substring(0, 1)}.';
    final fg = context.isDark ? const Color(0xFF152426) : Colors.white;

    return Semantics(
      button: true,
      label: profile.name(isFa),
      excludeSemantics: true,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            onClose();
            context.go('/');
          },
          child: PressableScale(
            scale: 0.97,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        gradient: LinearGradient(
                          colors: [colors.accent, colors.accentStrong],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.white.withValues(alpha: 0.35),
                            blurRadius: 1,
                            offset: const Offset(0, -1),
                          ),
                        ],
                      ),
                      child: Text(
                        monogram,
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(
                              color: fg,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0,
                            ),
                      ),
                    ),
                    // availability comes from profile data (not hardcoded)
                    PositionedDirectional(
                      end: -2,
                      bottom: -2,
                      child: Tooltip(
                        message: profile.availability(isFa),
                        child: Container(
                          width: 11,
                          height: 11,
                          decoration: BoxDecoration(
                            color: colors.success,
                            shape: BoxShape.circle,
                            border: Border.all(color: colors.surface, width: 2),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 11),
                Flexible(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 210),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.titleSmall
                              ?.copyWith(fontWeight: FontWeight.w700),
                        ),
                        if (showSubtitle)
                          Text(
                            profile.role(isFa),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.labelSmall
                                ?.copyWith(
                                  color: colors.muted,
                                  fontFamily: 'JetBrainsMono',
                                  fontSize: 9.5,
                                ),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ───────────────────────── Desktop links + sliding indicator ─────────────────────────

class _NavLinks extends StatefulWidget {
  const _NavLinks({required this.location, required this.showIcons});

  final String location;
  final bool showIcons;

  @override
  State<_NavLinks> createState() => _NavLinksState();
}

class _NavLinksState extends State<_NavLinks> {
  final _stackKey = GlobalKey();
  final _itemKeys = List<GlobalKey>.generate(
    navItems.length,
    (_) => GlobalKey(),
  );
  Rect? _target;

  void _measure() {
    if (!mounted) return;
    final stackBox = _stackKey.currentContext?.findRenderObject();
    final index = navItems.indexWhere((i) => i.isActive(widget.location));
    if (stackBox is! RenderBox || !stackBox.attached) return;
    if (index < 0) {
      if (_target != null) setState(() => _target = null);
      return;
    }
    final itemBox = _itemKeys[index].currentContext?.findRenderObject();
    if (itemBox is! RenderBox || !itemBox.hasSize) return;
    final offset = itemBox.localToGlobal(Offset.zero, ancestor: stackBox);
    final rect = offset & itemBox.size;
    if (rect != _target) setState(() => _target = rect);
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;
    final duration = context.reduceMotion
        ? Duration.zero
        : const Duration(milliseconds: 260);

    // Re-measure after layout (locale / size / route changes).
    WidgetsBinding.instance.addPostFrameCallback((_) => _measure());

    return Stack(
      key: _stackKey,
      children: [
        if (_target != null)
          AnimatedPositioned(
            duration: duration,
            curve: Curves.easeOutCubic,
            left: _target!.left,
            top: _target!.top,
            width: _target!.width,
            height: _target!.height,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: colors.accent.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: colors.accent.withValues(alpha: 0.4)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.white.withValues(
                      alpha: context.isDark ? 0.04 : 0.45,
                    ),
                    blurRadius: 1,
                    offset: const Offset(0, -1),
                  ),
                ],
              ),
            ),
          ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (var i = 0; i < navItems.length; i++)
              _NavButton(
                key: _itemKeys[i],
                icon: widget.showIcons ? navItems[i].icon : null,
                label: l10n.t(navItems[i].labelKey),
                active: navItems[i].isActive(widget.location),
                onTap: () => context.go(navItems[i].path),
              ),
          ],
        ),
      ],
    );
  }
}

class _NavButton extends StatefulWidget {
  const _NavButton({
    super.key,
    required this.label,
    required this.active,
    required this.onTap,
    this.icon,
  });

  final String label;
  final IconData? icon;
  final bool active;
  final VoidCallback onTap;

  @override
  State<_NavButton> createState() => _NavButtonState();
}

class _NavButtonState extends State<_NavButton> {
  bool _hovered = false;
  bool _focused = false;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final reduce = context.reduceMotion;
    final active = widget.active;

    return FocusableActionDetector(
      mouseCursor: SystemMouseCursors.click,
      onShowHoverHighlight: (v) => setState(() => _hovered = v),
      onShowFocusHighlight: (v) => setState(() => _focused = v),
      actions: {
        ActivateIntent: CallbackAction<ActivateIntent>(
          onInvoke: (_) {
            widget.onTap();
            return null;
          },
        ),
      },
      child: Semantics(
        button: true,
        selected: active,
        label: widget.label,
        excludeSemantics: true,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: widget.onTap,
          child: PressableScale(
            scale: 0.98,
            child: AnimatedContainer(
              duration: reduce
                  ? Duration.zero
                  : const Duration(milliseconds: 200),
              curve: Curves.easeOutCubic,
              margin: const EdgeInsets.symmetric(horizontal: 1),
              padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 10),
              transform: Matrix4.translationValues(
                0,
                _hovered && !active && !reduce ? -1 : 0,
                0,
              ),
              decoration: BoxDecoration(
                color: _hovered && !active
                    ? colors.text.withValues(alpha: 0.06)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: _focused
                      ? colors.accent.withValues(alpha: 0.7)
                      : Colors.transparent,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (widget.icon != null) ...[
                    Icon(
                      widget.icon,
                      size: 15,
                      color: active ? colors.accent : colors.muted,
                    ),
                    const SizedBox(width: 6),
                  ],
                  AnimatedDefaultTextStyle(
                    duration: const Duration(milliseconds: 200),
                    style: Theme.of(context).textTheme.labelMedium!.copyWith(
                      color: active ? colors.text : colors.muted,
                      fontWeight: active ? FontWeight.w700 : FontWeight.w500,
                    ),
                    child: Text(widget.label, maxLines: 1),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ───────────────────────── Mobile menu ─────────────────────────

class _MobileMenu extends StatelessWidget {
  const _MobileMenu({required this.location, required this.onSelect});

  final String location;
  final ValueChanged<String> onSelect;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;
    final reduce = context.reduceMotion;

    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: reduce ? 1 : 0, end: 1),
      duration: reduce ? Duration.zero : const Duration(milliseconds: 220),
      curve: Curves.easeOutCubic,
      builder: (context, t, child) => Opacity(
        opacity: t,
        child: Transform.translate(
          offset: Offset(0, (1 - t) * -8),
          child: child,
        ),
      ),
      child: _GlassBar(
        scrolled: true,
        radius: 22,
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (final item in navItems)
                _MobileMenuItem(
                  icon: item.icon,
                  label: l10n.t(item.labelKey),
                  active: item.isActive(location),
                  accent: colors.accent,
                  onTap: () => onSelect(item.path),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MobileMenuItem extends StatelessWidget {
  const _MobileMenuItem({
    required this.icon,
    required this.label,
    required this.active,
    required this.accent,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool active;
  final Color accent;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Semantics(
      button: true,
      selected: active,
      label: label,
      excludeSemantics: true,
      child: Material(
        color: active ? accent.withValues(alpha: 0.18) : Colors.transparent,
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(14),
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 48),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: Row(
                children: [
                  Icon(icon, size: 19, color: active ? accent : colors.muted),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      label,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: colors.text,
                        fontWeight: active ? FontWeight.w700 : FontWeight.w500,
                      ),
                    ),
                  ),
                  if (active)
                    Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: accent,
                        shape: BoxShape.circle,
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ───────────────────────── Actions ─────────────────────────

class _ThemeAction extends StatelessWidget {
  const _ThemeAction({required this.appState});

  final AppState appState;

  @override
  Widget build(BuildContext context) {
    return _IconAction(
      key: const Key('theme-toggle'),
      tooltip: context.l10n.t('a11y.toggleTheme'),
      icon: context.isDark
          ? Icons.light_mode_outlined
          : Icons.dark_mode_outlined,
      onTap: () => appState.toggleTheme(Theme.of(context).brightness),
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
    final reduce = context.reduceMotion;
    return Tooltip(
      message: tooltip,
      child: PressableScale(
        scale: 0.94,
        child: IconButton(
          onPressed: onTap,
          tooltip: null,
          color: colors.text,
          icon: AnimatedSwitcher(
            duration: reduce
                ? Duration.zero
                : const Duration(milliseconds: 220),
            transitionBuilder: (child, animation) => FadeTransition(
              opacity: animation,
              child: ScaleTransition(
                scale: Tween<double>(begin: 0.8, end: 1).animate(animation),
                child: child,
              ),
            ),
            child: Icon(icon, key: ValueKey(icon), size: 19),
          ),
          style: IconButton.styleFrom(
            backgroundColor: colors.surfaceAlt.withValues(alpha: 0.6),
            minimumSize: const Size(44, 44),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(13),
              side: BorderSide(color: colors.border.withValues(alpha: 0.45)),
            ),
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
    final reduce = context.reduceMotion;
    final target = l10n.isFa ? 'EN' : 'FA';

    return Tooltip(
      message: l10n.t('a11y.switchLanguage'),
      child: Semantics(
        button: true,
        label: l10n.t('a11y.switchLanguage'),
        excludeSemantics: true,
        child: PressableScale(
          scale: 0.94,
          child: Material(
            color: colors.surfaceAlt.withValues(alpha: 0.6),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(13),
              side: BorderSide(color: colors.border.withValues(alpha: 0.45)),
            ),
            child: InkWell(
              key: const Key('language-toggle'),
              onTap: appState.toggleLocale,
              borderRadius: BorderRadius.circular(13),
              child: Container(
                height: 44,
                constraints: const BoxConstraints(minWidth: 46),
                padding: const EdgeInsets.symmetric(horizontal: 11),
                alignment: Alignment.center,
                child: AnimatedSwitcher(
                  duration: reduce
                      ? Duration.zero
                      : const Duration(milliseconds: 200),
                  transitionBuilder: (child, animation) => FadeTransition(
                    opacity: animation,
                    child: ScaleTransition(
                      scale: Tween<double>(
                        begin: 0.86,
                        end: 1,
                      ).animate(animation),
                      child: child,
                    ),
                  ),
                  child: Text(
                    target,
                    key: ValueKey(target),
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: colors.text,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.5,
                    ),
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
