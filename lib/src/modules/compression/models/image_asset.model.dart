import 'dart:io';

/// Image asset
class ImageAsset {
  /// Constructor
  ImageAsset(
    this.file,
    this.fileStat,
  );

  /// Asset file
  final File file;

  /// File stats
  final FileStat fileStat;

  /// Id of image asset
  /// Uses path as id because is unique
  String get id {
    return file.path;
  }

  /// Name of the file
  String get name {
    return file.path.split('/').last;
  }

  /// File path
  String get path {
    return file.path;
  }

  /// File size
  int get size {
    return fileStat.size;
  }
}
