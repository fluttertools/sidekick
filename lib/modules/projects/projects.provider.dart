// Get path of the directory to find
// Look recursively to all records and get if they have an FVM config
// If they do have fvm config get pubspec, and project name
// Get information about the config and match with the release
// Allow to change the version on a project
// When deleting a version notify that a project has that version attached to it
// ignore_for_file: top_level_function_literal_block

import 'dart:async';
import 'dart:io';

import 'package:fvm/fvm.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:state_notifier/state_notifier.dart';

import '../settings/settings.service.dart';
import 'project.dto.dart';
import 'projects.service.dart';

/// Projects per release
final projectsPerVersionProvider = Provider((ref) {
  final list = <String, List<Project>>{};
  final projects = ref.watch(projectsProvider);

  if (projects == null || projects.isEmpty) {
    return list;
  }

  for (final project in projects) {
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

/// Projects provider
final projectsProvider =
    StateNotifierProvider<ProjectsStateNotifier, List<FlutterProject>>(
  (_) => ProjectsStateNotifier(),
);

/// Projects state
class ProjectsStateNotifier extends StateNotifier<List<FlutterProject>> {
  /// Constructor
  ProjectsStateNotifier() : super(<FlutterProject>[]) {
    load();
  }

  /// Pins a release to project
  Future<void> pinRelease(FlutterProject project, String version) async {
    await FVMClient.pinVersion(project, version);
    await reload(project);
  }

  /// Triggers a full project reload. Adds a 1 second delay on update
  /// if [withDelay] is true for better UI feedback
  Future<void> load() async {
    /// Do migration
    await _migrate();

    state = await ProjectsService.load();
  }

  /// Reloads one project
  Future<void> reload(FlutterProject project) async {
    final index = state.indexWhere((item) => item == project);
    // Update project
    state[index] = project;

    /// Notify state
    state = [...state];
  }

  /// Adds a project
  Future<void> addProject(String path) async {
    final project = await FVMClient.getProjectByDirectory(Directory(path));
    if (project.isFlutterProject) {
      final ref = ProjectRef(name: path.split('/').last, path: path);
      ProjectsService.box.put(path, ref);
      load();
    }
  }

  /// Removes a project
  void removeProject(FlutterProject project) {
    ProjectsService.box.delete(project.projectDir.path);
    load();
  }

  Future<void> _migrate() async {
    /// Do migration
    /// TODO: Can be removed before 1.0
    final settings = SettingsService.read();

    if (settings.projectPaths.isNotEmpty) {
      for (final path in settings.projectPaths) {
        ProjectsService.box.put(
          path,
          ProjectRef(
            name: path.split('/').last,
            path: path,
          ),
        );
      }

      /// Delete settings
      settings.projectPaths = [];
      await SettingsService.save(settings);
    }
  }
}
