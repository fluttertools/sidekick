import 'package:fvm/fvm.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sidekick/models/sidekick_settings.model.dart';
import 'package:sidekick/providers/flutter_projects_provider.dart';
import 'package:sidekick/services/settings_service.dart';
import 'package:state_notifier/state_notifier.dart';

class FlutterSettings {
  bool analytics;
}

class Settings {
  SidekickSettings sidekick;
  FvmSettings fvm;
  bool flutterAnalyticsEnabled;
  Settings({
    this.sidekick,
    this.fvm,
    this.flutterAnalyticsEnabled,
  }) {
    if (fvm == null) {
      fvm = FvmSettings();
    }
    if (sidekick == null) {
      sidekick = SidekickSettings();
    }
  }

  Settings copy() => Settings(
        sidekick: SidekickSettings.fromJson(sidekick.toJson()),
        fvm: FvmSettings.fromJson(fvm.toJson()),
        flutterAnalyticsEnabled: flutterAnalyticsEnabled,
      );
}

final settingsRepoProvider = Provider((_) => Settings());

final settingsProvider = StateNotifierProvider<SettingsProvider>((ref) {
  return SettingsProvider(ref, initialState: Settings());
});

class SettingsProvider extends StateNotifier<Settings> {
  ProviderReference ref;
  SettingsProvider(
    this.ref, {
    Settings initialState,
  }) : super(initialState) {
    // Set initial settings from local storage
    _loadState();
  }

  ProjectsProvider get _projectsProvider {
    return ref.read(projectsProvider);
  }

  Future<void> _checkAppSettingsChanges(SidekickSettings settings) async {
    final changed = settings != prevState.sidekick;
    final projectsChanged =
        settings.firstProjectDir != prevState.sidekick.firstProjectDir;

    // Save sidekick settings changed
    if (changed) {
      await SettingsService.save(settings);
    }

    // If project directory change rescan
    if (projectsChanged) {
      await _projectsProvider.scan();
    }
  }

  Future<void> _checkAnalyticsChanges(bool flutterAnalyticsEnabled) async {
    final changed =
        flutterAnalyticsEnabled != prevState.flutterAnalyticsEnabled;
    // Return if nothing changed
    if (changed) {
      // Toggle analytics
      await FVMClient.setFlutterAnalytics(flutterAnalyticsEnabled);
    }
  }

  Future<void> _checkFvmSettingsChanges(FvmSettings settings) async {
    final changed = settings != prevState.fvm;
    if (changed) {
      await FVMClient.saveSettings(settings);
    }
  }

  Settings prevState;

  Future<void> _loadState() async {
    final fvmSettings = await FVMClient.readSettings();
    final appSettings = SettingsService.read();
    final flutterAnalyticsEnabled = await FVMClient.checkFlutterAnalytics();
    state = Settings(
      // Set state
      sidekick: appSettings,
      fvm: fvmSettings,
      flutterAnalyticsEnabled: flutterAnalyticsEnabled,
    );

    /// First run if it's null set
    if (prevState == null) {
      prevState = state.copy();
    }
  }

  Future<void> save(Settings settings) async {
    // Check for changes
    try {
      // Trigger refresh
      prevState;
      state = state.copy();
      await _checkFvmSettingsChanges(settings.fvm);
      await _checkAppSettingsChanges(settings.sidekick);
      await _checkAnalyticsChanges(settings.flutterAnalyticsEnabled);
      // Set previous state only after success
      prevState = state.copy();
    } on Exception {
      // Revert settings in case of errors
      state = prevState;
      rethrow;
    }
  }

  Future<void> reload() async {
    return _loadState();
  }
}
