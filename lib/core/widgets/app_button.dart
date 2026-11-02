import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';

enum AppButtonVariant { primary, secondary, ghost }

class AppButton extends StatefulWidget {
  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.variant = AppButtonVariant.primary,
    this.expand = false,
    this.trailingIcon = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final AppButtonVariant variant;
  final bool expand;
  final bool trailingIcon;

  @override
  State<AppButton> createState() => _AppButtonState();
}

class _AppButtonState extends State<AppButton> {
  bool _hovered = false;
  bool _focused = false;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final isPrimary = widget.variant == AppButtonVariant.primary;
    final isGhost = widget.variant == AppButtonVariant.ghost;
    final foreground = isPrimary
        ? (context.isDark ? const Color(0xFF152426) : Colors.white)
        : colors.text;
    final active = _hovered || _focused;

    final decoration = BoxDecoration(
      gradient: isPrimary
          ? LinearGradient(
              colors: [
                colors.accent,
                Color.lerp(colors.accent, colors.accentStrong, 0.7)!,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            )
          : null,
      color: isPrimary
          ? null
          : isGhost
          ? (active ? colors.surfaceAlt : Colors.transparent)
          : (active
                ? colors.accent.withValues(alpha: 0.16)
                : colors.surfaceAlt),
      borderRadius: BorderRadius.circular(14),
      border: isGhost
          ? null
          : Border.all(
              color: isPrimary
                  ? Colors.transparent
                  : colors.border.withValues(alpha: active ? 0.95 : 0.6),
            ),
      boxShadow: isPrimary && active
          ? [
              BoxShadow(
                color: colors.accent.withValues(alpha: 0.28),
                blurRadius: 18,
                offset: const Offset(0, 7),
              ),
            ]
          : const [],
    );

    final content = Row(
      mainAxisSize: widget.expand ? MainAxisSize.max : MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (widget.icon != null && !widget.trailingIcon) ...[
          Icon(widget.icon, size: 19, color: foreground),
          const SizedBox(width: 10),
        ],
        Flexible(
          child: Text(
            widget.label,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.labelLarge
                ?.copyWith(color: foreground, fontWeight: FontWeight.w700),
          ),
        ),
        if (widget.icon != null && widget.trailingIcon) ...[
          const SizedBox(width: 10),
          Icon(widget.icon, size: 19, color: foreground),
        ],
      ],
    );

    return FocusableActionDetector(
      onShowFocusHighlight: (value) => setState(() => _focused = value),
      onShowHoverHighlight: (value) => setState(() => _hovered = value),
      actions: {
        ActivateIntent: CallbackAction<ActivateIntent>(
          onInvoke: (_) {
            widget.onPressed?.call();
            return null;
          },
        ),
      },
      child: Semantics(
        button: true,
        enabled: widget.onPressed != null,
        label: widget.label,
        child: MouseRegion(
          cursor: widget.onPressed == null
              ? SystemMouseCursors.basic
              : SystemMouseCursors.click,
          onEnter: (_) => setState(() => _hovered = true),
          onExit: (_) => setState(() => _hovered = false),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            curve: Curves.easeOutCubic,
            transform: Matrix4.translationValues(0, active ? -2 : 0, 0),
            constraints: const BoxConstraints(minHeight: 50),
            decoration: decoration,
            child: Material(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(14),
              child: InkWell(
                onTap: widget.onPressed,
                borderRadius: BorderRadius.circular(14),
                splashColor: foreground.withValues(alpha: 0.12),
                highlightColor: foreground.withValues(alpha: 0.06),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 22,
                    vertical: 14,
                  ),
                  child: widget.expand
                      ? content
                      : IntrinsicWidth(child: content),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
