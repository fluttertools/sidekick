import 'dart:io';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:path/path.dart' as p;
import 'package:sidekick/modules/image_compression/models/image_asset.model.dart';
import 'package:sidekick/utils/scan_directory.dart';

final projectImagesProvider = FutureProviderFamily<List<ImageAsset>, Directory>(
    (_, projectDir) => scanForImages(projectDir));

Future<List<ImageAsset>> scanForImages(Directory directory) async {
  final files = await scanDirectoryForCondition(
    condition: _checkIsValidImage,
    rootDir: directory,
  );

  final mappedList = files.map((file) async {
    final stat = await file.stat();
    return ImageAsset(file, stat);
  }).toList();

  return Future.wait(mappedList);
}

const _extensionList = [
  '.jpg',
  '.JPG',
  '.jpeg',
  '.JPEG',
  '.gif',
  '.GIF',
  '.png',
  '.PNG',
];

bool _checkIsValidImage(FileSystemEntity entity) {
  final ext = p.extension(entity.path);
  if (!entity.path.contains('/build/')) {
    return _extensionList.contains(ext);
  } else {
    return false;
  }
}
