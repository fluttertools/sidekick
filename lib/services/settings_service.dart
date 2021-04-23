import 'package:hive/hive.dart';
import 'package:sidekick/dto/settings.dto.dart';

// ignore: avoid_classes_with_only_static_members
class SettingsService {
  static const key = 'settings_box';
  static Box<SidekickSettings> box;

  static Future<void> init() async {
    box = await Hive.openBox<SidekickSettings>(key);
  }

  static Future<void> save(SidekickSettings settings) async {
    await box.put(SidekickSettings.key, settings);
  }

  static SidekickSettings read() {
    // Make sure its initialized
    final settings = box.get(SidekickSettings.key);
    if (settings != null) {
      return settings;
    } else {
      return SidekickSettings();
    }
  }

  static Future<SidekickSettings> reset() async {
    /// Will set all AppSettings to default
    final emptySettings = SidekickSettings();
    await box.put(SidekickSettings.key, emptySettings);
    return emptySettings;
  }
}
