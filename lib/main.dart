import 'dart:io';

import 'package:sidekick/app_shell.dart';

import 'package:sidekick/theme.dart';
import 'package:sidekick/utils/manage_updates.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oktoast/oktoast.dart';
import 'package:window_size/window_size.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
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
    checkForUpdates();
    return OKToast(
      child: MaterialApp(
        title: 'Sidekick',
        debugShowCheckedModeBanner: false,
        theme: darkTheme(),
        home: const AppShell(),
      ),
    );
  }
}
