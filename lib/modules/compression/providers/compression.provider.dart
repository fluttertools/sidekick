import 'dart:io';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sidekick/modules/compression/compression_utils.dart';
import 'package:sidekick/modules/compression/models/compression_asset.model.dart';
import 'package:sidekick/modules/compression/models/image_asset.model.dart';
import 'package:sidekick/utils/utils.dart';

class TotalCompressionStat {
  final int original;
  final int savings;
  TotalCompressionStat({
    this.original = 0,
    this.savings = 0,
  });
}

// Tracks progress of compression
final compressionProgressProvider = Provider((ref) {
  final assets = ref.watch(compressionProvider.state);
  // Turn into a list
  return assets.entries
      .map((e) => e.value)
      .where((e) => e.status == Status.completed)
      .toList();
});

final compressionStateProvider = Provider((ref) {
  final assets = ref.watch(compressionProvider.state);
  // Turn into a list
  return assets.entries
      .map((e) => e.value)
      .where((e) => e.status == Status.completed && e.isSmaller)
      .toList();
});

// ignore: top_level_function_literal_block
final compressionStatProvider = Provider((ref) {
  final activitiesMap = ref.watch(compressionProvider.state);
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
final compressionProvider = StateNotifierProvider<CompressionState>((ref) {
  return CompressionState(ref);
});

class CompressionState extends StateNotifier<Map<String, CompressionAsset>> {
  final ProviderReference ref;
  Directory _tempDir;
  CompressionState(this.ref) : super({}) {
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
    state[asset.id] = CompressionAsset.start(asset);
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
