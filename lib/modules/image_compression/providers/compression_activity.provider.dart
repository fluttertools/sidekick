import 'dart:io';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pool/pool.dart';
import 'package:sidekick/modules/image_compression/models/compress_activity.model.dart';
import 'package:sidekick/modules/image_compression/models/image_asset.model.dart';
import 'package:sidekick/utils/squash.dart';
import 'package:sidekick/utils/utils.dart';

class TotalCompressionStat {
  final int original;
  final int savings;
  TotalCompressionStat({
    this.original = 0,
    this.savings = 0,
  });
}

// ignore: top_level_function_literal_block
final compressionStatProvider = Provider((ref) {
  final activitiesMap = ref.watch(compressionActivityProvider.state);
  final activities = activitiesMap.entries.map((e) => e.value);
  // If its empty return empty total
  if (activities.isEmpty) {
    return TotalCompressionStat();
  }
  // Add up all total from orignal files
  final originalTotal =
      activities.map((e) => e.original.size).reduce((a, b) => a + b);
  // Add up total savings
  final savingsTotal = activities.map((e) => e.savings).reduce((a, b) => a + b);

  return TotalCompressionStat(
    original: originalTotal,
    savings: savingsTotal,
  );
});

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
    _tempDir = await getSidekickTempDir();
  }

  void _notifyChange() {
    // Upates state
    state = {...state};
  }

  Future<void> _compressOne(ImageAsset asset) async {
    state[asset.id] = CompressActivity.start(asset);
    _notifyChange();
    try {
      final compress = await compressImageAsset(asset, _tempDir);
      // Is now completed
      state[asset.id] = state[asset.id].complete(compress);
    } on Exception catch (e) {
      // Change to error
      state[asset.id] = state[asset.id].error('$e');
    } finally {
      _notifyChange();
    }
  }

  Future<void> compressAll(List<ImageAsset> assets) async {
    state = {};
    // Get concurrency count for worker manager
    final futures = <Future<void>>[];

    for (final asset in assets) {
      final future = _compressOne(asset);
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
    step: 6, //compress quality step, bigger faster
  );
  // Use a pool for isolates
  final file = await pool.withResource(() => Squash.compressImage(compressObj));
  // Get file stat
  final fileStat = await file.stat();
  // Create image asset
  return ImageAsset(file, fileStat);
}
