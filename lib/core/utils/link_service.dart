import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../app/localization/app_localizations.dart';

bool isPlaceholderUrl(String? url) {
  if (url == null) return false;
  final value = url.trim().toLowerCase();
  return value.isEmpty ||
      value.contains('your_') ||
      value.contains('your-') ||
      value.contains('example.com') ||
      value == '#';
}

void showAppSnackBar(BuildContext context, String message) {
  final messenger = ScaffoldMessenger.maybeOf(context);
  if (messenger == null) return;
  messenger
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(message)));
}

/// Opens a link only when it is a real, configured destination. Placeholder
/// links never pretend to work; they explain how to replace them instead.
Future<bool> openExternalLink(
  BuildContext context,
  String url, {
  bool isPlaceholder = false,
  LaunchMode mode = LaunchMode.externalApplication,
}) async {
  final l10n = context.l10n;
  if (isPlaceholder || isPlaceholderUrl(url)) {
    showAppSnackBar(context, l10n.t('common.placeholderLinkNotice'));
    return false;
  }

  final uri = Uri.tryParse(url);
  if (uri == null) {
    showAppSnackBar(context, l10n.t('contact.sendFailed'));
    return false;
  }

  try {
    final opened = await launchUrl(uri, mode: mode);
    if (!opened && context.mounted) {
      showAppSnackBar(context, l10n.t('contact.sendFailed'));
    }
    return opened;
  } catch (_) {
    if (context.mounted) {
      showAppSnackBar(context, l10n.t('contact.sendFailed'));
    }
    return false;
  }
}
