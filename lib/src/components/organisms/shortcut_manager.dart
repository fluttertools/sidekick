import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sidekick/src/modules/navigation/navigation.provider.dart';

/// Navigation intent
class NavigationIntent extends Intent {
  /// Constructor
  const NavigationIntent({
    this.route,
  });

  /// Navigation route
  final NavigationRoutes route;
}

/// Shorcut manager
class SkShortcutManager extends StatelessWidget {
  /// Constructor
  const SkShortcutManager({
    Key key,
    this.child,
    @required this.focusNode,
  }) : super(key: key);

  /// Child
  final Widget child;
  final FocusNode focusNode;
  @override
  Widget build(BuildContext context) {
    // Handles route change
    void handleRouteChange(NavigationRoutes route) {
      context.read(navigationProvider.notifier).goTo(route);
    }

    return FocusableActionDetector(
      autofocus: true,
      shortcuts: <LogicalKeySet, Intent>{
        LogicalKeySet(
          LogicalKeyboardKey.metaLeft,
          LogicalKeyboardKey.digit1,
        ): const NavigationIntent(route: NavigationRoutes.homeScreen),
        LogicalKeySet(
          LogicalKeyboardKey.metaLeft,
          LogicalKeyboardKey.digit2,
        ): const NavigationIntent(route: NavigationRoutes.projectsScreen),
        LogicalKeySet(
          LogicalKeyboardKey.metaLeft,
          LogicalKeyboardKey.digit3,
        ): const NavigationIntent(route: NavigationRoutes.exploreScreen),
        LogicalKeySet(
          LogicalKeyboardKey.metaLeft,
          LogicalKeyboardKey.keyF,
        ): const NavigationIntent(route: NavigationRoutes.searchScreen),
      },
      actions: <Type, Action<Intent>>{
        NavigationIntent: CallbackAction<NavigationIntent>(
            onInvoke: (intent) => handleRouteChange(intent.route)),
      },
      child: child,
    );
  }
}
