import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:i18next/i18next.dart';
import 'package:oktoast/oktoast.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sidekick/i18n/language_manager.dart';
import 'package:sidekick/src/modules/common/utils/migrateFiles.dart';
import 'package:window_size/window_size.dart';

import 'src/modules/common/app_shell.dart';
import 'src/modules/common/constants.dart';
import 'src/modules/projects/project.dto.dart';
import 'src/modules/projects/projects.service.dart';
import 'src/modules/settings/settings.dto.dart';
import 'src/modules/settings/settings.service.dart';
import 'src/modules/settings/settings.utils.dart';
import 'src/screens/error_db_screen.dart';
import 'src/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Hive.registerAdapter(SidekickSettingsAdapter());
  Hive.registerAdapter(ProjectPathAdapter());
  final hiveDir = await getApplicationSupportDirectory();

  // This should only be necessary on the first run after 0.1.1, as DB location has changed.
  await checkMigration(hiveDir);

  await Hive.initFlutter(hiveDir.absolute.path);

  try {
    await SettingsService.init();
    await ProjectsService.init();
  } on FileSystemException {
    print('There was an issue opening the DB');
  }

  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    setWindowTitle(kAppTitle);
    setWindowMinSize(const Size(800, 500));
    setWindowMaxSize(Size.infinite);
  }

  runApp(ProviderScope(child: FvmApp()));
}

/// Fvm App
class FvmApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    if (SettingsService.box == null) {
      return const ErrorDBScreen();
    }

    return ValueListenableBuilder<Box<SidekickSettings>>(
      valueListenable: SettingsService.box.listenable(),
      builder: (context, box, widget) {
        final settings = SettingsService.read();

        return OKToast(
          child: MaterialApp(
            localizationsDelegates: [
              settings.localizationsDelegate,
              ...GlobalMaterialLocalizations.delegates,
              GlobalWidgetsLocalizations.delegate,
              ...GlobalCupertinoLocalizations.delegates,
            ],
            locale: settings.locale ??
                I18Next.of(context)?.locale ??
                languageManager.supportedLocales.first,
            supportedLocales: languageManager.supportedLocales,
            localeResolutionCallback: (
              Locale locale,
              Iterable<Locale> supportedLocales,
            ) {
              if (locale == null) {
                if (settings.locale != null) {
                  return settings.locale;
                }
                return supportedLocales.first;
              }
              for (final supportedLocale in supportedLocales) {
                if (supportedLocale.languageCode == locale.languageCode ||
                    supportedLocale.countryCode == locale.countryCode) {
                  if (settings.locale != null) {
                    return settings.locale;
                  }
                  return supportedLocale;
                }
              }
              if (settings.locale != null) {
                return settings.locale;
              }
              return supportedLocales.first;
            },
            title: kAppTitle,
            debugShowCheckedModeBanner: false,
            theme: lightTheme,
            darkTheme: darkTheme,
            themeMode: getThemeMode(settings.themeMode),
            home: const AppShell(),
          ),
        );
      },
    );
  }
}
