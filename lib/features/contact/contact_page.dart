import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../app/localization/app_localizations.dart';
import '../../app/theme/app_colors.dart';
import '../../core/utils/link_service.dart';
import '../../core/utils/responsive.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/reveal_on_mount.dart';
import '../../core/widgets/section_header.dart';
import '../../core/widgets/social_links_row.dart';
import '../../data/content/contact_data.dart';
import '../../data/content/profile_data.dart';

class ContactPage extends StatefulWidget {
  const ContactPage({super.key});

  @override
  State<ContactPage> createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _subjectController = TextEditingController();
  final _messageController = TextEditingController();
  bool _submitting = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _subjectController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  String? _validateName(String? value) {
    final l10n = context.l10n;
    final text = value?.trim() ?? '';
    if (text.isEmpty) return l10n.t('contact.validationName');
    if (text.length < 2) return l10n.t('contact.validationNameShort');
    return null;
  }

  String? _validateEmail(String? value) {
    final l10n = context.l10n;
    final text = value?.trim() ?? '';
    final pattern = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
    if (text.isEmpty || !pattern.hasMatch(text)) {
      return l10n.t('contact.validationEmail');
    }
    return null;
  }

  String? _validateSubject(String? value) {
    if ((value?.trim() ?? '').isEmpty) {
      return context.l10n.t('contact.validationSubject');
    }
    return null;
  }

  String? _validateMessage(String? value) {
    if ((value?.trim() ?? '').length < 10) {
      return context.l10n.t('contact.validationMessage');
    }
    return null;
  }

  Future<void> _submit() async {
    final l10n = context.l10n;
    if (!(_formKey.currentState?.validate() ?? false)) return;
    if (_submitting) return;
    setState(() => _submitting = true);

    final emailConfigured =
        !isPlaceholderUrl(contactEmail) && !(emailLink?.isPlaceholder ?? true);

    if (!emailConfigured) {
      setState(() => _submitting = false);
      showAppSnackBar(context, l10n.t('contact.emailNotConfigured'));
      return;
    }

    final subject =
        '${l10n.t('contact.subjectPrefix')}: ${_subjectController.text.trim()}';
    final body =
        '${_messageController.text.trim()}\n\n'
        '— ${_nameController.text.trim()} <${_emailController.text.trim()}>';

    final uri = Uri(
      scheme: 'mailto',
      path: contactEmail,
      queryParameters: {'subject': subject, 'body': body},
    );

    try {
      final opened = await launchUrl(uri, mode: LaunchMode.platformDefault);
      if (!mounted) return;
      setState(() => _submitting = false);
      showAppSnackBar(
        context,
        l10n.t(opened ? 'contact.openedEmail' : 'contact.sendFailed'),
      );
    } catch (_) {
      if (!mounted) return;
      setState(() => _submitting = false);
      showAppSnackBar(context, l10n.t('contact.sendFailed'));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final isFa = l10n.isFa;

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
            eyebrow: l10n.t('nav.contact'),
            title: l10n.t('contact.title'),
            subtitle: l10n.t('contact.subtitle'),
            icon: Icons.mail_outline_rounded,
          ),
          SizedBox(height: context.sectionGap),
          if (context.isMobile)
            Column(
              children: [
                _FormCard(
                  formKey: _formKey,
                  nameController: _nameController,
                  emailController: _emailController,
                  subjectController: _subjectController,
                  messageController: _messageController,
                  submitting: _submitting,
                  validateName: _validateName,
                  validateEmail: _validateEmail,
                  validateSubject: _validateSubject,
                  validateMessage: _validateMessage,
                  onSubmit: _submit,
                ),
                const SizedBox(height: 20),
                _InfoCard(isFa: isFa),
              ],
            )
          else
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 6,
                  child: _FormCard(
                    formKey: _formKey,
                    nameController: _nameController,
                    emailController: _emailController,
                    subjectController: _subjectController,
                    messageController: _messageController,
                    submitting: _submitting,
                    validateName: _validateName,
                    validateEmail: _validateEmail,
                    validateSubject: _validateSubject,
                    validateMessage: _validateMessage,
                    onSubmit: _submit,
                  ),
                ),
                const SizedBox(width: 22),
                Expanded(flex: 4, child: _InfoCard(isFa: isFa)),
              ],
            ),
        ],
      ),
    );
  }
}

