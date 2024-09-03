
import 'package:fvm/fvm.dart';
import 'package:hive/hive.dart';
import 'package:pubspec_parse/pubspec_parse.dart';

/// Flutter project
class FlutterProject extends Project {
  /// Project constructor
  @override
  // ignore: overridden_fields
  final String name;
  FlutterProject._({
    required this.name,
    required super.config,
    required super.projectDir,
    required this.pubspec,
    this.invalid = false,
    this.projectIcon = "",
  }) : super(
          name: name,
          isFlutterProject: true,
        );

  /// If a project does not have pubspec
  final bool invalid;

  /// Create Flutter project from project
  factory FlutterProject.fromProject(Project project, Pubspec pubspec,
      {String projectIcon = ""}) {
    return FlutterProject._(
      name: project.name ?? pubspec.name,
      config: project.config,
      projectDir: project.projectDir,
      pubspec: pubspec,
      projectIcon: projectIcon,
    );
  }

  /// Create Flutter project from project
  factory FlutterProject.fromInvalidProject(Project project) {
    return FlutterProject._(
      name: project.name ?? '',
      config: project.config,
      projectDir: project.projectDir,
      pubspec: null,
      invalid: true,
      projectIcon: "",
    );
  }

  /// Pubspec
  final Pubspec? pubspec;

  /// Project description
  String get description {
    return pubspec?.description ?? '';
  }

  /// Project Icon Raw String Data
  late String projectIcon;
}

/// Ref to project path
class ProjectRef {
  /// Constructor
  ProjectRef({
    required this.name,
    required this.projectIcon,
    required this.path,
  });

  /// Project name
  final String name;

  /// Project path
  final String path;

  /// Project Icon
  final String projectIcon;

  /// Creates a project path from map
  factory ProjectRef.fromMap(Map<String, String> map) {
    return ProjectRef(
        name: map['name'] ?? '',
        path: map['path'] ?? '',
        projectIcon: map['projectIcon'] ?? '');
  }

  /// Returns project path as a map
  Map<String, String> toMap() {
    return {'name': name, 'path': path, 'projectIcon': projectIcon};
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
