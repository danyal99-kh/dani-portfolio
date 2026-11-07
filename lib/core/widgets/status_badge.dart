import 'package:flutter/material.dart';

import '../../app/localization/app_localizations.dart';
import '../../app/theme/app_colors.dart';
import '../../data/models/project.dart';

class StatusBadge extends StatelessWidget {
  const StatusBadge({
    super.key,
    required this.status,
    this.compact = false,
    this.accentColor,
  });

  final ProjectStatus status;
  final bool compact;
  final Color? accentColor;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;
    final (color, icon) = switch (status) {
      ProjectStatus.completed => (colors.success, Icons.check_circle_outline),
      ProjectStatus.inProgress => (colors.warning, Icons.timelapse_rounded),
      ProjectStatus.prototype => (colors.accent, Icons.science_outlined),
      ProjectStatus.concept => (colors.muted, Icons.lightbulb_outline_rounded),
    };
    final tone = accentColor ?? color;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 8 : 10,
        vertical: compact ? 4 : 5,
      ),
      decoration: BoxDecoration(
        color: tone.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: tone.withValues(alpha: 0.52)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: compact ? 11 : 13, color: color),
          const SizedBox(width: 5),
          Text(
            l10n.t(status.translationKey),
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: color,
              fontWeight: FontWeight.w700,
              fontSize: compact ? 10.5 : 11.5,
            ),
          ),
        ],
      ),
    );
  }
}
