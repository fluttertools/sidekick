// ignore_for_file: top_level_function_literal_block
import 'dart:io';

import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../common/utils/helpers.dart';
import 'compression_utils.dart';
import 'models/compression_asset.model.dart';

/// Total Stats of Compression
class TotalCompressionStat {
  /// Construcotr
  const TotalCompressionStat({
    this.original = 0,
    this.savings = 0,
  });

  /// Original size
  final int original;

  /// Savings
  final int savings;
}

/// Image Compression Provider
final compressStatePod = StateNotifierProviderFamily<_CompressProviderState,
    CompressionState, Directory>((ref, directory) {
  return _CompressProviderState(ref, directory);
});

/// Compression state
class CompressionState {
  /// Constructor
  CompressionState._(
    this.assets, {
    this.stats = const TotalCompressionStat(),
    this.isLoading = false,
  });

  /// Loading state
  factory CompressionState.loading() {
    return CompressionState._([], isLoading: true);
  }

  /// Complete state
  factory CompressionState.complete(List<CompressionAsset> assets) {
    return CompressionState._(
      assets,
      stats: getTotalCompressionStat(assets),
    );
  }

  /// Stats
  final TotalCompressionStat stats;

  /// Loading
  bool isLoading;

  /// Assets
  final List<CompressionAsset> assets;

  /// Clones state
  CompressionState clone() {
    return CompressionState._(
      [...assets],
      isLoading: isLoading,
    );
  }
}

class _CompressProviderState extends StateNotifier<CompressionState> {
  _CompressProviderState(
    this.ref,
    this.directory,
  ) : super(CompressionState.loading()) {
    _init();
  }

  final ProviderReference ref;
  final Directory directory;
  Directory _tempDir;

  void _init() async {
    _tempDir = await getSidekickTempDir();
    await _loadProjectAssets(directory);
  }

  void _notifyChange() {
    // Upates state
    state = state.clone();
  }

  Future<void> _loadProjectAssets(Directory directory) async {
    /// Empty state
    state = CompressionState.loading();

    /// Get project images
    final assets = await scanForImages(directory);
    final assetList = <CompressionAsset>[];

    /// Set compression asset at idle state
    for (final asset in assets) {
      assetList.add(CompressionAsset.idle(asset));
    }

    state = CompressionState.complete(assetList);
  }

  Future<void> _compressOne(CompressionAsset asset) async {
    // Notify changes
    asset.start();
    _notifyChange();
    try {
      final compress = await compressImageAsset(asset.original, _tempDir);
      // Is now completed
      asset.complete(compress);
    } on Exception catch (e) {
      // Change to error
      asset.error('$e');
    } finally {
      _notifyChange();
    }
  }

  Future<void> compress() async {
    // Get concurrency count for worker manager
    final futures = <Future<void>>[];

    for (final asset in state.assets) {
      final future = _compressOne(asset);
      futures.add(future);
    }
    await Future.wait(futures);
  }
}
