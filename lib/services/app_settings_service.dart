import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:sidekick/models/app_settings.model.dart';

const settingsBoxName = 'app_settings';

// ignore: avoid_classes_with_only_static_members
class AppSettingsService {
  static Box<AppSettings> _box;
  // ignore: prefer_final_fields

  static Future<void> init() async {
    _box = await Hive.openBox<AppSettings>(settingsBoxName);
  }

  static Future<void> save(AppSettings settings) async {
    await _box.put(AppSettings.key, settings);
  }

  static Future<AppSettings> read() async {
    final settings = await _box.get(AppSettings.key);
    if (settings == null) {
      return AppSettings();
    }
    return settings;
  }

  static Future<void> listen() {}

  static Future<AppSettings> reset() async {
    /// Will set all AppSettings to default
    final emptySettings = AppSettings();
    await _box.put(AppSettings.key, emptySettings);
    return emptySettings;
  }
}
