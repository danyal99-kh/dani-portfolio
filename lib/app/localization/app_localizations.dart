import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'translations.dart';

class AppLocalizations {
  const AppLocalizations(this.locale);

  final Locale locale;

  static const supportedLocales = [Locale('fa'), Locale('en')];

  bool get isFa => locale.languageCode == 'fa';

  String get languageCode => locale.languageCode;

  TextDirection get direction => isFa ? TextDirection.rtl : TextDirection.ltr;

  Map<String, String> get _values =>
      kTranslations[locale.languageCode] ?? kTranslations['en']!;

  String t(String key) => _values[key] ?? kTranslations['en']![key] ?? key;

  String tCount(String key, int count) =>
      t(key).replaceAll('{count}', count.toString());

  static AppLocalizations of(BuildContext context) {
    final value = Localizations.of<AppLocalizations>(context, AppLocalizations);
    assert(
      value != null,
      'AppLocalizations was not provided in the widget tree',
    );
    return value!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => AppLocalizations.supportedLocales.any(
    (supported) => supported.languageCode == locale.languageCode,
  );

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture(AppLocalizations(locale));
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

extension AppLocalizationsContext on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);
}
