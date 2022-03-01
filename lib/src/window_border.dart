import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';

const sidebarColor = Color(0xFFF6A00C);

class LeftSide extends StatelessWidget {
  const LeftSide({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: 200,
        child: Container(
            color: sidebarColor,
            child: Column(
              children: [
                WindowTitleBarBox(child: MoveWindow()),
                Expanded(child: Container())
              ],
            )));
  }
}

const backgroundStartColor = Color(0xFFFFD500);
const backgroundEndColor = Color(0xFFF6A00C);

class RightSide extends StatelessWidget {
  const RightSide({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [backgroundStartColor, backgroundEndColor],
                  stops: [0.0, 1.0]),
            ),
            child: Column(children: [
              WindowTitleBarBox(
                  child: Row(children: [
                Expanded(child: MoveWindow()),
                const WindowButtons()
              ])),
            ])));
  }
}

class WindowButtons extends StatelessWidget {
  const WindowButtons({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final buttonColors = WindowButtonColors(
        iconNormal: Theme.of(context).brightness == Brightness.dark
            ? Colors.white
            : Colors.black,
        mouseOver: Theme.of(context).brightness == Brightness.dark
            ? Colors.grey.shade600
            : Colors.grey.shade300,
        mouseDown: Theme.of(context).brightness == Brightness.dark
            ? Colors.grey.shade700
            : Colors.grey.shade400,
        iconMouseOver: Theme.of(context).brightness == Brightness.dark
            ? Colors.white
            : Colors.black,
        iconMouseDown: Theme.of(context).brightness == Brightness.dark
            ? Colors.white
            : Colors.black);

    final closeButtonColors = WindowButtonColors(
        mouseOver: const Color(0xFFD32F2F),
        mouseDown: const Color(0xFFB71C1C),
        iconNormal: Theme.of(context).brightness == Brightness.dark
            ? Colors.white
            : Colors.black,
        iconMouseOver: Colors.white);
    return Row(
      children: [
        MinimizeWindowButton(colors: buttonColors),
        MaximizeWindowButton(colors: buttonColors),
        CloseWindowButton(colors: closeButtonColors),
      ],
    );
  }
}
