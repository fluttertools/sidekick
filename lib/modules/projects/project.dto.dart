import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fvm/fvm.dart';
import 'package:hive/hive.dart';
import 'package:pubspec_parse/pubspec_parse.dart';

/// Flutter project
class FlutterProject extends Project {
  /// Project constructor
  FlutterProject._({
    @required String name,
    @required FvmConfig config,
    @required Directory projectDir,
    @required this.pubspec,
  }) : super(
          name: name,
          config: config,
          projectDir: projectDir,
          isFlutterProject: true,
        );

  /// Create Flutter project from project
  factory FlutterProject.fromProject(Project project, Pubspec pubspec) {
    return FlutterProject._(
      name: project.name,
      config: project.config,
      projectDir: project.projectDir,
      pubspec: pubspec,
    );
  }

  /// Pubspec
  final Pubspec pubspec;

  /// Project description
  String get description {
    return pubspec.description ?? '';
  }
}

/// Path to project
class ProjectPath {
  /// Constructor
  const ProjectPath._({
    @required this.name,
    @required this.path,
  });

  /// Project name
  final String name;

  /// Project path
  final String path;

  /// Creates a project path from map
  factory ProjectPath.fromMap(Map<String, String> map) {
    return ProjectPath._(
      name: map['name'],
      path: map['path'],
    );
  }

  /// Returns project path as a map
  Map<String, String> toMap() {
    return {
      'name': name,
      'path': path,
    };
  }
}

/// Project path adapter
class ProjectPathAdapter extends TypeAdapter<ProjectPath> {
  @override
  int get typeId => 1; // this is unique, no other Adapter can have the same id.

  @override
  ProjectPath read(BinaryReader reader) {
    // final value = Map<String, String>.from(reader.readMap());
    return ProjectPath.fromMap(reader.readMap());
  }

  @override
  void write(BinaryWriter writer, ProjectPath obj) {
    writer.writeMap(obj.toMap());
  }
}
