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
  });

  final String label;
  final bool selected;
  final VoidCallback? onTap;
  final IconData? icon;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final content = Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 10 : 13,
        vertical: compact ? 6 : 8,
      ),
      decoration: BoxDecoration(
        color: selected
            ? colors.accent.withValues(alpha: 0.18)
            : colors.surfaceAlt,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: selected
              ? colors.accent.withValues(alpha: 0.75)
              : colors.border.withValues(alpha: 0.55),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(
              icon,
              size: compact ? 13 : 15,
              color: selected ? colors.accent : colors.muted,
            ),
            const SizedBox(width: 6),
          ],
          Flexible(
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: selected ? colors.accent : colors.text,
                fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
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
