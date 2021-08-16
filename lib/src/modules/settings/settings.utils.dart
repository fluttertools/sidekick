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

class IDE {
  final String name;
  final void Function(BuildContext context, String projectPath) launch;
  final Widget icon;

  const IDE(this.name, this.icon, this.launch);
}

const supportedIDEs = [
  IDE('VSCode', Icon(MdiIcons.microsoftVisualStudioCode), openVsCode),
  IDE('XCode', Icon(MdiIcons.appleSafari), openXcode),
];
