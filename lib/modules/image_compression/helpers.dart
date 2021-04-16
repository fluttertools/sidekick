import 'dart:io';

import 'package:flutter_luban/flutter_luban.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:pool/pool.dart';
import 'package:sidekick/utils/scan_directory.dart';

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

class CompressActivity {
  final File original;
  final File compressed;
  final bool processing;
  CompressActivity({
    this.original,
    this.compressed,
    this.processing,
  });

  factory CompressActivity.start(File original) {
    return CompressActivity(
      original: original,
      processing: true,
    );
  }

  CompressActivity complete(File compressed) {
    return CompressActivity(
      original: original,
      compressed: compressed,
      processing: false,
    );
  }
}

Future<List<CompressActivity>> compressAllImages(
  List<CompressActivity> activities,
) async {
  final tempDir = await getTemporaryDirectory();
  // Get concurrency count for worker manager
  final futures = <Future<CompressActivity>>[];

  for (final activity in activities) {
    final future = compressActivity(activity, tempDir);
    futures.add(future);
  }
  return Future.wait(futures);
}

final pool = Pool(
  Platform.numberOfProcessors,
  timeout: const Duration(seconds: 30),
);

Future<CompressActivity> compressActivity(
  CompressActivity activity,
  Directory tempDir,
) async {
  final compressObj = CompressObject(
    imageFile: activity.original,
    path: tempDir.path,
    quality: 80,
    step: 9,
    mode: CompressMode.LARGE2SMALL,
  );
  // Use a pool for isolates
  final path = await pool.withResource(() => Luban.compressImage(compressObj));
  // final path = await Luban.compressImage(compressObj);
  return activity.complete(File(path));
}

Future<List<CompressActivity>> scanForImages(Directory directory) async {
  final files = await scanDirectoryForCondition(
    condition: _checkIsValidImage,
    rootDir: directory,
  );

  return files.map((image) => CompressActivity.start(image)).toList();
}
