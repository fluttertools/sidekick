import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:pool/pool.dart';

import '../../utils/scan_directory.dart';
import '../../utils/squash.dart';
import 'models/image_asset.model.dart';

final pool = Pool(
  Platform.numberOfProcessors,
  timeout: const Duration(seconds: 30),
);

Future<ImageAsset> compressImageAsset(
  ImageAsset asset,
  Directory tempDir,
) async {
  final compressObj = SquashObject(
    imageFile: asset.file,
    path: tempDir.path,
    quality: 80, //first compress quality, default 80
    step: 6, //compress quality step, bigger faster
  );
  // Use a pool for isolates
  final file = await pool.withResource(() => Squash.compressImage(compressObj));
  // Get file stat
  final fileStat = await file.stat();
  // Create image asset
  return ImageAsset(file, fileStat);
}

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
