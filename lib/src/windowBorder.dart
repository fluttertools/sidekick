import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';

const sidebarColor = Color(0xFFF6A00C);

class LeftSide extends StatelessWidget {
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
  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Container(
            decoration: BoxDecoration(
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
                WindowButtons()
              ])),
            ])));
  }
}

class WindowButtons extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final buttonColors = WindowButtonColors(
        iconNormal: Theme.of(context).brightness == Brightness.dark
            ? Colors.white
            : Colors.black,
        mouseOver: Theme.of(context).brightness == Brightness.dark
            ? Colors.white
            : Colors.grey.shade300,
        mouseDown: Theme.of(context).brightness == Brightness.dark
            ? Colors.white
            : Colors.grey.shade400,
        iconMouseOver: Theme.of(context).brightness == Brightness.dark
            ? Colors.white
            : Colors.black,
        iconMouseDown: Theme.of(context).brightness == Brightness.dark
            ? Colors.white
            : Colors.black);

    final closeButtonColors = WindowButtonColors(
        mouseOver: Color(0xFFD32F2F),
        mouseDown: Color(0xFFB71C1C),
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
