import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fvm/fvm.dart';
import 'package:pubspec_parse/pubspec_parse.dart';

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

  factory FlutterProject.fromProject(Project project, Pubspec pubspec) {
    return FlutterProject._(
      name: project.name,
      config: project.config,
      projectDir: project.projectDir,
      pubspec: pubspec,
    );
  }
  final Pubspec pubspec;

  String get description {
    return pubspec.description ?? '';
  }
}
