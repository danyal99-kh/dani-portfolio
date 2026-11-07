import 'package:flutter/material.dart';

import '../models/social_link.dart';

/// Central source of truth for email and social profile links.
const String contactEmail = 'danyal.danyal1385@gmail.com';

const List<SocialLink> socialLinks = [
  SocialLink(
    id: 'email',
    labelFa: 'ایمیل',
    labelEn: 'Email',
    url: 'mailto:$contactEmail',
    icon: Icons.alternate_email_rounded,
  ),
  SocialLink(
    id: 'github',
    labelFa: 'گیت‌هاب',
    labelEn: 'GitHub',
    url: 'https://github.com/danyal99-kh',
    icon: Icons.code_rounded,
  ),
  SocialLink(
    id: 'telegram',
    labelFa: 'تلگرام',
    labelEn: 'Telegram',
    url: 'https://t.me/danyal99_kh',
    icon: Icons.send_rounded,
  ),
  SocialLink(
    id: 'linkedin',
    labelFa: 'لینکدین',
    labelEn: 'LinkedIn',
    url: 'https://www.linkedin.com/in/danyal-khodaei-912795345/',
    icon: Icons.work_outline_rounded,
  ),
];

SocialLink? get emailLink {
  for (final link in socialLinks) {
    if (link.isEmail) return link;
  }
  return null;
}

bool get hasPlaceholderContacts =>
    socialLinks.any((link) => link.isPlaceholder);
