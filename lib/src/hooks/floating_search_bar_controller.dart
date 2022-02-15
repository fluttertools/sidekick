import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';

FloatingSearchBarController useFloatingSearchBarController() =>
    use(const _FloatingSearchBarControllerHook());

class _FloatingSearchBarControllerHook
    extends Hook<FloatingSearchBarController> {
  const _FloatingSearchBarControllerHook([
    List<Object> keys = const [],
  ]) : super(keys: keys);

  @override
  _FloatingSearchBarControllerHookState createState() {
    return _FloatingSearchBarControllerHookState();
  }
}

class _FloatingSearchBarControllerHookState extends HookState<
    FloatingSearchBarController, _FloatingSearchBarControllerHook> {
  late FloatingSearchBarController _controller;

  @override
  void initHook() {
    _controller = FloatingSearchBarController();
  }

  @override
  FloatingSearchBarController build(_) => _controller;

  @override
  void dispose() => _controller.dispose();
}
