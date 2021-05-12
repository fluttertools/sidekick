import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

import '../../../modules/common/constants.dart';

/// Returns a temp `Directory` for sidekick
/// If [subDirectory] is provided it will add to the path
Future<Directory> getSidekickTempDir({
  Directory subDirectory,
}) async {
  final rootTempDir = await getTemporaryDirectory();
  final appTempDir = Directory(join(rootTempDir.path, kAppBundleId));

  // Final temp directory
  var tempDir = appTempDir;

  // If subdirectory add it to app temp directory
  if (subDirectory != null) {
    final subPath = join(appTempDir.path, subDirectory.path);
    tempDir = Directory(subPath);
  }

  // Check if it exists if not create it
  if (!await tempDir.exists()) {
    await tempDir.create(recursive: true);
  }

  return tempDir;
}
