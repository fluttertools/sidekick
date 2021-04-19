import 'dart:io';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sidekick/modules/compression/compression_utils.dart';
import 'package:sidekick/modules/compression/models/compression_asset.model.dart';
import 'package:sidekick/modules/compression/models/image_asset.model.dart';
import 'package:sidekick/utils/utils.dart';

class TotalCompressionStat {
  final int original;
  final int savings;
  final int totalFiles;
  final int compressedFiles;
  TotalCompressionStat({
    this.original = 0,
    this.savings = 0,
    this.totalFiles = 0,
    this.compressedFiles = 0,
  });
}

final compressedListProvider = Provider((ref) {
  final assets = ref.watch(compressedProvider.state);
  // Turn into a list
  return assets.entries.map((e) => e.value).toList();
});

// ignore: top_level_function_literal_block
final compressionTotalProvider = Provider((ref) {
  final activitiesMap = ref.watch(compressedProvider.state);
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

  final completedFiles =
      activities.where((e) => e.status == CompressionStatus.completed).toList();

  return TotalCompressionStat(
      original: originalTotal,
      savings: savingsTotal,
      totalFiles: activities.length,
      compressedFiles: completedFiles.length);
});

/// Image Compression Provider
final compressedProvider =
    StateNotifierProvider<CompressionActivityState>((ref) {
  return CompressionActivityState(ref);
});

class CompressionActivityState
    extends StateNotifier<Map<String, CompressedAsset>> {
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

    for (final asset in assets) {
      state[asset.id] = CompressedAsset.start(asset);
    }

    _notifyChange();
    // Get concurrency count for worker manager
    final futures = <Future<void>>[];

    for (final asset in assets) {
      final future = _compressOne(asset);
      futures.add(future);
    }
    await Future.wait(futures);
  }
}
