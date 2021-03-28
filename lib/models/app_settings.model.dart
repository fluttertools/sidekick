import 'dart:convert';

import 'package:hive/hive.dart';
import 'package:list_ext/list_ext.dart';

class AppSettings {
  static const key = 'app_settings';
  List<String> flutterProjectsDir;
  bool advancedMode;
  bool onlyProjectsWithFvm;
  List<String> projectPaths;

  AppSettings({
    this.flutterProjectsDir = const [],
    this.advancedMode = false,
    this.onlyProjectsWithFvm = false,
    this.projectPaths = const [],
  });

  factory AppSettings.fromJson(String str) =>
      AppSettings.fromMap(json.decode(str));

  factory AppSettings.fromMap(Map<String, dynamic> json) {
    return AppSettings(
      flutterProjectsDir:
          (json['flutterProjectsDir'] as List<dynamic>).cast<String>(),
      projectPaths: (json['projectPaths'] as List<dynamic>).cast<String>(),
      advancedMode: json['advancedMode'] as bool ?? false,
      onlyProjectsWithFvm: json['onlyProjectsWithFvm'] as bool ?? false,
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
    };
  }
}

class AppSettingsAdapter extends TypeAdapter<AppSettings> {
  @override
  int get typeId => 0; // this is unique, no other Adapter can have the same id.

  @override
  AppSettings read(BinaryReader reader) {
    // FIXME: Check why subtype does not match
    final value = Map<String, dynamic>.from(reader.readMap());
    return AppSettings.fromMap(value);
  }

  @override
  void write(BinaryWriter writer, AppSettings obj) {
    writer.writeMap(obj.toMap());
  }
}
