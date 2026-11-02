import 'package:flutter/material.dart';

class SocialLink {
  const SocialLink({
    required this.id,
    required this.labelFa,
    required this.labelEn,
    required this.url,
    required this.icon,
  });

  final String id;
  final String labelFa;
  final String labelEn;
  final String url;
  final IconData icon;

  String label(bool isFa) => isFa ? labelFa : labelEn;

  bool get isPlaceholder =>
      url.contains('YOUR_') ||
      url.contains('example.com') ||
      url.contains('your-') ||
      url.trim().isEmpty;

  bool get isEmail => url.startsWith('mailto:');

  String get emailAddress =>
      isEmail ? Uri.decodeComponent(url.substring('mailto:'.length)) : '';
}
