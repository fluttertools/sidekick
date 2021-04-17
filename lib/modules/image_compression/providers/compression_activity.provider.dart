import 'dart:io';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pool/pool.dart';
import 'package:sidekick/modules/image_compression/models/compress_activity.model.dart';
import 'package:sidekick/modules/image_compression/models/image_asset.model.dart';
import 'package:sidekick/utils/squash.dart';

/// Image Compression Provider
final compressionActivityProvider =
    StateNotifierProvider<CompressionActivityState>((ref) {
  return CompressionActivityState(ref);
});

class CompressionActivityState
    extends StateNotifier<Map<String, CompressActivity>> {
  final ProviderReference ref;
  Directory _tempDir;
  CompressionActivityState(this.ref) : super({}) {
    _init();
  }

  void _init() async {
    _tempDir = await getTemporaryDirectory();
  }

  void _notifyChange() {
    // Upates state
    state = {...state};
  }

  Future<void> compressOne(ImageAsset asset) async {
    state[asset.id] = CompressActivity.start(asset);
    _notifyChange();
    try {
      final compress = await compressImageAsset(asset, _tempDir);
      // Is now completed
      state[asset.id] = state[asset.id].complete(compress);
    } on Exception catch (e) {
      // Change to error
      state[asset.id] = state[asset.id].error(e.toString());
    } finally {
      _notifyChange();
    }
  }

  Future<void> compressAll(List<ImageAsset> assets) async {
    // Get concurrency count for worker manager
    final futures = <Future<void>>[];

    for (final asset in assets) {
      final future = compressOne(asset);
      futures.add(future);
    }
    await Future.wait(futures);
  }
}

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
    step: 9, //compress quality step, bigger faster
  );
// Use a pool for isolates
  final path = await pool.withResource(() => Squash.compressImage(compressObj));
  final file = File(path);
  final fileStat = await file.stat();
  print('Original');
  print(asset.path);
  print('Compressed');
  print(file.path);
  return ImageAsset(file, fileStat);
}
