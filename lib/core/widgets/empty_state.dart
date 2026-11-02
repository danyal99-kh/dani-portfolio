import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';
import 'app_button.dart';

class EmptyState extends StatelessWidget {
  const EmptyState({
    super.key,
    required this.icon,
    required this.title,
    required this.message,
    this.actionLabel,
    this.onAction,
  });

  final IconData icon;
  final String title;
  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
      decoration: BoxDecoration(
        color: colors.surfaceAlt,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: colors.border.withValues(alpha: 0.5)),
      ),
      child: Column(
        children: [
          Icon(icon, size: 40, color: colors.muted),
          const SizedBox(height: 16),
          Text(
            title,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(
            message,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium
                ?.copyWith(color: colors.muted),
          ),
          if (actionLabel != null && onAction != null) ...[
            const SizedBox(height: 20),
            AppButton(
              label: actionLabel!,
              onPressed: onAction,
              variant: AppButtonVariant.secondary,
              icon: Icons.refresh_rounded,
            ),
          ],
        ],
      ),
    );
  }
}
