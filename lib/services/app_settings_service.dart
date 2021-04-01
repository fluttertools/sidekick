import 'package:hive/hive.dart';
import 'package:sidekick/models/app_settings.model.dart';

const settingsBoxName = 'settings';

// ignore: avoid_classes_with_only_static_members
class AppSettingsService {
  static Box<AppSettings> _box;

  static Future<void> init() async {
    _box = await Hive.openBox<AppSettings>(settingsBoxName);
  }

  static Future<void> save(AppSettings settings) async {
    await _box.put(AppSettings.key, settings);
  }

  static AppSettings read() {
    // Make sure its initialized
    final settings = _box.get(AppSettings.key);
    if (settings != null) {
      return settings;
    } else {
      return AppSettings();
    }
  }

  static Future<AppSettings> reset() async {
    /// Will set all AppSettings to default
    final emptySettings = AppSettings();
    await _box.put(AppSettings.key, emptySettings);
    return emptySettings;
  }
}
