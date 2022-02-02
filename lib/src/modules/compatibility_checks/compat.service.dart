import 'dart:io';

import 'package:dio/dio.dart';

import '../common/constants.dart';

Future<String> getSidekickLatestRelease() async {
  final response = await Dio().get(kSidekickLatestReleaseUrl);

  return response.data['tag_name'];
}

/// Handles app Sidekick updates
class CompatService {
  const CompatService._();

  /// Helper method to easily check for updates on [packageName]
  /// comparing with [current] returns `LatestVersion`
  static Future<CompatService> checkState() async {
    try {
      // TODO: Implement Checks
      return null;
    } on Exception catch (_) {
      //print(err.toString());
      return null;
    }
  }

  /// Download release
  static Future<Process> downloadAndInstallBrew() async {
    //return Process.run("ipconfig", []);
    return Process.start(
        "/bin/bash",
        [
          '-c "\$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)'
        ],
        runInShell: true);
  }
}

/// Exception for updaters
class CompatException implements Exception {
  /// Message of erro
  final String message;

  /// Constructor
  const CompatException([this.message = '']);

  @override
  String toString() => message;
}
