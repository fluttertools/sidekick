// Get path of the directory to find
// Look recursively to all records and get if they have an FVM config
// If they do have fvm config get pubspec, and project name
// Get information about the config and match with the release
// Allow to change the version on a project
// When deleting a version notify that a project has that version attached to it

import 'dart:io';

import 'package:fvm/fvm.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pubspec_parse/pubspec_parse.dart';
import 'package:sidekick/dto/project.dto.dart';
import 'package:sidekick/services/settings_service.dart';
import 'package:state_notifier/state_notifier.dart';

// ignore: top_level_function_literal_block
final projectsPerVersionProvider = Provider((ref) {
  final list = <String, List<Project>>{};
  final projects = ref.watch(projectsProvider);

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

final projectsProvider =
    StateNotifierProvider<ProjectsProvider, ProjectsProviderState>((ref) {
  return ProjectsProvider(ref);
});

class ProjectsProviderState {
  List<FlutterProject> list;
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

  ProjectsProviderState clone() {
    return ProjectsProviderState(
      list: [...list],
      loading: loading,
      error: error,
    );
  }
}

class ProjectsProvider extends StateNotifier<ProjectsProviderState> {
  final ProviderReference ref;

  ProjectsProvider(this.ref) : super(ProjectsProviderState()) {
    reloadAll();
  }

  Future<void> scan() async {
    state.loading = true;
    state.list = [];
    _notifyUpdate();
    final settings = await SettingsService.read();

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
    await SettingsService.save(settings);
    await reloadAll();
  }

  Future<void> pinVersion(FlutterProject project, String version) async {
    await FVMClient.pinVersion(project, version);
    await reloadOne(project);
  }

  void _notifyUpdate() {
    state = state.clone();
  }

  /// Triggers a full project reload. Adds a 1 second delay on update
  /// if [withDelay] is true for better UI feedback
  Future<void> reloadAll({
    bool withDelay = false,
  }) async {
    state.loading = true;
    _notifyUpdate();

    /// Get settings
    final settings = await SettingsService.read();

    /// Get cached path for projects
    final projectPaths = settings.projectPaths;
    if (projectPaths.isNotEmpty) {
      final directories = projectPaths.map((p) => Directory(p)).toList();
      // Go get info for each project
      final projects = await FVMClient.fetchProjects(directories);

      /// Check if its flutter project
      final projectsWithFlutter = projects.where((p) => p.isFlutterProject);

      /// Return flutter projects
      final flutterProjects = projectsWithFlutter.map((p) async {
        final yaml = await p.pubspecFile.readAsString();
        final pubspec = Pubspec.parse(yaml);

        return FlutterProject.fromProject(p, pubspec);
      }).toList();

      state.list = await Future.wait(flutterProjects);
    } else {
      state.list = [];
    }

    /// This is used for better UI feedback
    if (withDelay) {
      await Future.delayed(const Duration(seconds: 1));
    }
    // Set loading to false
    state.loading = false;

    _notifyUpdate();
  }

  Future<void> reloadOne(FlutterProject project) async {
    final index = state.list.indexWhere((item) => item == project);
    // Update project
    state.list[index] = project;
    // Update state
    _notifyUpdate();
  }
}
