import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';
import '../utils/responsive.dart';

class SectionHeader extends StatelessWidget {
  const SectionHeader({
    super.key,
    required this.eyebrow,
    required this.title,
    this.subtitle,
    this.trailing,
    this.center = false,
  });

  final String eyebrow;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final bool center;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final textTheme = Theme.of(context).textTheme;
    final alignment = center
        ? CrossAxisAlignment.center
        : CrossAxisAlignment.start;

    final text = Column(
      crossAxisAlignment: alignment,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: colors.accent.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(999),
            border: Border.all(color: colors.accent.withValues(alpha: 0.28)),
          ),
          child: Text(
            eyebrow.toUpperCase(),
            style: textTheme.labelSmall?.copyWith(
              color: colors.accent,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.2,
              fontSize: 10.5,
            ),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          title,
          textAlign: center ? TextAlign.center : TextAlign.start,
          style: context.isMobile
              ? textTheme.headlineMedium
              : textTheme.headlineSmall,
        ),
        if (subtitle != null) ...[
          const SizedBox(height: 8),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 680),
            child: Text(
              subtitle!,
              textAlign: center ? TextAlign.center : TextAlign.start,
              style: textTheme.bodyMedium?.copyWith(color: colors.muted),
            ),
          ),
        ],
      ],
    );

    if (trailing == null) return text;

    if (context.isMobile) {
      return Column(
        crossAxisAlignment: alignment,
        children: [text, const SizedBox(height: 18), trailing!],
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(child: text),
        const SizedBox(width: 24),
        trailing!,
      ],
    );
  }
}

class PageHeader extends StatelessWidget {
  const PageHeader({
    super.key,
    required this.eyebrow,
    required this.title,
    required this.subtitle,
    this.icon,
  });

  final String eyebrow;
  final String title;
  final String subtitle;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return RevealHeader(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (icon != null) ...[
                Container(
                  padding: const EdgeInsets.all(9),
                  decoration: BoxDecoration(
                    color: colors.accent.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: colors.accent.withValues(alpha: 0.25),
                    ),
                  ),
                  child: Icon(icon, color: colors.accent, size: 19),
                ),
                const SizedBox(width: 10),
              ],
              Text(
                eyebrow.toUpperCase(),
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: colors.accent,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.4,
                  fontSize: 11,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(title, style: Theme.of(context).textTheme.displaySmall),
          const SizedBox(height: 12),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 760),
            child: Text(
              subtitle,
              style: Theme.of(context).textTheme.bodyLarge
                  ?.copyWith(color: colors.muted),
            ),
          ),
        ],
      ),
    );
  }
}

class RevealHeader extends StatelessWidget {
  const RevealHeader({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) => child;
}
