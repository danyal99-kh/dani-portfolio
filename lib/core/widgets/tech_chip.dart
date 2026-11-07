import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';

class TechChip extends StatelessWidget {
  const TechChip({
    super.key,
    required this.label,
    this.selected = false,
    this.onTap,
    this.icon,
    this.compact = false,
    this.accentColor,
    this.raised = false,
  });

  final String label;
  final bool selected;
  final VoidCallback? onTap;
  final IconData? icon;
  final bool compact;
  final Color? accentColor;
  final bool raised;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final tone = accentColor ?? colors.accent;
    final accented = accentColor != null;
    final highlighted = selected || accented;
    final content = Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 10 : 13,
        vertical: compact ? 6 : 8,
      ),
      decoration: BoxDecoration(
        color: selected
            ? tone.withValues(alpha: 0.18)
            : accented
            ? tone.withValues(alpha: 0.1)
            : colors.surfaceAlt,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: selected
              ? tone.withValues(alpha: 0.75)
              : accented
              ? tone.withValues(alpha: 0.34)
              : colors.border.withValues(alpha: 0.55),
        ),
        boxShadow: raised
            ? [
                BoxShadow(
                  color: Colors.black.withValues(
                    alpha: context.isDark ? 0.22 : 0.08,
                  ),
                  blurRadius: 7,
                  offset: const Offset(0, 3),
                ),
                BoxShadow(
                  color: Colors.white.withValues(
                    alpha: context.isDark ? 0.04 : 0.5,
                  ),
                  blurRadius: 1,
                  offset: const Offset(0, -1),
                ),
              ]
            : null,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(
              icon,
              size: compact ? 13 : 15,
              color: highlighted ? tone : colors.muted,
            ),
            const SizedBox(width: 6),
          ],
          Flexible(
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: highlighted ? tone : colors.text,
                fontWeight: selected
                    ? FontWeight.w700
                    : accented
                    ? FontWeight.w600
                    : FontWeight.w500,
                fontSize: compact ? 11.5 : 12.5,
              ),
            ),
          ),
        ],
      ),
    );

    if (onTap == null) return content;

    return Semantics(
      button: true,
      selected: selected,
      label: label,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(onTap: onTap, child: content),
      ),
    );
  }
}
