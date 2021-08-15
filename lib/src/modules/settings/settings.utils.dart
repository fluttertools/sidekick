import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

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
  final String urlProtocol;
  final String command;
  final IconData icon;

  const IDE(this.name, this.icon, {this.command, this.urlProtocol});

  factory IDE.fromJson(String str) => IDE.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory IDE.fromMap(Map<String, dynamic> json) => IDE(
        json['name'],
        json['icon'],
        command: json['command'],
        urlProtocol: json['urlProtocol'],
      );

  Map<String, dynamic> toMap() => {
        'name': name,
        'icon': icon,
        'command': command,
        'urlProtocol': urlProtocol,
      };
}

const supportedIDEs = [
  IDE('VSCode', MdiIcons.microsoftVisualStudioCode, urlProtocol: 'vscode')
];
