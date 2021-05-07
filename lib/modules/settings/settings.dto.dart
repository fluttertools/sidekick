import 'dart:convert';

import 'package:hive/hive.dart';
import 'package:list_ext/list_ext.dart';

import 'settings.utils.dart';

class SidekickSettings {
  static const key = 'settings_key';
  List<String> flutterProjectsDir;
  bool advancedMode;
  bool onlyProjectsWithFvm;
  List<String> projectPaths;
  String themeMode;

  SidekickSettings({
    this.flutterProjectsDir = const [],
    this.advancedMode = false,
    this.onlyProjectsWithFvm = false,
    this.projectPaths = const [],
    this.themeMode = SettingsThemeMode.system,
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

class FlutterSettings {
  bool analytics;
  bool macos;
  bool linux;
  bool windows;
  bool web;
  FlutterSettings({
    this.analytics = true,
    this.linux = false,
    this.macos = false,
    this.windows = false,
    this.web = false,
  });

  factory FlutterSettings.fromMap(Map<String, bool> map) {
    return FlutterSettings(
      analytics: map['analytics'],
      macos: map['macos'],
      windows: map['windows'],
      linux: map['linux'],
      web: map['web'],
    );
  }
  Map<String, bool> toMap() {
    return {
      "analytics": analytics,
      "macos": macos,
      "linux": linux,
      "windows": windows,
      "web": web,
    };
  }
}