class _FormCard extends StatelessWidget {
  const _FormCard({
    required this.formKey,
    required this.nameController,
    required this.emailController,
    required this.subjectController,
    required this.messageController,
    required this.submitting,
    required this.validateName,
    required this.validateEmail,
    required this.validateSubject,
    required this.validateMessage,
    required this.onSubmit,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController subjectController;
  final TextEditingController messageController;
  final bool submitting;
  final FormFieldValidator<String> validateName;
  final FormFieldValidator<String> validateEmail;
  final FormFieldValidator<String> validateSubject;
  final FormFieldValidator<String> validateMessage;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    return RevealOnMount(
      child: Container(
        padding: EdgeInsets.all(context.isMobile ? 20 : 26),
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: colors.border.withValues(alpha: 0.55)),
        ),
        child: Form(
          key: formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: colors.accent.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      Icons.edit_outlined,
                      size: 19,
                      color: colors.accent,
                    ),
                  ),
                  const SizedBox(width: 11),
                  Expanded(
                    child: Text(
                      l10n.t('contact.formTitle'),
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              if (context.isMobile) ...[
                TextFormField(
                  key: const Key('contact-name'),
                  controller: nameController,
                  validator: validateName,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    labelText: l10n.t('contact.name'),
                    hintText: l10n.t('contact.nameHint'),
                    prefixIcon: const Icon(Icons.person_outline_rounded),
                  ),
                ),
                const SizedBox(height: 14),
                TextFormField(
                  key: const Key('contact-email'),
                  controller: emailController,
                  validator: validateEmail,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    labelText: l10n.t('contact.emailField'),
                    hintText: l10n.t('contact.emailHint'),
                    prefixIcon: const Icon(Icons.alternate_email_rounded),
                  ),
                ),
              ] else
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: TextFormField(
                        key: const Key('contact-name'),
                        controller: nameController,
                        validator: validateName,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          labelText: l10n.t('contact.name'),
                          hintText: l10n.t('contact.nameHint'),
                          prefixIcon: const Icon(Icons.person_outline_rounded),
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: TextFormField(
                        key: const Key('contact-email'),
                        controller: emailController,
                        validator: validateEmail,
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          labelText: l10n.t('contact.emailField'),
                          hintText: l10n.t('contact.emailHint'),
                          prefixIcon: const Icon(Icons.alternate_email_rounded),
                        ),
                      ),
                    ),
                  ],
                ),
              const SizedBox(height: 14),
              TextFormField(
                key: const Key('contact-subject'),
                controller: subjectController,
                validator: validateSubject,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  labelText: l10n.t('contact.subject'),
                  hintText: l10n.t('contact.subjectHint'),
                  prefixIcon: const Icon(Icons.subject_rounded),
                ),
              ),
              const SizedBox(height: 14),
              TextFormField(
                key: const Key('contact-message'),
                controller: messageController,
                validator: validateMessage,
                minLines: 5,
                maxLines: 8,
                keyboardType: TextInputType.multiline,
                decoration: InputDecoration(
                  labelText: l10n.t('contact.message'),
                  hintText: l10n.t('contact.messageHint'),
                  alignLabelWithHint: true,
                ),
              ),
              const SizedBox(height: 18),
              AppButton(
                key: const Key('contact-send'),
                label: l10n.t('contact.send'),
                onPressed: submitting ? null : onSubmit,
                icon: submitting
                    ? Icons.hourglass_top_rounded
                    : Icons.send_rounded,
                expand: true,
              ),
              const SizedBox(height: 14),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.lock_outline_rounded,
                    size: 15,
                    color: colors.muted,
                  ),
                  const SizedBox(width: 7),
                  Expanded(
                    child: Text(
                      l10n.t('contact.formNote'),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: colors.muted,
                        fontSize: 11,
                        height: 1.6,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({required this.isFa});

  final bool isFa;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    return RevealOnMount(
      delay: const Duration(milliseconds: 100),
      child: Container(
        padding: EdgeInsets.all(context.isMobile ? 20 : 26),
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: colors.border.withValues(alpha: 0.55)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.t('contact.infoTitle'),
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 6),
            Text(
              l10n.t('contact.infoSubtitle'),
              style: Theme.of(context).textTheme.bodySmall
                  ?.copyWith(color: colors.muted, height: 1.6),
            ),
            const SizedBox(height: 20),
            _InfoRow(
              icon: Icons.alternate_email_rounded,
              label: l10n.t('contact.directEmail'),
              value: contactEmail,
              onTap: () => openExternalLink(
                context,
                'mailto:$contactEmail',
                isPlaceholder: isPlaceholderUrl(contactEmail),
                mode: LaunchMode.platformDefault,
              ),
            ),
            const SizedBox(height: 10),
            _InfoRow(
              icon: Icons.location_on_outlined,
              label: l10n.t('common.location'),
              value: profile.location(isFa),
            ),
            const SizedBox(height: 10),
            _InfoRow(
              icon: Icons.verified_user_outlined,
              label: l10n.t('common.availability'),
              value: profile.availability(isFa),
            ),
            const SizedBox(height: 20),
            Text(
              l10n.t('footer.social'),
              style: Theme.of(context).textTheme.labelLarge
                  ?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 10),
            SocialLinksRow(showLabels: true),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: colors.accent.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(11),
                border: Border.all(
                  color: colors.accent.withValues(alpha: 0.22),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.info_outline_rounded,
                    size: 16,
                    color: colors.accent,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      l10n.t('contact.placeholderNote'),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: colors.muted,
                        fontSize: 10.5,
                        height: 1.6,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            Text(
              l10n.t('contact.responseNote'),
              style: Theme.of(context).textTheme.bodySmall
                  ?.copyWith(color: colors.muted, fontSize: 10.5),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
    this.onTap,
  });

  final IconData icon;
  final String label;
  final String value;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: colors.surfaceAlt,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, size: 16, color: colors.accent),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: Theme.of(context).textTheme.labelSmall
                        ?.copyWith(color: colors.muted),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    value,
                    style: Theme.of(context).textTheme.bodySmall
                        ?.copyWith(color: colors.text, height: 1.5),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
