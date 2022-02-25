// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:sidekick/src/modules/common/utils/open_link.dart';

class SettingsThemeMode {
  static const light = 'light';
  static const dark = 'dark';
  static const system = 'system';
  const SettingsThemeMode();
}

ThemeMode getThemeMode(String themeMode) {
  if (themeMode == SettingsThemeMode.light) {
    return ThemeMode.light;
  } else if (themeMode == SettingsThemeMode.dark) {
    return ThemeMode.dark;
  } else {
    return ThemeMode.system;
  }
}

typedef LaunchFunction = Future<void> Function(
  BuildContext context,
  String projectPath, {
  String? customLocation,
});

enum SupportedIDE {
  VSCode,
  XCode,
  Custom,
}

class IDE {
  final SupportedIDE name;
  final LaunchFunction launch;
  final Widget icon;

  const IDE(
    this.name,
    this.icon,
    this.launch,
  );
}

const supportedIDEs = [
  IDE(
    SupportedIDE.VSCode,
    Icon(MdiIcons.microsoftVisualStudioCode),
    openVsCode,
  ),
  IDE(SupportedIDE.XCode, Icon(MdiIcons.appleSafari), openXcode),
  IDE(SupportedIDE.Custom, Icon(Icons.code_rounded), openCustom),
];
