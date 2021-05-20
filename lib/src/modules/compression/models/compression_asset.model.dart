import 'package:flutter/material.dart';

import 'image_asset.model.dart';

/// Compress Status
enum Status {
  /// Not started
  idle,

  /// Started
  started,

  /// Completed
  completed,

  /// Completed with error
  error,
}

/// Compression asset
class CompressionAsset {
  ///Constructor
  CompressionAsset({
    @required this.original,
    this.compressed,
    this.status = Status.idle,
    this.errorMsg = '',
  });

  /// Original assset
  final ImageAsset original;

  /// Compressed asset
  ImageAsset compressed;

  /// status
  Status status;

  /// Error message
  String errorMsg;

  /// Compression asset with idle
  factory CompressionAsset.idle(ImageAsset original) {
    return CompressionAsset(
      original: original,
      status: Status.idle,
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

  /// Id
  String get id {
    return original.id;
  }

  /// Total savings
  int get savings {
    if (isSmaller) {
      return original.size - compressed.size;
    } else {
      return 0;
    }
  }

  /// Percentage of savings
  String get savingsPercentage {
    if (status == Status.completed) {
      final percent = (100 - ((compressed.size / original.size) * 100));
      return '${percent.toStringAsFixed(1)}%';
    } else {
      return null;
    }
  }

  /// Compression asset with start status
  void start() => status = Status.started;

  /// Compression status with error
  void error(String message) {
    status = Status.error;
    errorMsg = message;
  }

  /// Complete a compresion status
  void complete(ImageAsset compressedAsset) {
    status = Status.completed;
    compressed = compressedAsset;
  }
}
