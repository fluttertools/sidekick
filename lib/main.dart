import 'dart:io';

import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:sidekick/app_shell.dart';

import 'package:sidekick/theme.dart';
import 'package:sidekick/utils/get_theme_mode.dart';
import 'package:sidekick/utils/init_hive.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oktoast/oktoast.dart';
import 'package:window_size/window_size.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initHive().onError((error, stackTrace) => exit(0));
  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    setWindowTitle('Sidekick');
    setWindowMinSize(const Size(800, 500));
    setWindowMaxSize(Size.infinite);
  }
  runApp(ProviderScope(child: FvmApp()));
}

class FvmApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return OKToast(
        child: ValueListenableBuilder(
      valueListenable: Hive.box('theme').listenable(),
      builder: (context, value, child) {
        return MaterialApp(
          title: 'Sidekick',
          debugShowCheckedModeBanner: false,
          theme: lightTheme(),
          darkTheme: darkTheme(),
          themeMode: getThemeMode(
            value.get("brightness", defaultValue: "system"),
          ),
          home: const AppShell(),
        );
      },
    ));
  }
}
