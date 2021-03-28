import 'package:hive/hive.dart';
import 'package:sidekick/models/app_settings.model.dart';

const settingsBoxName = 'app_settings';
const settingsKey = 'settings_key';

// ignore: avoid_classes_with_only_static_members
class AppSettingsService {
  static Box<AppSettings> box;
  static Future<void> init() async {
    box = await Hive.openBox<AppSettings>(settingsBoxName);
  }

  // static Future<void> save(AppSettings settings) async {
  //   await box.put(settingsKey, settings);
  // }

  static Future<void> read() async {
    return await box.get(settingsKey);
  }

  static Future<void> reset() async {
    /// Will set all AppSettings to default
    return await box.put(settingsKey, AppSettings());
  }
}
