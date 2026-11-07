import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import '../../app/localization/app_localizations.dart';
import '../../app/theme/app_colors.dart';
import '../../core/utils/file_download.dart';
import '../../core/utils/link_service.dart';
import '../../core/utils/responsive.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/hover_card.dart';
import '../../core/widgets/reveal_on_mount.dart';
import '../../core/widgets/section_header.dart';
import '../../core/widgets/social_links_row.dart';
import '../../core/widgets/tech_chip.dart';
import '../../data/content/contact_data.dart';
import '../../data/content/profile_data.dart';
import '../../data/content/projects_data.dart';
import '../../data/content/resume_data.dart';
import '../../data/content/skills_data.dart';
import '../../data/models/project.dart';
import '../../data/models/resume_entry.dart';

class ResumePage extends StatelessWidget {
  const ResumePage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;

    return ContentContainer(
      maxWidth: 1120,
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
            eyebrow: l10n.t('nav.resume'),
            title: l10n.t('resume.title'),
            subtitle: l10n.t('resume.subtitle'),
            icon: Icons.description_outlined,
          ),
          const SizedBox(height: 20),
          RevealOnMount(
            child: Wrap(
              spacing: 12,
              runSpacing: 12,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                AppButton(
                  label: l10n.t('resume.download'),
                  onPressed: () => _downloadResume(context),
                  icon: Icons.download_rounded,
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: colors.warning.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: colors.warning.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.info_outline_rounded,
                        size: 15,
                        color: colors.warning,
                      ),
                      const SizedBox(width: 7),
                      Flexible(
                        child: Text(
                          l10n.t('resume.sampleNotice'),
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(color: colors.warning, fontSize: 11),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 28),
          if (context.isMobile)
            Column(
              children: [
                _MainColumn(l10n: l10n),
                const SizedBox(height: 20),
                _SideColumn(l10n: l10n),
              ],
            )
          else
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(flex: 7, child: _MainColumn(l10n: l10n)),
                const SizedBox(width: 22),
                Expanded(flex: 4, child: _SideColumn(l10n: l10n)),
              ],
            ),
        ],
      ),
    );
  }

  static Future<void> _downloadResume(BuildContext context) async {
    final l10n = context.l10n;
    try {
      final data = await rootBundle.load(profile.resumeAsset);
      if (data.lengthInBytes == 0) {
        throw StateError('Empty resume asset');
      }
      final ok = await downloadAssetFile(
        assetPath: profile.resumeAsset,
        fileName: profile.resumeFileName,
      );
      if (!context.mounted) return;
      showAppSnackBar(
        context,
        l10n.t(ok ? 'resume.downloadStarted' : 'resume.downloadFailed'),
      );
    } catch (_) {
      if (!context.mounted) return;
      showAppSnackBar(context, l10n.t('resume.downloadFailed'));
    }
  }
}

