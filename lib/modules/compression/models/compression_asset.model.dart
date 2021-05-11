import 'package:sidekick/modules/compression/models/image_asset.model.dart';

enum Status {
  idle,
  started,
  completed,
}

class CompressionAsset {
  final ImageAsset original;
  final ImageAsset compressed;
  final Status status;
  final bool hasError;
  final String errorMsg;
  CompressionAsset({
    this.original,
    this.compressed,
    this.status = Status.idle,
    this.hasError = false,
    this.errorMsg = '',
  });

  factory CompressionAsset.start(ImageAsset original) {
    return CompressionAsset(
      original: original,
      status: Status.started,
    );
  }

  /// Returns if compression returned smaller file
  bool get isSmaller {
    // if savings is greater than 0
    // The file is smaller now
    if (status == Status.completed) {
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
    if (status == Status.completed) {
      final percent = (100 - ((compressed.size / original.size) * 100));
      return '${percent.toStringAsFixed(1)}%';
    } else {
      return null;
    }
  }

  CompressionAsset error(String message) {
    return CompressionAsset(
      original: original,
      hasError: true,
      errorMsg: message,
      status: Status.completed,
    );
  }

  CompressionAsset complete(
    ImageAsset compressed,
  ) {
    return CompressionAsset(
      original: original,
      compressed: compressed,
      status: Status.completed,
    );
  }
}
