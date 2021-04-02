import 'dart:convert';

import 'package:hive/hive.dart';
import 'package:list_ext/list_ext.dart';
import 'package:sidekick/utils/get_theme_mode.dart';

class SidekickSettings {
  static const key = 'settings_key';
  List<String> flutterProjectsDir;
  bool advancedMode;
  bool onlyProjectsWithFvm;
  List<String> projectPaths;
  String themeMode;
  bool flutterAnalytics;

  SidekickSettings({
    this.flutterProjectsDir = const [],
    this.advancedMode = false,
    this.onlyProjectsWithFvm = false,
    this.projectPaths = const [],
    this.themeMode = SettingsThemeMode.system,
    this.flutterAnalytics = false,
  });

  factory SidekickSettings.fromJson(String str) =>
      SidekickSettings.fromMap(json.decode(str));

  factory SidekickSettings.fromMap(Map<String, dynamic> json) {
    return SidekickSettings(
      flutterProjectsDir:
          (json['flutterProjectsDir'] as List<dynamic>).cast<String>(),
      projectPaths: (json['projectPaths'] as List<dynamic>).cast<String>(),
      advancedMode: json['advancedMode'] as bool ?? false,
      onlyProjectsWithFvm: json['onlyProjectsWithFvm'] as bool ?? false,
      themeMode: json['themeMode'] as String ?? SettingsThemeMode.system,
    );
  }

  String get firstProjectDir {
    if (flutterProjectsDir.isNotNullOrEmpty) {
      return flutterProjectsDir.first;
    } else {
      return null;
    }
  }

  set firstProjectDir(String path) {
    if (flutterProjectsDir.isNotNullOrEmpty) {
      flutterProjectsDir.first = path;
    } else {
      flutterProjectsDir = [path];
    }
  }

  /// Converts Master Secret to Json
  String toJson() => json.encode(toMap());

  Map<String, dynamic> toMap() {
    return {
      'flutterProjectsDir': flutterProjectsDir,
      'projectPaths': projectPaths,
      'advancedMode': advancedMode,
      'onlyProjectsWithFvm': onlyProjectsWithFvm,
      'themeMode': themeMode,
    };
  }
}

class SidekickSettingsAdapter extends TypeAdapter<SidekickSettings> {
  @override
  int get typeId => 1; // this is unique, no other Adapter can have the same id.

  @override
  SidekickSettings read(BinaryReader reader) {
    // FIXME: Check why subtype does not match
    final value = Map<String, dynamic>.from(reader.readMap());
    return SidekickSettings.fromMap(value);
  }

  @override
  void write(BinaryWriter writer, SidekickSettings obj) {
    writer.writeMap(obj.toMap());
  }
}
