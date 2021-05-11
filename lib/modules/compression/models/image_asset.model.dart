import 'dart:io';

class ImageAsset {
  final File file;
  final FileStat fileStat;
  ImageAsset(
    this.file,
    this.fileStat,
  );

  // Use id path as id because its unique
  String get id {
    return file.path;
  }

  String get name {
    return file.path.split('/').last;
  }

  String get path {
    return file.path;
  }

  int get size {
    return fileStat.size;
  }
}
