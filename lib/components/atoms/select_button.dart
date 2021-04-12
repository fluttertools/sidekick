import 'package:flutter/material.dart';

class SelectButton extends StatelessWidget {
  final String label;
  final Function() onPressed;
  final bool selected;
  const SelectButton({
    this.label,
    this.onPressed,
    this.selected,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).elevatedButtonTheme.style;

    return InkWell(
      onTap: onPressed,
      child: Container(
        color: Theme.of(context).accentColor,
        padding: const EdgeInsets.all(10),
        child: Text(label),
      ),
    );
  }
}
