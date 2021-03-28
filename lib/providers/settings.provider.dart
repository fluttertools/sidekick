import 'package:fvm/fvm.dart';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sidekick/models/app_settings.model.dart';
import 'package:sidekick/services/app_settings_service.dart';
import 'package:state_notifier/state_notifier.dart';

class Settings {
  final AppSettings app;
  final FvmSettings fvm;
  Settings({this.app, this.fvm});
}

final settingsRepoProvider = Provider((_) => Settings());

final settingsProvider = StateNotifierProvider<SettingsProvider>((ref) {
  return SettingsProvider(initialState: Settings());
});

class SettingsProvider extends StateNotifier<Settings> {
  SettingsProvider({Settings initialState}) : super(initialState) {
    // Set initial settings from local storage
    _load();
  }

  Future<void> _load() async {
    final settings = await read();
    state = settings;
  }

  Future<Settings> read() async {
    final fvmSettings = await FvmSettingsService.read();
    final appSettings = await AppSettingsService.read();
    return Settings(
      app: appSettings,
      fvm: fvmSettings,
    );
  }

  Future<AppSettings> readAppSettings() async {
    final settings = await read();
    return settings.app;
  }

  Future<FvmSettings> readFvmSettings() async {
    final settings = await read();
    return settings.fvm;
  }

  Future<void> save(Settings settings) async {
    await FvmSettingsService.save(settings.fvm);
    await AppSettingsService.save(settings.app);
    state = settings;
  }

  Future<void> saveAppSettings(AppSettings settings) async {
    await AppSettingsService.save(settings);
  }

  Future<void> saveFvmSettings(FvmSettings settings) async {
    await FvmSettingsService.save(settings);
  }

  void reload() {
    state = state;
  }
}
