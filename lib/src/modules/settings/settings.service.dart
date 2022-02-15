import 'package:hive/hive.dart';

import 'settings.dto.dart';

/// Settings service
class SettingsService {
  const SettingsService._();

  /// Storage key
  static const key = 'settings_box';

  /// Storage box
  static Box<SidekickSettings>? box;

  /// Initialize storage
  static Future<void> init() async {
    box = await Hive.openBox<SidekickSettings>(key);
  }

  /// Save sidekick settings
  static Future<void> save(SidekickSettings settings) async {
    await box?.put(SidekickSettings.key, settings);
  }

  /// Read sidekick settings
  static SidekickSettings read() {
    // Make sure its initialized
    final settings = box?.get(SidekickSettings.key);
    if (settings != null) {
      return settings;
    } else {
      return SidekickSettings();
    }
  }

  /// Reset settings
  static Future<SidekickSettings> reset() async {
    /// Will set all AppSettings to default
    final emptySettings = SidekickSettings();
    await box?.put(SidekickSettings.key, emptySettings);
    return emptySettings;
  }
}
