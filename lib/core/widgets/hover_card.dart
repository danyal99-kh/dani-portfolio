import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';

class HoverCard extends StatefulWidget {
  const HoverCard({
    super.key,
    required this.child,
    this.onTap,
    this.padding = const EdgeInsets.all(24),
    this.color,
    this.gradient,
    this.borderColor,
    this.hoverBorderColor,
    this.borderRadius = 22,
    this.lift = true,
  });

  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry padding;
  final Color? color;
  final Gradient? gradient;
  final Color? borderColor;
  final Color? hoverBorderColor;
  final double borderRadius;
  final bool lift;

  @override
  State<HoverCard> createState() => _HoverCardState();
}

class _HoverCardState extends State<HoverCard> {
  bool _hovered = false;

  void _setHovered(bool value) {
    if (_hovered == value) return;
    setState(() => _hovered = value);
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final radius = BorderRadius.circular(widget.borderRadius);
    final interactive = widget.onTap != null;

    final card = AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOutCubic,
      transform: Matrix4.translationValues(
        0,
        widget.lift && _hovered ? -5 : 0,
        0,
      ),
      transformAlignment: Alignment.center,
      padding: widget.padding,
      decoration: BoxDecoration(
        color: widget.gradient == null
            ? (widget.color ?? colors.surface)
            : null,
        gradient: widget.gradient,
        borderRadius: radius,
        border: Border.all(
          color: _hovered
              ? (widget.hoverBorderColor ??
                    colors.accent.withValues(alpha: 0.65))
              : (widget.borderColor ?? colors.border.withValues(alpha: 0.55)),
          width: 1,
        ),
        boxShadow: _hovered
            ? [
                BoxShadow(
                  color: colors.accent.withValues(alpha: 0.12),
                  blurRadius: 22,
                  offset: const Offset(0, 10),
                ),
              ]
            : const [],
      ),
      child: widget.child,
    );

    if (!interactive) {
      return MouseRegion(
        onEnter: (_) => _setHovered(true),
        onExit: (_) => _setHovered(false),
        child: card,
      );
    }

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => _setHovered(true),
      onExit: (_) => _setHovered(false),
      child: Semantics(
        button: true,
        child: Material(
          color: Colors.transparent,
          borderRadius: radius,
          child: InkWell(
            onTap: widget.onTap,
            borderRadius: radius,
            child: card,
          ),
        ),
      ),
    );
  }
}