class _MainColumn extends StatelessWidget {
  const _MainColumn({required this.l10n});

  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final isFa = l10n.isFa;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        RevealOnMount(
          child: _ResumeSection(
            title: l10n.t('resume.professionalSummary'),
            icon: Icons.person_outline_rounded,
            child: Text(
              l10n.t('resume.summaryText'),
              style: Theme.of(context).textTheme.bodyLarge
                  ?.copyWith(color: colors.muted),
            ),
          ),
        ),
        const SizedBox(height: 18),
        RevealOnMount(
          delay: const Duration(milliseconds: 60),
          child: _ResumeSection(
            title: l10n.t('resume.experience'),
            icon: Icons.work_outline_rounded,
            child: Column(
              children: [
                for (var i = 0; i < resumeExperience.length; i++)
                  _ResumeEntryTile(
                    entry: resumeExperience[i],
                    isFa: isFa,
                    isLast: i == resumeExperience.length - 1,
                  ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 18),
        RevealOnMount(
          delay: const Duration(milliseconds: 120),
          child: _ResumeSection(
            title: l10n.t('resume.education'),
            icon: Icons.school_outlined,
            child: Column(
              children: [
                for (var i = 0; i < resumeEducation.length; i++)
                  _ResumeEntryTile(
                    entry: resumeEducation[i],
                    isFa: isFa,
                    isLast: i == resumeEducation.length - 1,
                  ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 18),
        RevealOnMount(
          delay: const Duration(milliseconds: 180),
          child: _ResumeSection(
            title: l10n.t('resume.selectedProjects'),
            icon: Icons.folder_open_outlined,
            child: Column(
              children: [
                for (final project in featuredProjects)
                  _ResumeProjectRow(project: project, isFa: isFa),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _SideColumn extends StatelessWidget {
  const _SideColumn({required this.l10n});

  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final names = <String>[];
    for (final skill in skills) {
      if (!names.contains(skill.name)) names.add(skill.name);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        RevealOnMount(
          delay: const Duration(milliseconds: 80),
          child: _ResumeSection(
            title: l10n.t('resume.skills'),
            icon: Icons.auto_awesome_outlined,
            child: Wrap(
              spacing: 6,
              runSpacing: 6,
              children: [
                for (final name in names) TechChip(label: name, compact: true),
              ],
            ),
          ),
        ),
        const SizedBox(height: 18),
        RevealOnMount(
          delay: const Duration(milliseconds: 140),
          child: _ResumeSection(
            title: l10n.t('resume.languages'),
            icon: Icons.translate_rounded,
            child: Column(
              children: [
                _LanguageRow(
                  language: l10n.t('resume.persian'),
                  level: l10n.t('resume.persianLevel'),
                  flag: 'FA',
                ),
                const SizedBox(height: 10),
                _LanguageRow(
                  language: l10n.t('resume.english'),
                  level: l10n.t('resume.englishLevel'),
                  flag: 'EN',
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 18),
        RevealOnMount(
          delay: const Duration(milliseconds: 200),
          child: _ResumeSection(
            title: l10n.t('contact.infoTitle'),
            icon: Icons.alternate_email_rounded,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  contactEmail,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: colors.muted,
                    fontFamily: 'JetBrainsMono',
                  ),
                ),
                const SizedBox(height: 10),
                const SocialLinksRow(),
                const SizedBox(height: 12),
                TextButton.icon(
                  onPressed: () => context.go('/contact'),
                  icon: const Icon(Icons.mail_outline_rounded, size: 16),
                  label: Text(l10n.t('common.contactMe')),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 18),
        RevealOnMount(
          delay: const Duration(milliseconds: 260),
          child: Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: colors.codeBackground,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: colors.border.withValues(alpha: 0.5)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.picture_as_pdf_outlined,
                      size: 20,
                      color: colors.accent,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        profile.resumeFileName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.labelMedium
                            ?.copyWith(
                              fontFamily: 'JetBrainsMono',
                              fontSize: 11,
                            ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  l10n.t('resume.pdfHint'),
                  style: Theme.of(context).textTheme.bodySmall
                      ?.copyWith(color: colors.muted, fontSize: 10.5),
                ),
                const SizedBox(height: 12),
                AppButton(
                  label: l10n.t('resume.download'),
                  onPressed: () => ResumePage._downloadResume(context),
                  variant: AppButtonVariant.secondary,
                  icon: Icons.download_rounded,
                  expand: true,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _ResumeSection extends StatelessWidget {
  const _ResumeSection({
    required this.title,
    required this.icon,
    required this.child,
  });

  final String title;
  final IconData icon;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: colors.border.withValues(alpha: 0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: colors.accent.withValues(alpha: 0.11),
                  borderRadius: BorderRadius.circular(9),
                ),
                child: Icon(icon, color: colors.accent, size: 17),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium
                      ?.copyWith(fontWeight: FontWeight.w700),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }
}

class _ResumeEntryTile extends StatelessWidget {
  const _ResumeEntryTile({
    required this.entry,
    required this.isFa,
    required this.isLast,
  });

  final ResumeEntry entry;
  final bool isFa;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(
                width: 10,
                height: 10,
                margin: const EdgeInsets.only(top: 5),
                decoration: BoxDecoration(
                  color: colors.accent,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: colors.accent.withValues(alpha: 0.3),
                    width: 3,
                  ),
                ),
              ),
              if (!isLast)
                Container(
                  width: 2,
                  height: 60,
                  margin: const EdgeInsets.only(top: 4),
                  color: colors.border.withValues(alpha: 0.5),
                ),
            ],
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        entry.title(isFa),
                        style: Theme.of(context).textTheme.titleSmall
                            ?.copyWith(fontWeight: FontWeight.w700),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 7,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: colors.surfaceAlt,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        entry.period(isFa),
                        style: Theme.of(context).textTheme.labelSmall
                            ?.copyWith(color: colors.muted, fontSize: 10),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 3),
                Text(
                  entry.organization(isFa),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: colors.accent,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 7),
                for (final bullet in entry.bullets(isFa))
                  Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '• ',
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(color: colors.muted),
                        ),
                        Expanded(
                          child: Text(
                            bullet,
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(color: colors.muted, height: 1.6),
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
    );
  }
}

class _ResumeProjectRow extends StatelessWidget {
  const _ResumeProjectRow({required this.project, required this.isFa});

  final Project project;
  final bool isFa;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: HoverCard(
        onTap: () => context.go('/projects/${project.id}'),
        lift: false,
        padding: const EdgeInsets.all(13),
        child: Row(
          children: [
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: colors.accent.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(9),
              ),
              child: Icon(
                Icons.folder_outlined,
                size: 17,
                color: colors.accent,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    project.name,
                    style: Theme.of(context).textTheme.labelMedium
                        ?.copyWith(fontWeight: FontWeight.w700),
                  ),
                  Text(
                    isFa ? project.categoryFa : project.categoryEn,
                    style: Theme.of(context).textTheme.bodySmall
                        ?.copyWith(color: colors.muted, fontSize: 10.5),
                  ),
                ],
              ),
            ),
            Icon(
              Directionality.of(context) == TextDirection.rtl
                  ? Icons.arrow_back_rounded
                  : Icons.arrow_forward_rounded,
              size: 15,
              color: colors.muted,
            ),
          ],
        ),
      ),
    );
  }
}

class _LanguageRow extends StatelessWidget {
  const _LanguageRow({
    required this.language,
    required this.level,
    required this.flag,
  });

  final String language;
  final String level;
  final String flag;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Row(
      children: [
        Container(
          width: 36,
          height: 30,
          decoration: BoxDecoration(
            color: colors.surfaceAlt,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: colors.border.withValues(alpha: 0.5)),
          ),
          alignment: Alignment.center,
          child: Text(
            flag,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: colors.accent,
              fontWeight: FontWeight.w800,
              fontFamily: 'JetBrainsMono',
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            language,
            style: Theme.of(context).textTheme.labelMedium
                ?.copyWith(fontWeight: FontWeight.w600),
          ),
        ),
        Text(
          level,
          style: Theme.of(context).textTheme.bodySmall
              ?.copyWith(color: colors.muted, fontSize: 10.5),
        ),
      ],
    );
  }
}
