import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:sidekick/models/app_settings.model.dart';

const settingsBoxName = 'app_settings';

// ignore: avoid_classes_with_only_static_members
class AppSettingsService {
  static Box<AppSettings> _box;
  // ignore: prefer_final_fields
  static bool _initialized = false;
  static Future<void> init() async {
    await Hive.initFlutter();
    _box = await Hive.openBox<AppSettings>(settingsBoxName);
    _initialized = true;
  }

  static Future<void> save(AppSettings settings) async {
    await _box.put(AppSettings.key, settings);
  }

  static Future<AppSettings> read() async {
    // Make sure its initialized

    if (!_initialized) {
      await init();
    }
    return await _box.get(AppSettings.key);
  }

  static Future<AppSettings> reset() async {
    /// Will set all AppSettings to default
    final emptySettings = AppSettings();
    await _box.put(AppSettings.key, emptySettings);
    return emptySettings;
  }
}
