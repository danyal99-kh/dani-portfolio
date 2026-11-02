import 'package:daniweb/app/app_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('locale toggles between Persian and English', () {
    final state = AppState();
    expect(state.locale.languageCode, 'fa');

    state.toggleLocale();
    expect(state.locale.languageCode, 'en');

    state.toggleLocale();
    expect(state.locale.languageCode, 'fa');
  });

  test('theme toggles based on current brightness', () {
    final state = AppState();
    expect(state.themeMode, ThemeMode.system);

    state.toggleTheme(Brightness.light);
    expect(state.themeMode, ThemeMode.dark);

    state.toggleTheme(Brightness.dark);
    expect(state.themeMode, ThemeMode.light);
  });
}
