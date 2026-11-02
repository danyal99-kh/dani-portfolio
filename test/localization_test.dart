import 'package:daniweb/app/localization/app_localizations.dart';
import 'package:daniweb/app/localization/translations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Persian and English translation keys match', () {
    final fa = kTranslations['fa']!;
    final en = kTranslations['en']!;

    expect(fa.keys.toSet(), en.keys.toSet());
  });

  test('translation values are not empty', () {
    for (final locale in kTranslations.values) {
      for (final entry in locale.entries) {
        expect(entry.value.trim(), isNotEmpty, reason: entry.key);
      }
    }
  });

  test('localization direction follows the locale', () {
    expect(const AppLocalizations(Locale('fa')).direction, TextDirection.rtl);
    expect(const AppLocalizations(Locale('en')).direction, TextDirection.ltr);
  });
}
