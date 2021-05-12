import 'dart:convert';

import 'package:fvm/fvm.dart';
import 'package:hive/hive.dart';

import 'settings.utils.dart';

/// All Settings
class AllSettings {
  SidekickSettings sidekick;
  FvmSettings fvm;
  FlutterSettings flutter;

  AllSettings({
    this.sidekick,
    this.fvm,
    this.flutter,
  }) {
    if (fvm == null) {
      fvm = FvmSettings();
    }
    if (sidekick == null) {
      sidekick = SidekickSettings();
    }

    if (flutter == null) {
      flutter = FlutterSettings();
    }
  }

  AllSettings copy() => AllSettings(
        sidekick: SidekickSettings.fromJson(sidekick.toJson()),
        fvm: FvmSettings.fromJson(fvm.toJson()),
        flutter: FlutterSettings.fromMap(flutter.toMap()),
      );
}

/// Sidekick settings
class SidekickSettings {
  /// Constructor
  SidekickSettings({
    this.onlyProjectsWithFvm = false,
    this.projectPaths = const [],
    this.themeMode = SettingsThemeMode.system,
  });

  /// Storage key
  static const key = 'settings_key';

  bool onlyProjectsWithFvm;
  List<String> projectPaths;
  String themeMode;

  factory SidekickSettings.fromJson(String str) =>
      SidekickSettings.fromMap(json.decode(str));

  factory SidekickSettings.fromMap(Map<String, dynamic> json) {
    return SidekickSettings(
      projectPaths: (json['projectPaths'] as List<dynamic>).cast<String>(),
      onlyProjectsWithFvm: json['onlyProjectsWithFvm'] as bool ?? false,
      themeMode: json['themeMode'] as String ?? SettingsThemeMode.system,
    );
  }

  /// Converts Master Secret to Json
  String toJson() => json.encode(toMap());

  Map<String, dynamic> toMap() {
    return {
      'projectPaths': projectPaths,
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

/// Flutter settings
class FlutterSettings {
  /// Constructor
  FlutterSettings({
    this.analytics = true,
    this.linux = false,
    this.macos = false,
    this.windows = false,
    this.web = false,
  });

  /// Analytics enabled
  bool analytics;

  /// MacOS enabled
  bool macos;

  /// Linux enabled
  bool linux;

  /// Windows enabled
  bool windows;

  /// Web enabled
  bool web;

  /// Flutter settings from map
  factory FlutterSettings.fromMap(Map<String, bool> map) {
    return FlutterSettings(
      analytics: map['analytics'],
      macos: map['macos'],
      windows: map['windows'],
      linux: map['linux'],
      web: map['web'],
    );
  }

  /// Flutter settings to map
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
