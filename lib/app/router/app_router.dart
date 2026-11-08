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
import 'page_transition.dart';

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
                buildPortfolioPage(state: state, child: const DashboardPage()),
          ),
          GoRoute(
            path: '/about',
            pageBuilder: (context, state) =>
                buildPortfolioPage(state: state, child: const AboutPage()),
          ),
          GoRoute(
            path: '/projects',
            pageBuilder: (context, state) =>
                buildPortfolioPage(state: state, child: const ProjectsPage()),
          ),
          GoRoute(
            path: '/projects/:id',
            pageBuilder: (context, state) => buildPortfolioPage(
              state: state,
              motion: PageMotion.caseStudy,
              child: CaseStudyPage(projectId: state.pathParameters['id'] ?? ''),
            ),
          ),
          GoRoute(
            path: '/skills',
            pageBuilder: (context, state) =>
                buildPortfolioPage(state: state, child: const SkillsPage()),
          ),
          GoRoute(
            path: '/resume',
            pageBuilder: (context, state) =>
                buildPortfolioPage(state: state, child: const ResumePage()),
          ),
          GoRoute(
            path: '/contact',
            pageBuilder: (context, state) =>
                buildPortfolioPage(state: state, child: const ContactPage()),
          ),
          GoRoute(
            path: '/game',
            pageBuilder: (context, state) =>
                buildPortfolioPage(state: state, child: const GamePage()),
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
