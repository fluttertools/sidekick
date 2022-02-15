import 'dart:async';

import 'package:flutter/foundation.dart';

class Debouncer {
  Debouncer(this.duration);

  final Duration duration;
  Timer? _timer;

  // Can cancel programatically
  void cancel() {
    _timer?.cancel();
  }

  void run(VoidCallback action) {
    _timer?.cancel();
    _timer = Timer(duration, action);
  }
}

class Throttle {
  final int milliseconds;

  Timer? _timer;
  Throttle({
    required this.milliseconds,
  });

  void run(VoidCallback action) {
    final timer = _timer;
    if (timer != null && timer.isActive) return;
    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }
}
