import 'package:flutter/widgets.dart';

/// Based on the PageTransitionSwitcher from the animations package, this widget
/// allows you to transition between an array of widgets using entry and exit
/// animations whilst maintaining their state.
class IndexedTransitionSwitcher extends StatefulWidget {
  /// Creates an [IndexedTransitionSwitcher].
  const IndexedTransitionSwitcher(
      {required this.index,
      required this.children,
      required this.transitionBuilder,
      this.reverse = false,
      this.duration = const Duration(milliseconds: 300),
      Key? key})
      : super(key: key);

  /// The index of the child to show.
  final int index;

  /// The widgets to switch between.
  final List<Widget> children;

  /// A function to wrap the child in primary and secondary animations.
  ///
  /// When the index changes, the new child will animate in with the primary
  /// animation, and the old widget will animate out with the secondary
  /// animation.
  final Widget Function(Widget child, Animation<double> primaryAnimation,
      Animation<double> secondaryAnimation) transitionBuilder;

  /// The duration of the transition.
  final Duration duration;

  /// Whether or not the transition should be reversed.
  ///
  /// If true, the new child will animate in behind the oWld child with the
  /// secondary animation running in reverse, whilst the old child animates
  /// out with the primary animation playing in reverse.
  final bool reverse;

  @override
  State<IndexedTransitionSwitcher> createState() =>
      _IndexedTransitionSwitcherState();
}

class _IndexedTransitionSwitcherState extends State<IndexedTransitionSwitcher>
    with TickerProviderStateMixin {
  List<_ChildEntry> _childEntries = [];

  @override
  void initState() {
    super.initState();
    // Create the page entries
    _childEntries = widget.children
        .asMap()
        .entries
        .map((entry) => _createPageEntry(entry.key, entry.value))
        .toList();
  }

  @override
  void didUpdateWidget(IndexedTransitionSwitcher oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Transition if the index has changed
    if (widget.index != oldWidget.index) {
      var newChild =
          _childEntries.where((entry) => entry.index == widget.index).first;
      var oldChild =
          _childEntries.where((entry) => entry.index == oldWidget.index).first;
      // Animate the children
      if (widget.reverse) {
        // Animate in the new child
        newChild.primaryController.value = 1;
        newChild.secondaryController.reverse(from: 1);
        // Animate out the old child and unstage it when the animation is complete
        oldChild.secondaryController.value = 0;
        oldChild.primaryController
            .reverse(from: 0)
            .then((value) => setState(() {
                  oldChild.onStage = false;
                  oldChild.primaryController.reset();
                  oldChild.secondaryController.reset();
                }));
      } else {
        // Animate in the new child
        newChild.secondaryController.value = 0;
        newChild.primaryController.forward(from: 0);
        // Animate out the old child and unstage it when the animation is complete
        oldChild.primaryController.value = 1;
        oldChild.secondaryController.forward().then((value) => setState(() {
              oldChild.onStage = false;
              oldChild.primaryController.reset();
              oldChild.secondaryController.reset();
            }));
      }
      // Reorder the stack and set onStage to true for the new child
      _childEntries.remove(newChild);
      _childEntries.remove(oldChild);
      _childEntries
          .addAll(widget.reverse ? [newChild, oldChild] : [oldChild, newChild]);
      newChild.onStage = true;
    }
  }

  _ChildEntry _createPageEntry(int index, Widget child) {
    // Prepare the animation controllers
    final primaryController = AnimationController(
      value: widget.index == index ? 1.0 : 0,
      duration: widget.duration,
      vsync: this,
    );
    final secondaryController = AnimationController(
      duration: widget.duration,
      vsync: this,
    );
    // Create the page entry
    return _ChildEntry(
        key: UniqueKey(),
        index: index,
        primaryController: primaryController,
        secondaryController: secondaryController,
        transitionChild: widget.transitionBuilder(
            child, primaryController, secondaryController),
        onStage: widget.index == index);
  }

  @override
  void dispose() {
    // Dispose of the animation controllers
    for (var entry in _childEntries) {
      entry.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Stack(
        alignment: Alignment.center,
        fit: StackFit.expand,
        children: _childEntries
            .map<Widget>((entry) => Offstage(
                  key: entry.key,
                  offstage: !entry.onStage,
                  child: entry.transitionChild,
                ))
            .toList(),
      );
}

/// Internal representation of a child.
class _ChildEntry {
  _ChildEntry({
    required this.index,
    required this.key,
    required this.primaryController,
    required this.secondaryController,
    required this.transitionChild,
    required this.onStage,
  });

  /// The child index.
  final int index;

  /// The key to maintain widget state when moving in the tree.
  final Key key;

  /// The entry animation controller.
  final AnimationController primaryController;

  /// The exit animation controller.
  final AnimationController secondaryController;

  /// The child widget wrapped in the transition.
  final Widget transitionChild;

  /// Whether or not the child should be rendered.
  bool onStage;

  /// Dispose of the animation controllers
  void dispose() {
    primaryController.dispose();
    secondaryController.dispose();
  }
}
