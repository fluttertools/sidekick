import 'package:fvm/fvm.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sidekick/dto/settings.dto.dart';
import 'package:sidekick/providers/projects_provider.dart';
import 'package:sidekick/services/settings_service.dart';
import 'package:state_notifier/state_notifier.dart';

class Settings {
  SidekickSettings sidekick;
  FvmSettings fvm;
  FlutterSettings flutter;

  Settings({
    this.sidekick,
    this.fvm,
    this.flutter,
  }) {
    if (fvm == null) {
      fvm = FvmSettings();
    }
    if (sidekick == null) {
      sidekick = SidekickSettings();
    }

    if (flutter == null) {
      flutter = FlutterSettings();
    }
  }

  Settings copy() => Settings(
        sidekick: SidekickSettings.fromJson(sidekick.toJson()),
        fvm: FvmSettings.fromJson(fvm.toJson()),
        flutter: FlutterSettings.fromMap(flutter.toMap()),
      );
}

final settingsRepoProvider = Provider((_) => Settings());

final settingsProvider =
    StateNotifierProvider<SettingsProvider, Settings>((ref) {
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
    return ref.read(projectsProvider.notifier);
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

  Future<void> _checkAnalyticsChanges(FlutterSettings settings) async {
    final changed = settings != prevState.flutter;
    // Return if nothing changed
    if (changed) {
      // Toggle analytics
      await FVMClient.setFlutterConfig(settings.toMap());
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
    /// Update app state right away
    final sidekickSettings = SettingsService.read();
    state = Settings(sidekick: sidekickSettings);

    //Go get async state
    final fvmSettings = await FVMClient.readSettings();
    final flutterSettings = await FVMClient.getFlutterConfig();
    state = Settings(
      // Set state
      sidekick: sidekickSettings,
      fvm: fvmSettings,
      flutter: FlutterSettings.fromMap(flutterSettings),
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

      state = state.copy();
      await _checkFvmSettingsChanges(settings.fvm);
      await _checkAppSettingsChanges(settings.sidekick);
      await _checkAnalyticsChanges(settings.flutter);
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
