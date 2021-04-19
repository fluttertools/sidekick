import 'dart:io';

/// Scans [rootDir] for a certain condition
Future<List<FileSystemEntity>> scanDirectoryForCondition({
  bool Function(FileSystemEntity) condition,
  Directory rootDir,
}) async {
  assert(condition != null);
  assert(rootDir != null);
  final entities = <FileSystemEntity>[];

  if (rootDir == null) {
    return [];
  }
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
