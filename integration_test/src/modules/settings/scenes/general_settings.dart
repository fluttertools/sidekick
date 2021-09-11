import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sidekick/i18n/language_manager.dart';
import 'package:sidekick/src/modules/settings/settings.service.dart';

class GeneralSettingsTest {
  static final settings = SettingsService.read();

  static Future changingThemeWorks(WidgetTester tester) async {
    expect(find.byKey(Key('db_theme')), findsOneWidget);

    for (var i = 0; i < 3; i++) {
      await tester.tap(find.byKey(Key('db_theme')));
      await tester.pumpAndSettle();

      var system = find.byKey(Key('dmi_system'));
      var light = find.byKey(Key('dmi_light'));
      var dark = find.byKey(Key('dmi_dark'));

      expect(system, findsWidgets);
      expect(light, findsWidgets);
      expect(dark, findsWidgets);

      if (settings.themeMode == 'system') {
        await tester.tap(find.byKey(Key('dmi_light')).last,
            warnIfMissed: false);
        await Future.delayed(const Duration(seconds: 1));
        await tester.pumpAndSettle();

        expect(find.byKey(Key('dmi_light')), findsWidgets);
      } else if (settings.themeMode == 'light') {
        await tester.tap(find.byKey(Key('dmi_dark')).last, warnIfMissed: false);
        await Future.delayed(const Duration(seconds: 1));
        await tester.pumpAndSettle();

        expect(find.byKey(Key('dmi_dark')), findsWidgets);
      } else if (settings.themeMode == 'dark') {
        await tester.tap(find.byKey(Key('dmi_system')).last,
            warnIfMissed: false);
        await Future.delayed(const Duration(seconds: 1));
        await tester.pumpAndSettle();

        expect(find.byKey(Key('dmi_system')), findsWidgets);
      }
    }
  }

  static Future changingLocaleWorks(WidgetTester tester) async {
    expect(find.byKey(Key('db_locale')), findsOneWidget);

    for (var locale in languageManager.supportedLocales) {
      await tester.tap(find.byKey(Key('db_locale')));
      await tester.pumpAndSettle();

      var localeButton = find.byKey(Key('dmi_${locale.toLanguageTag()}'));
      expect(localeButton, findsWidgets);

      await tester.tap(localeButton.last, warnIfMissed: false);
      await Future.delayed(const Duration(seconds: 1));
      await tester.pumpAndSettle();

      expect(localeButton.last, findsWidgets);
    }
  }

  static Future resetSettingsWorks(WidgetTester tester) async {
    expect(find.byKey(Key('ob_reset')), findsOneWidget);

    await tester.tap(find.byKey(Key('ob_reset')));
    await Future.delayed(const Duration(seconds: 1));
    await tester.pumpAndSettle();

    expect(find.byKey(Key('tb_confirm')), findsOneWidget);

    await tester.tap(find.byKey(Key('tb_confirm')));
    await Future.delayed(const Duration(seconds: 2));
    await tester.pumpAndSettle();

    /// Detect reset if 'Reset' text for en-GB Locale exists
    expect(find.text('Reset'), findsOneWidget);
  }
}
