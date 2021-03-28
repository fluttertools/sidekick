import 'package:fvm/fvm.dart';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sidekick/models/app_settings.model.dart';
import 'package:sidekick/services/app_settings_service.dart';
import 'package:state_notifier/state_notifier.dart';

class AllSettings {
  final AppSettings appSettings;
  final FvmSettings fvmSettings;
  AllSettings({this.appSettings, this.fvmSettings});
}

final settingsRepoProvider = Provider((_) => AllSettings());

final settingsProvider = StateNotifierProvider<SettingsProvider>((ref) {
  return SettingsProvider(initialState: AllSettings());
});

class SettingsProvider extends StateNotifier<AllSettings> {
  SettingsProvider({AllSettings initialState}) : super(initialState) {
    // Set initial settings from local storage
    _load();
  }

  Future<void> _load() async {
    final fvmSettings = await FvmSettings.read();
    final appSettings = await AppSettingsService.read();
    state = AllSettings(
      appSettings: appSettings,
      fvmSettings: fvmSettings,
    );
  }

  // Future<AllSettings> read() async {
  //   return state;
  // }

  Future<void> save(AllSettings settings) async {
    await settings.fvmSettings.save();
    await AppSettingsService.save(settings.appSettings);
  }

  void reload() {
    state = state;
  }
}
