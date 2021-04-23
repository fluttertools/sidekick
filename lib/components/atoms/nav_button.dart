import 'package:flutter/material.dart';

// ignore: non_constant_identifier_names
NavigationRailDestination NavButton(BuildContext context,
    {IconData iconData, String label}) {
  return NavigationRailDestination(
    icon: Icon(iconData, size: 20),
    selectedIcon: Icon(
      iconData,
      size: 20,
      color: Theme.of(context).accentColor,
    ),
    label: Text(label),
  );
}
