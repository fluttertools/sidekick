import 'dart:io';

import 'package:fvm/fvm.dart';
import 'package:hive/hive.dart';
import 'package:pubspec_parse/pubspec_parse.dart';

import 'project.dto.dart';

/// Projects service
class ProjectsService {
  /// Constructor
  const ProjectsService._();

  /// Storage key
  static const _key = 'projects_service_box';

  /// Storage box
  static Box<ProjectRef> box;

  /// Initializes the service
  static Future<void> init() async {
    box = await Hive.openBox<ProjectRef>(_key);
  }

  /// Loads all projects
  static Future<List<FlutterProject>> load() async {
    /// Return if its empty
    if (box.isEmpty) return <FlutterProject>[];

    /// Get stored project directory
    final directories = box.values.map((p) => Directory(p.path)).toList();

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

    return await Future.wait(flutterProjects);
  }

  // /// Loads one project
  // static Future<FlutterProject> loadOne(String path) async {
  //   // Get project directory
  //   final directory = Directory(path);

  //   // Go get info for each project
  //   final project = await FVMClient.getProjectByDirectory(directory);

  //   /// Return flutter project

  //   final yaml = await project.pubspecFile.readAsString();
  //   final pubspec = Pubspec.parse(yaml);

  //   return FlutterProject.fromProject(project, pubspec);
  // }
}
