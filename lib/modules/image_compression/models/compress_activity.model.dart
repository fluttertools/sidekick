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
    return savings > 0;
  }

  double get savings {
    if (completed) {
      // Get difference to calculate savings
      // Calculate percetage difference between compressed and original
      final percent = (100 - ((compressed.size / original.size) * 100));
      return percent;
    } else {
      return 0;
    }
  }

  String get savingsFriendly {
    if (completed) {
      return '${savings.toStringAsFixed(1)}%';
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
