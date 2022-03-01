import 'dart:io';

/// Scans [rootDir] for a certain condition
Future<List<FileSystemEntity>> scanDirectoryForCondition({
  required bool Function(FileSystemEntity) condition,
  required Directory rootDir,
}) async {
  final entities = <FileSystemEntity>[];

  // Find directories recursively
  await for (FileSystemEntity entity in rootDir.list(
    recursive: true,
    followLinks: false,
  )) {
    // Check if entity is directory
    if (condition(entity)) {
      entities.add(entity);
    }
  }
  return entities;
}
