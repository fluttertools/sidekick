import 'package:hive/hive.dart';
import 'package:sidekick/models/app_settings.model.dart';

const settingsBoxName = 'app_settings';

// ignore: avoid_classes_with_only_static_members
class AppSettingsService {
  static Box<AppSettings> box;
  static Future<void> init() async {
    box = await Hive.openBox<AppSettings>(settingsBoxName);
  }

  static Future<void> save(AppSettings settings) async {
    await box.put(AppSettings.key, settings);
  }

  static Future<AppSettings> read() async {
    return await box.get(AppSettings.key);
  }

  static Future<AppSettings> reset() async {
    /// Will set all AppSettings to default
    final emptySettings = AppSettings();
    await box.put(AppSettings.key, emptySettings);
    return emptySettings;
  }
}
