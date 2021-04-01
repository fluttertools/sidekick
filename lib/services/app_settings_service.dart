import 'package:hive/hive.dart';
import 'package:sidekick/models/app_settings.model.dart';

const settingsBoxName = 'box_app_settings';

// ignore: avoid_classes_with_only_static_members
class AppSettingsService {
  static Box<AppSettings> _box;
  // ignore: prefer_final_fields
  static bool _initialized = false;
  static Future<void> init() async {
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
    final settings = _box.get(AppSettings.key);
    if (settings == null) {
      return AppSettings();
    } else {
      return settings;
    }
  }

  /// Only use this is you know that the box has already been opened
  static AppSettings readIsOpen() {
    final settings = _box.get(AppSettings.key);
    if (settings == null) {
      return AppSettings();
    } else {
      return settings;
    }
  }

  static Future<AppSettings> reset() async {
    /// Will set all AppSettings to default
    final emptySettings = AppSettings();
    await _box.put(AppSettings.key, emptySettings);
    return emptySettings;
  }
}
