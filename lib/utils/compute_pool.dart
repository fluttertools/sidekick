import 'dart:async';
import 'dart:io';

import 'package:pool/pool.dart';

typedef ComputeFn<T> = FutureOr<T> Function();

final pool = Pool(
  Platform.numberOfProcessors,
  timeout: const Duration(seconds: 30),
);

/// Simple pool to manage compute
class ComputePool {
  ComputePool._();

  static Future<T> run<T>(ComputeFn<T> fn) {
    return pool.withResource(fn);
  }
}
