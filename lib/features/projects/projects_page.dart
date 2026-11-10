import 'package:flutter/material.dart';

import '../../app/localization/app_localizations.dart';
import '../../app/theme/app_colors.dart';
import '../../core/utils/responsive.dart';
import '../../core/widgets/animated_project_card.dart';
import '../../core/widgets/empty_state.dart';
import '../../core/widgets/responsive_grid.dart';
import '../../core/widgets/reveal_on_visible.dart';
import '../../core/widgets/section_header.dart';
import '../../core/widgets/tech_chip.dart';
import '../../data/content/projects_data.dart';
import '../../data/models/project.dart';

class ProjectsPage extends StatefulWidget {
  const ProjectsPage({super.key});

  @override
  State<ProjectsPage> createState() => _ProjectsPageState();
}

class _ProjectsPageState extends State<ProjectsPage> {
  final _searchController = TextEditingController();
  String _query = '';
  String? _tech;
  ProjectStatus? _status;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Project> get _filtered {
    return projects.where((project) {
      if (!project.matches(_query)) return false;
      if (_tech != null && !project.tech.contains(_tech)) return false;
      if (_status != null && project.status != _status) return false;
      return true;
    }).toList();
  }

  bool get _hasFilters =>
      _query.trim().isNotEmpty || _tech != null || _status != null;

  void _clearFilters() {
    _searchController.clear();
    setState(() {
      _query = '';
      _tech = null;
      _status = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    final filtered = _filtered;

    return ContentContainer(
      maxWidth: 1180,
      padding: EdgeInsets.only(
        left: context.pageHorizontalPadding,
        right: context.pageHorizontalPadding,
        top: context.isMobile ? 28 : 48,
        bottom: context.isMobile ? 56 : 80,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          PageHeader(
            eyebrow: l10n.t('nav.projects'),
            title: l10n.t('projects.title'),
            subtitle: l10n.t('projects.subtitle'),
            icon: Icons.work_outline_rounded,
          ),
          const SizedBox(height: 28),
          RevealOnVisible(
            child: _FilterPanel(
              controller: _searchController,
              query: _query,
              tech: _tech,
              status: _status,
              hasFilters: _hasFilters,
              onQueryChanged: (value) => setState(() => _query = value),
              onTechChanged: (value) => setState(() {
                _tech = _tech == value ? null : value;
              }),
              onStatusChanged: (value) => setState(() {
                _status = _status == value ? null : value;
              }),
              onClear: _clearFilters,
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 11,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: colors.accent.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  l10n.tCount('projects.showing', filtered.length),
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: colors.accent,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const Spacer(),
              if (_hasFilters)
                TextButton.icon(
                  onPressed: _clearFilters,
                  icon: const Icon(Icons.filter_alt_off_outlined, size: 16),
                  label: Text(l10n.t('common.clearFilters')),
                ),
            ],
          ),
          const SizedBox(height: 16),
          AnimatedSwitcher(
            duration: context.reduceMotion
                ? Duration.zero
                : const Duration(milliseconds: 250),
            child: filtered.isEmpty
                ? EmptyState(
                    key: const ValueKey('empty'),
                    icon: Icons.search_off_rounded,
                    title: l10n.t('common.noResults'),
                    message: l10n.t('common.noResultsHint'),
                    actionLabel: l10n.t('common.clearFilters'),
                    onAction: _clearFilters,
                  )
                : ResponsiveGrid(
                    key: ValueKey(
                      '${_query}_${_tech}_${_status?.name}_${filtered.length}',
                    ),
                    minItemWidth: 340,
                    maxColumns: 2,
                    spacing: 22,
                    children: [
                      for (var i = 0; i < filtered.length; i++)
                        AnimatedProjectCard(
                          project: filtered[i],
                          index: projects.indexOf(filtered[i]),
                          delay: Duration(milliseconds: 80 * i),
                        ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}

class _FilterPanel extends StatelessWidget {
  const _FilterPanel({
    required this.controller,
    required this.query,
    required this.tech,
    required this.status,
    required this.hasFilters,
    required this.onQueryChanged,
    required this.onTechChanged,
    required this.onStatusChanged,
    required this.onClear,
  });

  final TextEditingController controller;
  final String query;
  final String? tech;
  final ProjectStatus? status;
  final bool hasFilters;
  final ValueChanged<String> onQueryChanged;
  final ValueChanged<String> onTechChanged;
  final ValueChanged<ProjectStatus> onStatusChanged;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;

    return Container(
      padding: EdgeInsets.all(context.isMobile ? 18 : 22),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: colors.border.withValues(alpha: 0.55)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            key: const Key('project-search'),
            controller: controller,
            onChanged: onQueryChanged,
            textInputAction: TextInputAction.search,
            decoration: InputDecoration(
              hintText: l10n.t('projects.searchHint'),
              prefixIcon: const Icon(Icons.search_rounded, size: 20),
              suffixIcon: query.isEmpty
                  ? null
                  : IconButton(
                      tooltip: l10n.t('common.clearFilters'),
                      onPressed: () {
                        controller.clear();
                        onQueryChanged('');
                      },
                      icon: const Icon(Icons.close_rounded, size: 18),
                    ),
            ),
          ),
          const SizedBox(height: 18),
          Text(
            l10n.t('common.filterByTech'),
            style: Theme.of(context).textTheme.labelMedium
                ?.copyWith(color: colors.muted, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 9),
          Wrap(
            spacing: 7,
            runSpacing: 7,
            children: [
              TechChip(
                label: l10n.t('common.all'),
                selected: tech == null,
                onTap: () {
                  if (tech != null) onTechChanged(tech!);
                },
              ),
              for (final item in allTechnologies)
                TechChip(
                  label: item,
                  selected: tech == item,
                  onTap: () => onTechChanged(item),
                ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            l10n.t('projects.statusFilter'),
            style: Theme.of(context).textTheme.labelMedium
                ?.copyWith(color: colors.muted, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 9),
          Wrap(
            spacing: 7,
            runSpacing: 7,
            children: [
              TechChip(
                label: l10n.t('projects.allStatuses'),
                selected: status == null,
                onTap: () {
                  if (status != null) onStatusChanged(status!);
                },
              ),
              for (final item in ProjectStatus.values)
                TechChip(
                  label: l10n.t(item.translationKey),
                  selected: status == item,
                  onTap: () => onStatusChanged(item),
                ),
            ],
          ),
          const SizedBox(height: 6),
          if (hasFilters)
            Align(
              alignment: AlignmentDirectional.centerEnd,
              child: TextButton.icon(
                onPressed: onClear,
                icon: const Icon(Icons.filter_alt_off_outlined, size: 16),
                label: Text(l10n.t('common.clearFilters')),
              ),
            ),
        ],
      ),
    );
  }
}
