import 'dart:ui';

import 'package:flutter/material.dart';

/// Blur background widget
class BlurBackground extends StatelessWidget {
  /// Constructor
  const BlurBackground({
    super.key,
    this.strength = 20.0,
  });

  /// Strength of the blur
  final double strength;
  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: strength, sigmaY: strength),
        child: Container(
          color: Colors.transparent,
        ),
      ),
    );
  }
}
