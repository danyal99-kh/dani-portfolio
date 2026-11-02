import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../app/localization/app_localizations.dart';
import '../../app/theme/app_colors.dart';
import '../../data/models/project.dart';
import 'app_image.dart';
import 'hover_card.dart';
import 'status_badge.dart';
import 'tech_chip.dart';

class ProjectCard extends StatelessWidget {
  const ProjectCard({super.key, required this.project});

  final Project project;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;
    final isFa = l10n.isFa;

    return HoverCard(
      onTap: () => context.go('/projects/${project.id}'),
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              AppImage(
                asset: project.imageAsset,
                height: 188,
                width: double.infinity,
                borderRadius: 21,
              ),
              Positioned(
                top: 12,
                left: 12,
                right: 12,
                child: Row(
                  children: [
                    StatusBadge(status: project.status, compact: true),
                    const Spacer(),
                    if (project.featured)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: colors.background.withValues(alpha: 0.85),
                          borderRadius: BorderRadius.circular(999),
                          border: Border.all(
                            color: colors.border.withValues(alpha: 0.6),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.star_rounded,
                              size: 11,
                              color: colors.warning,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              l10n.t('common.featured'),
                              style: Theme.of(context).textTheme.labelSmall
                                  ?.copyWith(
                                    color: colors.text,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w700,
                                  ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  project.category(isFa).toUpperCase(),
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: colors.accent,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.9,
                    fontSize: 10,
                  ),
                ),
                const SizedBox(height: 7),
                Text(
                  project.name,
                  style: Theme.of(context).textTheme.titleLarge
                      ?.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 8),
                Text(
                  project.summary(isFa),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodySmall
                      ?.copyWith(color: colors.muted, height: 1.7),
                ),
                const SizedBox(height: 14),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: [
                    for (final tech in project.tech.take(3))
                      TechChip(label: tech, compact: true),
                    if (project.tech.length > 3)
                      TechChip(
                        label: '+${project.tech.length - 3}',
                        compact: true,
                      ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Text(
                      l10n.t('common.viewCaseStudy'),
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: colors.accent,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Icon(
                      Directionality.of(context) == TextDirection.rtl
                          ? Icons.arrow_back_rounded
                          : Icons.arrow_forward_rounded,
                      size: 16,
                      color: colors.accent,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
