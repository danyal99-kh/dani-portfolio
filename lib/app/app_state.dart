import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Holds user preferences (locale and theme) and persists them in
/// `localStorage` on the web via `shared_preferences`.
class AppState extends ChangeNotifier {
  factory AppState({
    Locale locale = const Locale('fa'),
    ThemeMode themeMode = ThemeMode.system,
    SharedPreferences? preferences,
  }) {
    return AppState._(locale, themeMode, preferences);
  }

  AppState._(this._locale, this._themeMode, this._preferences);

  static const _localeKey = 'portfolio.locale';
  static const _themeKey = 'portfolio.theme';

  final SharedPreferences? _preferences;
  Locale _locale;
  ThemeMode _themeMode;

  Locale get locale => _locale;
  ThemeMode get themeMode => _themeMode;
  bool get isFa => _locale.languageCode == 'fa';

  static Future<AppState> load() async {
    SharedPreferences? preferences;
    try {
      preferences = await SharedPreferences.getInstance();
    } catch (_) {
      preferences = null;
    }

    final savedLocale = preferences?.getString(_localeKey);
    final savedTheme = preferences?.getString(_themeKey);

    final locale = savedLocale == 'en' || savedLocale == 'fa'
        ? Locale(savedLocale!)
        : const Locale('fa');

    final themeMode = switch (savedTheme) {
      'light' => ThemeMode.light,
      'dark' => ThemeMode.dark,
      'system' => ThemeMode.system,
      _ => ThemeMode.system,
    };

    return AppState(
      locale: locale,
      themeMode: themeMode,
      preferences: preferences,
    );
  }

  void setLocale(Locale locale) {
    if (_locale == locale) return;
    _locale = locale;
    _preferences?.setString(_localeKey, locale.languageCode);
    notifyListeners();
  }

  void toggleLocale() {
    setLocale(
      _locale.languageCode == 'fa' ? const Locale('en') : const Locale('fa'),
    );
  }

  void setThemeMode(ThemeMode mode) {
    if (_themeMode == mode) return;
    _themeMode = mode;
    _preferences?.setString(_themeKey, mode.name);
    notifyListeners();
  }

  void toggleTheme(Brightness currentBrightness) {
    setThemeMode(
      currentBrightness == Brightness.dark ? ThemeMode.light : ThemeMode.dark,
    );
  }
}

class AppStateScope extends InheritedNotifier<AppState> {
  const AppStateScope({
    super.key,
    required AppState state,
    required super.child,
  }) : super(notifier: state);

  static AppState of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<AppStateScope>();
    assert(scope != null, 'AppStateScope is missing from the widget tree');
    return scope!.notifier!;
  }
}
