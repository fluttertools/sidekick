import 'package:sidekick/modules/compression/models/image_asset.model.dart';

enum CompressionStatus {
  idle,
  started,
  completed,
}

class CompressedAsset {
  final ImageAsset original;
  final ImageAsset compressed;
  final CompressionStatus status;
  final bool hasError;
  final String errorMsg;
  CompressedAsset({
    this.original,
    this.compressed,
    this.status = CompressionStatus.idle,
    this.hasError = false,
    this.errorMsg = '',
  });

  factory CompressedAsset.start(ImageAsset original) {
    return CompressedAsset(
      original: original,
      status: CompressionStatus.started,
    );
  }

  /// Returns if compression returned smaller file
  bool get isSmaller {
    // if savings is greater than 0
    // The file is smaller now
    if (status == CompressionStatus.completed) {
      return original.size > compressed.size;
    } else {
      return false;
    }
  }

  int get savings {
    if (isSmaller) {
      return original.size - compressed.size;
    } else {
      return 0;
    }
  }

  String get savingsPercentage {
    if (status == CompressionStatus.completed) {
      final percent = (100 - ((compressed.size / original.size) * 100));
      return '${percent.toStringAsFixed(1)}%';
    } else {
      return null;
    }
  }

  CompressedAsset error(String message) {
    return CompressedAsset(
      original: original,
      hasError: true,
      errorMsg: message,
      status: CompressionStatus.completed,
    );
  }

  CompressedAsset complete(
    ImageAsset compressed,
  ) {
    return CompressedAsset(
      original: original,
      compressed: compressed,
      status: CompressionStatus.completed,
    );
  }
}
