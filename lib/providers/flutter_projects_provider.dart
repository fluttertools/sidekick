// Get path of the directory to find
// Look recursively to all records and get if they have an FVM config
// If they do have fvm config get pubspec, and project name
// Get information about the config and match with the release
// Allow to change the version on a project
// When deleting a version notify that a project has that version attached to it

import 'dart:io';

import 'package:fvm/fvm.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sidekick/providers/settings.provider.dart';
import 'package:state_notifier/state_notifier.dart';

// ignore: top_level_function_literal_block
final projectsPerVersionProvider = Provider((ref) {
  final list = <String, List<Project>>{};
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
  List<Project> list;
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
    final projectDir = settings.firstProjectDir;

    // Return if there is no directory to scan
    if (settings.firstProjectDir == null) {
      return;
    }
    final projects = await FVMClient.scanDirectory(
      rootDir: Directory(projectDir),
    );
    // Set project paths
    settings.projectPaths = projects.map((project) {
      return project.projectDir.path;
    }).toList();
    await _settingsProvider.saveAppSettings(settings);
    await reloadAll();
  }

  Future<void> pinVersion(Project project, String version) async {
    await FVMClient.pinVersion(project, version);
    await reloadOne(project);
  }

  Future<void> reloadAll() async {
    state.loading = true;

    /// Get settings
    final settings = await _settingsProvider.readAppSettings();

    /// Get cached path for projects
    final projectPaths = settings.projectPaths;
    if (projectPaths != null) {
      final directories = projectPaths.map((p) => Directory(p)).toList();

      final projects = await FVMClient.fetchProjects(directories);

      /// Check if its flutter project
      state.list = projects.where((p) => p.isFlutterProject).toList();
    } else {
      state.list = [];
    }

    state = state;
    state.loading = false;
  }

  Future<void> reloadOne(Project project) async {
    final index = state.list.indexWhere((item) => item == project);
    // Add project to index
    state.list[index] =
        await FVMClient.getProjectByDirectory(project.projectDir);

    // Update state
    state = state;
  }
}
