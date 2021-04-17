import 'package:sidekick/modules/image_compression/models/image_asset.model.dart';

class CompressActivity {
  final ImageAsset original;
  final ImageAsset compressed;
  final bool processing;
  final bool completed;
  final bool hasError;
  final String errorMsg;
  CompressActivity({
    this.original,
    this.compressed,
    this.processing = false,
    this.completed = false,
    this.hasError = false,
    this.errorMsg = '',
  });

  factory CompressActivity.start(ImageAsset original) {
    return CompressActivity(
      original: original,
      processing: true,
    );
  }

  /// Returns if compression returned smaller file
  bool get isSmaller {
    // if savings is greater than 0
    // The file is smaller now
    if (completed) {
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
    if (completed) {
      final percent = (100 - ((compressed.size / original.size) * 100));
      return '${percent.toStringAsFixed(1)}%';
    } else {
      return null;
    }
  }

  CompressActivity error(String message) {
    return CompressActivity(
      original: original,
      hasError: true,
      errorMsg: message,
      completed: false,
    );
  }

  CompressActivity complete(
    ImageAsset compressed,
  ) {
    return CompressActivity(
      original: original,
      compressed: compressed,
      completed: true,
    );
  }
}
