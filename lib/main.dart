import 'dart:io';

import 'package:catcher/catcher.dart';
import 'package:catcher/model/catcher_options.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:oktoast/oktoast.dart';
import 'package:sentry/sentry.dart';
import 'package:sidekick/app_shell.dart';
import 'package:sidekick/constants.dart';
import 'package:sidekick/dto/settings.dto.dart';
import 'package:sidekick/services/settings_service.dart';
import 'package:sidekick/theme.dart';
import 'package:sidekick/utils/get_theme_mode.dart';
import 'package:window_size/window_size.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Hive.registerAdapter(SidekickSettingsAdapter());
  await Hive.initFlutter();

  await SettingsService.init();
  final debugOptions = CatcherOptions(DialogReportMode(), [ConsoleHandler()]);
  final releaseOptions = CatcherOptions(
    PageReportMode(),
    [
      SentryHandler(
        SentryClient(
          SentryOptions(
            dsn:
                "https://f77c25fdfecb4e45a801fe5575ba1461@o578792.ingest.sentry.io/5735216",
          ),
        ),
      )
    ],
  );
// Init sentry

  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    setWindowTitle(kAppTitle);
    setWindowMinSize(const Size(800, 500));
    setWindowMaxSize(Size.infinite);
  }
  Catcher(
    runAppFunction: () {
      runApp(ProviderScope(child: FvmApp()));
    },
    debugConfig: debugOptions,
    releaseConfig: releaseOptions,
  );
}

class FvmApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: SettingsService.box.listenable(),
      builder: (context, box, widget) {
        final settings = SettingsService.read();

        return OKToast(
          child: MaterialApp(
            navigatorKey: Catcher.navigatorKey,
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
