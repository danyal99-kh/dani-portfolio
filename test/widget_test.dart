import 'package:daniweb/app/app_state.dart';
import 'package:daniweb/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('dashboard renders profile content', (tester) async {
    tester.view.physicalSize = const Size(1440, 1000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(PortfolioApp(state: AppState()));
    await tester.pumpAndSettle();

    expect(find.text('دانیال خدایی'), findsWidgets);
  });

  testWidgets('projects route renders project cards', (tester) async {
    tester.view.physicalSize = const Size(1440, 1000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      PortfolioApp(state: AppState(), initialLocation: '/projects'),
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
    await tester.pumpWidget(PortfolioApp(state: state));
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

  _registerRouteSmokeTests();
  _registerMobileSmokeTests();
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
        ),
      );
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
    });
  }
}
