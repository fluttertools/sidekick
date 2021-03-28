// Get path of the directory to find
// Look recursively to all records and get if they have an FVM config
// If they do have fvm config get pubspec, and project name
// Get information about the config and match with the release
// Allow to change the version on a project
// When deleting a version notify that a project has that version attached to it

import 'dart:io';

import 'package:sidekick/providers/settings.provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:fvm/fvm.dart';
import 'package:state_notifier/state_notifier.dart';

final projectsScanProvider = FutureProvider<List<FlutterApp>>((ref) {
  final settings = ref.watch(settingsProvider.state).app;
  // TODO: Check for projects array
  if (settings.flutterProjectsDir == null) {
    throw Exception('A Flutter Projects directory must be selected');
  } else {
    return FlutterAppService.scanDirectory();
  }
});

// ignore: top_level_function_literal_block
final projectsPerVersionProvider = Provider((ref) {
  final list = <String, List<FlutterApp>>{};
  final projects = ref.watch(projectsProvider.state);

  if (projects == null || projects.list.isEmpty) {
    return list;
  }

  for (var project in projects.list) {
    final version =
        project.pinnedVersion != null ? project.pinnedVersion : 'NONE';
    final versionProjects = list[version];
    if (versionProjects != null) {
      versionProjects.add(project);
    } else {
      list[version] = [project];
    }
  }

  return list;
});

final projectsProvider = StateNotifierProvider<ProjectsProvider>((ref) {
  return ProjectsProvider(ref);
});

class ProjectsProviderState {
  List<FlutterApp> list;
  bool loading;
  String error;

  ProjectsProviderState({
    this.list = const [],
    this.loading = false,
    this.error,
  });

  factory ProjectsProviderState.loading() {
    return ProjectsProviderState(loading: true);
  }

  factory ProjectsProviderState.error(dynamic err) {
    return ProjectsProviderState(error: err.toString());
  }
}

class ProjectsProvider extends StateNotifier<ProjectsProviderState> {
  final ProviderReference ref;

  ProjectsProvider(this.ref) : super(ProjectsProviderState()) {
    reloadAll();
  }

  SettingsProvider get _settingsProvider {
    return ref.read<SettingsProvider>(settingsProvider);
  }

  Future<void> scan() async {
    final settings = await _settingsProvider.readAppSettings();
    // TODO: Support multiple paths
    final projectDir = settings.flutterProjectsDir[1];

    // Return if there is no directory to scan
    if (settings.flutterProjectsDir == null) {
      return;
    }
    final projects = await FlutterAppService.scanDirectory(
      rootDir: Directory(projectDir),
    );
    // Set project paths
    settings.projectPaths = projects.map((project) {
      return project.projectDir.path;
    }).toList();
    await _settingsProvider.saveAppSettings(settings);
    await reloadAll();
  }

  Future<void> pinVersion(FlutterApp project, String version) async {
    await FlutterAppService.pinVersion(project, version);
    await reloadOne(project);
  }

  Future<void> reloadAll() async {
    state.loading = true;
    final settings = await _settingsProvider.readAppSettings();
    if (settings.projectPaths == null) {}
    final directories = settings.projectPaths.map((path) => path).toList();
    state.list = await FlutterAppService.fetchProjects(directories);
    state = state;
    state.loading = false;
  }

  Future<void> reloadOne(FlutterApp project) async {
    final index = state.list.indexWhere((item) => item == project);

    state.list[index] =
        await FlutterAppService.getByDirectory(project.projectDir);
    state = state;
  }
}
