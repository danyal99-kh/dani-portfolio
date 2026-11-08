import 'package:daniweb/app/app_state.dart';
import 'package:daniweb/core/widgets/terminal_welcome_screen.dart';
import 'package:daniweb/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('dashboard renders profile content', (tester) async {
    tester.view.physicalSize = const Size(1440, 1000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      PortfolioApp(state: AppState(), showWelcome: false),
    );
    await tester.pumpAndSettle();

    expect(find.text('دانیال خدایی'), findsWidgets);
  });

  testWidgets('projects route renders project cards', (tester) async {
    tester.view.physicalSize = const Size(1440, 1000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      PortfolioApp(
        state: AppState(),
        initialLocation: '/projects',
        showWelcome: false,
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Lawin'), findsWidgets);
    expect(find.text('Azmode'), findsWidgets);
  });

  testWidgets('language and theme toggles update the app state', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1440, 1000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final state = AppState();
    await tester.pumpWidget(PortfolioApp(state: state, showWelcome: false));
    await tester.pumpAndSettle();

    expect(state.locale.languageCode, 'fa');

    await tester.tap(find.byKey(const Key('language-toggle')));
    await tester.pumpAndSettle();

    expect(state.locale.languageCode, 'en');
    expect(find.text('Projects'), findsWidgets);

    state.setThemeMode(ThemeMode.dark);
    await tester.pumpAndSettle();

    expect(state.themeMode, ThemeMode.dark);
  });

  testWidgets('navigation transitions between routes', (tester) async {
    tester.view.physicalSize = const Size(1440, 1000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      PortfolioApp(state: AppState(), showWelcome: false),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('پروژه‌ها').first, warnIfMissed: false);
    await tester.pumpAndSettle();
    expect(find.text('Lawin'), findsWidgets);

    await tester.tap(find.text('داشبورد').first, warnIfMissed: false);
    await tester.pumpAndSettle();
    expect(find.text('دانیال خدایی'), findsWidgets);
    expect(tester.takeException(), isNull);
  });

  testWidgets('welcome terminal reveals success then exits', (tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(PortfolioApp(state: AppState()));
    await tester.pump();
    expect(find.byType(TerminalWelcomeScreen), findsOneWidget);

    await tester.pump(const Duration(milliseconds: 900));
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('نمونه‌کار آماده است.'), findsOneWidget);
    expect(find.text('به نمونه‌کار من خوش آمدید'), findsOneWidget);

    await tester.pump(const Duration(milliseconds: 700));
    await tester.pump(const Duration(milliseconds: 600));

    expect(find.byType(TerminalWelcomeScreen), findsNothing);
  });

  testWidgets('welcome terminal honors reduced motion', (tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    tester.platformDispatcher.accessibilityFeaturesTestValue =
        const FakeAccessibilityFeatures(disableAnimations: true);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.platformDispatcher.clearAccessibilityFeaturesTestValue);

    await tester.pumpWidget(PortfolioApp(state: AppState()));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 160));
    await tester.pump(const Duration(milliseconds: 680));
    await tester.pump(const Duration(milliseconds: 240));

    expect(find.byType(TerminalWelcomeScreen), findsNothing);
  });

  _registerRouteSmokeTests();
  _registerMobileSmokeTests();
  _registerCardViewportTests();
  _registerWelcomeViewportTests();
}

void _registerRouteSmokeTests() {
  const routes = [
    '/about',
    '/projects',
    '/projects/lawin',
    '/skills',
    '/resume',
    '/contact',
    '/game',
    '/missing-route',
  ];

  for (final route in routes) {
    testWidgets('route $route renders without exceptions', (tester) async {
      tester.view.physicalSize = const Size(1440, 1000);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        PortfolioApp(
          key: ValueKey(route),
          state: AppState(),
          initialLocation: route,
          showWelcome: false,
        ),
      );
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
    });
  }
}

void _registerMobileSmokeTests() {
  const routes = [
    '/',
    '/about',
    '/projects',
    '/projects/lawin',
    '/skills',
    '/resume',
    '/contact',
    '/game',
  ];

  for (final route in routes) {
    testWidgets('mobile route $route renders without overflow', (tester) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        PortfolioApp(
          key: ValueKey('mobile-$route'),
          state: AppState(),
          initialLocation: route,
          showWelcome: false,
        ),
      );
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
    });
  }
}

void _registerCardViewportTests() {
  const widths = [360.0, 390.0, 430.0];
  const locales = ['fa', 'en'];
  const themes = [ThemeMode.light, ThemeMode.dark];

  for (final width in widths) {
    for (final language in locales) {
      for (final themeMode in themes) {
        testWidgets(
          'project cards fit ${width.toInt()}px ($language, ${themeMode.name})',
          (tester) async {
            tester.view.physicalSize = Size(width, 844);
            tester.view.devicePixelRatio = 1;
            addTearDown(tester.view.resetPhysicalSize);
            addTearDown(tester.view.resetDevicePixelRatio);

            final state = AppState(
              locale: Locale(language),
              themeMode: themeMode,
            );
            await tester.pumpWidget(
              PortfolioApp(
                key: ValueKey('cards-$width-$language-${themeMode.name}'),
                state: state,
                initialLocation: '/projects',
                showWelcome: false,
              ),
            );
            await tester.pumpAndSettle();

            expect(tester.takeException(), isNull);
            expect(
              find.text(language == 'fa' ? 'پروژه 01' : 'Project 01'),
              findsOneWidget,
            );
          },
        );
      }
    }
  }
}

void _registerWelcomeViewportTests() {
  const widths = [360.0, 390.0, 430.0];
  const locales = ['fa', 'en'];
  const themes = [ThemeMode.light, ThemeMode.dark];

  for (final width in widths) {
    for (final language in locales) {
      for (final themeMode in themes) {
        testWidgets(
          'welcome terminal fits ${width.toInt()}px ($language, ${themeMode.name})',
          (tester) async {
            tester.view.physicalSize = Size(width, 844);
            tester.view.devicePixelRatio = 1;
            addTearDown(tester.view.resetPhysicalSize);
            addTearDown(tester.view.resetDevicePixelRatio);

            final state = AppState(
              locale: Locale(language),
              themeMode: themeMode,
            );
            await tester.pumpWidget(
              PortfolioApp(
                key: ValueKey('welcome-$width-$language-${themeMode.name}'),
                state: state,
              ),
            );
            await tester.pump();
            await tester.pump(const Duration(milliseconds: 750));

            expect(tester.takeException(), isNull);
            expect(find.byType(TerminalWelcomeScreen), findsOneWidget);
            expect(
              find.descendant(
                of: find.byType(TerminalWelcomeScreen),
                matching: find.text(
                  language == 'fa' ? 'دانیال خدایی' : 'DANYAL KHODAI',
                ),
              ),
              findsOneWidget,
            );
          },
        );
      }
    }
  }
}
