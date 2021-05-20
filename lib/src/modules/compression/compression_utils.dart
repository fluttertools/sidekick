import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:pool/pool.dart';

import '../common/utils/scan_directory.dart';
import 'compression.provider.dart';
import 'models/compression_asset.model.dart';
import 'models/image_asset.model.dart';
import 'squash.dart';

final pool = Pool(
  Platform.numberOfProcessors,
  timeout: const Duration(seconds: 5),
);

/// Compress image asset
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

/// Scan for image assets
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

/// Compression stats
TotalCompressionStat getTotalCompressionStat(List<CompressionAsset> assets) {
  // If its empty return empty total
  if (assets.isEmpty) {
    return TotalCompressionStat();
  }
  // Add up all total from orignal files
  final originalTotal =
      assets.map((e) => e.original.size).reduce((a, b) => a + b);
  // Add up total savings
  final savingsTotal = assets.map((e) => e.savings).reduce((a, b) => a + b);

  return TotalCompressionStat(
    original: originalTotal,
    savings: savingsTotal,
  );
}

/// Apply compression changes
Future<void> applyCompressionChanges(List<CompressionAsset> assets) async {
  final futures = <Future<void>>[];
  for (final asset in assets) {
    /// Return if its not smaller
    if (!asset.isSmaller) return;

    Future<void> future() async {
      await asset.compressed.file.copy(
        asset.original.file.path,
      );
    }

    futures.add(future());
  }

  await Future.wait(futures);
}
