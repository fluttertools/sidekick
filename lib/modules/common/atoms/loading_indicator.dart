import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

/// Sidekick loading indicator
class SkLoadingIndicator extends StatelessWidget {
  /// Constructor
  const SkLoadingIndicator({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const SpinKitFadingCube(
      color: Colors.white24,
      size: 50.0,
    );
  }
}
