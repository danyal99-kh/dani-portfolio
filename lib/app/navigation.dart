import 'package:flutter/material.dart';

class NavItem {
  const NavItem({
    required this.path,
    required this.labelKey,
    required this.icon,
  });

  final String path;
  final String labelKey;
  final IconData icon;

  bool isActive(String location) {
    if (path == '/') return location == '/';
    return location == path || location.startsWith('$path/');
  }
}

const List<NavItem> navItems = [
  NavItem(
    path: '/',
    labelKey: 'nav.home',
    icon: Icons.space_dashboard_outlined,
  ),
  NavItem(
    path: '/about',
    labelKey: 'nav.about',
    icon: Icons.person_outline_rounded,
  ),
  NavItem(
    path: '/projects',
    labelKey: 'nav.projects',
    icon: Icons.work_outline_rounded,
  ),
  NavItem(
    path: '/skills',
    labelKey: 'nav.skills',
    icon: Icons.auto_awesome_outlined,
  ),
  NavItem(
    path: '/resume',
    labelKey: 'nav.resume',
    icon: Icons.description_outlined,
  ),
  NavItem(
    path: '/contact',
    labelKey: 'nav.contact',
    icon: Icons.mail_outline_rounded,
  ),
  NavItem(
    path: '/game',
    labelKey: 'nav.game',
    icon: Icons.sports_esports_outlined,
  ),
];
