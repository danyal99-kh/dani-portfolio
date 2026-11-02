import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/widgets/portfolio_shell.dart';
import '../../features/about/about_page.dart';
import '../../features/case_study/case_study_page.dart';
import '../../features/contact/contact_page.dart';
import '../../features/dashboard/dashboard_page.dart';
import '../../features/game/game_page.dart';
import '../../features/not_found_page.dart';
import '../../features/projects/projects_page.dart';
import '../../features/resume/resume_page.dart';
import '../../features/skills/skills_page.dart';

GoRouter buildRouter({String initialLocation = '/'}) {
  return GoRouter(
    initialLocation: initialLocation,
    debugLogDiagnostics: false,
    routes: [
      ShellRoute(
        builder: (context, state, child) {
          return PortfolioShell(location: state.uri.path, child: child);
        },
        routes: [
          GoRoute(
            path: '/',
            pageBuilder: (context, state) =>
                _fadePage(state, const DashboardPage()),
          ),
          GoRoute(
            path: '/about',
            pageBuilder: (context, state) =>
                _fadePage(state, const AboutPage()),
          ),
          GoRoute(
            path: '/projects',
            pageBuilder: (context, state) =>
                _fadePage(state, const ProjectsPage()),
          ),
          GoRoute(
            path: '/projects/:id',
            pageBuilder: (context, state) => _fadePage(
              state,
              CaseStudyPage(projectId: state.pathParameters['id'] ?? ''),
            ),
          ),
          GoRoute(
            path: '/skills',
            pageBuilder: (context, state) =>
                _fadePage(state, const SkillsPage()),
          ),
          GoRoute(
            path: '/resume',
            pageBuilder: (context, state) =>
                _fadePage(state, const ResumePage()),
          ),
          GoRoute(
            path: '/contact',
            pageBuilder: (context, state) =>
                _fadePage(state, const ContactPage()),
          ),
          GoRoute(
            path: '/game',
            pageBuilder: (context, state) => _fadePage(state, const GamePage()),
          ),
        ],
      ),
    ],
    errorBuilder: (context, state) {
      return PortfolioShell(
        location: state.uri.path,
        child: const NotFoundPage(),
      );
    },
  );
}

CustomTransitionPage<void> _fadePage(GoRouterState state, Widget child) {
  return CustomTransitionPage<void>(
    key: state.pageKey,
    child: child,
    transitionDuration: const Duration(milliseconds: 300),
    reverseTransitionDuration: const Duration(milliseconds: 220),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      if (MediaQuery.maybeDisableAnimationsOf(context) ?? false) return child;
      final curved = CurvedAnimation(
        parent: animation,
        curve: Curves.easeOutCubic,
        reverseCurve: Curves.easeInCubic,
      );
      return FadeTransition(
        opacity: curved,
        child: SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, 0.025),
            end: Offset.zero,
          ).animate(curved),
          child: child,
        ),
      );
    },
  );
}
