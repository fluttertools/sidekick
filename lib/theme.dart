import 'package:flutter/material.dart';

/// Dark theme
ThemeData darkTheme() {
  return ThemeData(
    brightness: Brightness.dark,
    primarySwatch: Colors.cyan,
    accentColor: Colors.cyan,
    // cardColor: const Color(0xFF0E0E0E),
    // scaffoldBackgroundColor: const Color(0xFF111111),
    dividerColor: Colors.white10,
    popupMenuTheme: const PopupMenuThemeData(color: Colors.black),
    appBarTheme: const AppBarTheme(
      elevation: 0,
      // color: Colors.black,
    ),
    // cardTheme: const CardTheme(shape: RoundedRectangleBorder()),
    // dialogTheme: DialogTheme(
    //   elevation: 10,
    //   shape: Border.all(color: Colors.white24),
    //   backgroundColor: Colors.black87,
    // ),
  ).copyWith(
    visualDensity: VisualDensity.adaptivePlatformDensity,
  );
}

ThemeData lightTheme() {
  return ThemeData(
    brightness: Brightness.light,
    primarySwatch: Colors.cyan,
    accentColor: Colors.cyan,
    dividerColor: Colors.black12,
    appBarTheme: const AppBarTheme(
      elevation: 0,
      color: Color(0xFFF5F5F5),
    ),
    // cardColor: const Color(0xFF222222),

    // scaffoldBackgroundColor: const Color(0xFF0E0E0E),
  ).copyWith(
    visualDensity: VisualDensity.adaptivePlatformDensity,
  );
}
