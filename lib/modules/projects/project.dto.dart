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
    this.invalid = false,
  }) : super(
          name: name,
          config: config,
          projectDir: projectDir,
          isFlutterProject: true,
        );

  /// If a project does not have pubspec
  final bool invalid;

  /// Create Flutter project from project
  factory FlutterProject.fromProject(Project project, Pubspec pubspec) {
    return FlutterProject._(
      name: project.name,
      config: project.config,
      projectDir: project.projectDir,
      pubspec: pubspec,
    );
  }

  /// Create Flutter project from project
  factory FlutterProject.fromInvalidProject(Project project) {
    return FlutterProject._(
      name: project.name,
      config: project.config,
      projectDir: project.projectDir,
      pubspec: null,
      invalid: true,
    );
  }

  /// Pubspec
  final Pubspec pubspec;

  /// Project description
  String get description {
    return pubspec.description ?? '';
  }
}

/// Ref to project path
class ProjectRef {
  /// Constructor
  const ProjectRef({
    @required this.name,
    @required this.path,
  });

  /// Project name
  final String name;

  /// Project path
  final String path;

  /// Creates a project path from map
  factory ProjectRef.fromMap(Map<String, String> map) {
    return ProjectRef(
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
class ProjectPathAdapter extends TypeAdapter<ProjectRef> {
  @override
  int get typeId => 2; // this is unique, no other Adapter can have the same id.

  @override
  ProjectRef read(BinaryReader reader) {
    final value = Map<String, String>.from(reader.readMap());
    return ProjectRef.fromMap(value);
  }

  @override
  void write(BinaryWriter writer, ProjectRef obj) {
    writer.writeMap(obj.toMap());
  }
}
