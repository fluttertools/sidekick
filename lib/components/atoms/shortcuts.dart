import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sidekick/providers/navigation_provider.dart';

class NavigationIntent extends Intent {
  final NavigationRoutes route;
  const NavigationIntent({this.route});
}

class KBShortcutManager extends HookWidget {
  final Widget child;

  const KBShortcutManager({
    Key key,
    this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final focusNode = useFocusNode();
    // Handles route change
    void handleRouteChange(NavigationRoutes route) {
      context.read(navigationProvider.notifier).goTo(route);
    }

    return Shortcuts(
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
          LogicalKeyboardKey.digit4,
        ): const NavigationIntent(route: NavigationRoutes.packagesScreen),
        LogicalKeySet(
          LogicalKeyboardKey.metaLeft,
          LogicalKeyboardKey.keyF,
        ): const NavigationIntent(route: NavigationRoutes.searchScreen),
      },
      child: Actions(
        actions: <Type, Action<Intent>>{
          NavigationIntent: CallbackAction<NavigationIntent>(
              onInvoke: (intent) => handleRouteChange(intent.route)),
        },
        child: Focus(
          autofocus: true,
          focusNode: focusNode,
          child: child,
        ),
      ),
    );
  }
}
