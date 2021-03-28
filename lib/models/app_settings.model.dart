import 'dart:convert';

class AppSettings {
  static const key = 'app_settings';
  List<String> flutterProjectsDir;
  bool advancedMode;
  bool onlyProjectsWithFvm;
  List<String> projectPaths;

  AppSettings({
    this.flutterProjectsDir = const [],
    this.advancedMode = false,
    this.onlyProjectsWithFvm = false,
    this.projectPaths = const [],
  });

  factory AppSettings.fromJson(String str) =>
      AppSettings.fromMap(json.decode(str));

  factory AppSettings.fromMap(Map<String, dynamic> json) {
    return AppSettings(
      flutterProjectsDir:
          (json['flutterProjectsDir'] as List<dynamic>).cast<String>(),
      projectPaths: (json['projectPaths'] as List<dynamic>).cast<String>(),
      advancedMode: json['advancedMode'] as bool ?? false,
      onlyProjectsWithFvm: json['onlyProjectsWithFvm'] as bool ?? false,
    );
  }

  /// Converts Master Secret to Json
  String toJson() => json.encode(toMap());

  Map<String, dynamic> toMap() {
    return {
      'flutterProjectsDir': flutterProjectsDir,
      'projectPaths': projectPaths,
      'advancedMode': advancedMode,
      'onlyProjectsWithFvm': onlyProjectsWithFvm,
    };
  }
}
