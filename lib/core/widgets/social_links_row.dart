import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../app/localization/app_localizations.dart';
import '../../app/theme/app_colors.dart';
import '../../data/content/contact_data.dart';
import '../../data/models/social_link.dart';
import '../utils/link_service.dart';
import 'pressable_scale.dart';

class SocialLinksRow extends StatelessWidget {
  const SocialLinksRow({
    super.key,
    this.showLabels = false,
    this.links,
    this.alignment = WrapAlignment.start,
  });

  final bool showLabels;
  final List<SocialLink>? links;
  final WrapAlignment alignment;

  @override
  Widget build(BuildContext context) {
    final items = links ?? socialLinks;
    return Wrap(
      alignment: alignment,
      spacing: 10,
      runSpacing: 10,
      children: [
        for (final link in items)
          _SocialButton(link: link, showLabel: showLabels),
      ],
    );
  }
}

class _SocialButton extends StatefulWidget {
  const _SocialButton({required this.link, required this.showLabel});

  final SocialLink link;
  final bool showLabel;

  @override
  State<_SocialButton> createState() => _SocialButtonState();
}

class _SocialButtonState extends State<_SocialButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;
    final link = widget.link;
    final placeholder = link.isPlaceholder;

    final content = AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      padding: EdgeInsets.symmetric(
        horizontal: widget.showLabel ? 14 : 0,
        vertical: widget.showLabel ? 10 : 0,
      ),
      constraints: BoxConstraints(minWidth: 46, minHeight: 46),
      decoration: BoxDecoration(
        color: _hovered
            ? colors.accent.withValues(alpha: 0.16)
            : colors.surfaceAlt,
        borderRadius: BorderRadius.circular(13),
        border: Border.all(
          color: _hovered
              ? colors.accent.withValues(alpha: 0.6)
              : colors.border.withValues(alpha: 0.55),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            placeholder ? Icons.link_off_rounded : link.icon,
            size: 19,
            color: placeholder ? colors.muted : colors.text,
          ),
          if (widget.showLabel) ...[
            const SizedBox(width: 8),
            Text(
              link.label(l10n.isFa),
              style: Theme.of(context).textTheme.labelMedium
                  ?.copyWith(color: colors.text, fontWeight: FontWeight.w600),
            ),
          ],
        ],
      ),
    );

    return Tooltip(
      message: placeholder
          ? l10n.t('a11y.placeholderLink')
          : link.label(l10n.isFa),
      child: Semantics(
        button: true,
        label: placeholder
            ? '${link.label(l10n.isFa)} — ${l10n.t('common.placeholderLink')}'
            : link.label(l10n.isFa),
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          onEnter: (_) => setState(() => _hovered = true),
          onExit: (_) => setState(() => _hovered = false),
          child: GestureDetector(
            onTap: () => openExternalLink(
              context,
              link.url,
              isPlaceholder: placeholder,
              mode: link.isEmail
                  ? LaunchMode.platformDefault
                  : LaunchMode.externalApplication,
            ),
            child: PressableScale(scale: 0.94, child: content),
          ),
        ),
      ),
    );
  }
}
