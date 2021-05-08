// Get path of the directory to find
// Look recursively to all records and get if they have an FVM config
// If they do have fvm config get pubspec, and project name
// Get information about the config and match with the release
// Allow to change the version on a project
// When deleting a version notify that a project has that version attached to it
// ignore_for_file: top_level_function_literal_block

import 'dart:async';

import 'package:fvm/fvm.dart';
import 'package:hive/hive.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:state_notifier/state_notifier.dart';

import 'project.dto.dart';
import 'projects.service.dart';

/// Projects per release
final projectsPerVersionProvider = Provider((ref) {
  final list = <String, List<Project>>{};
  final projects = ref.watch(projectsProvider);

  if (projects == null || projects.isEmpty) {
    return list;
  }

  for (var project in projects) {
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
    _init();
  }

  StreamSubscription<BoxEvent> _subscription;

  void _init() {
    _subscription = ProjectsService.box.watch().listen((event) {
      load();
    });
    load();
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  /// Pins a release to project
  Future<void> pinRelease(FlutterProject project, String version) async {
    await FVMClient.pinVersion(project, version);
    await reload(project);
  }

  /// Triggers a full project reload. Adds a 1 second delay on update
  /// if [withDelay] is true for better UI feedback
  Future<void> load() async {
    print('Loading projects');
    state = await ProjectsService.load();
  }

  /// Reloads one project
  Future<void> reload(FlutterProject project) async {
    final index = state.indexWhere((item) => item == project);
    // Update project
    state[index] = project;
  }
}
