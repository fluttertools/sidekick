import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

/// Sliver section
class SliverSection extends StatelessWidget {
  /// Constructor
  const SliverSection({
    super.key,
    required this.slivers,
    this.shouldDisplay = false,
  });

  /// Slivers
  final List<Widget> slivers;

  /// Should display
  final bool shouldDisplay;
  @override
  Widget build(BuildContext context) {
    if (!shouldDisplay) {
      return SliverToBoxAdapter(
        child: Container(),
      );
    }
    return SliverToBoxAdapter(
      child: ShrinkWrappingViewport(
        offset: ViewportOffset.zero(),
        slivers: slivers,
      ),
    );
  }
}
