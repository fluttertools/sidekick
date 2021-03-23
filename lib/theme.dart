import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Dark theme
ThemeData darkTheme() {
  return ThemeData(
    textTheme: GoogleFonts.ibmPlexSansTextTheme(ThemeData.dark().textTheme),
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
    textTheme: GoogleFonts.ibmPlexSansTextTheme(ThemeData.light().textTheme),
    brightness: Brightness.light,
    primarySwatch: Colors.cyan,
    accentColor: Colors.cyan,
    dividerColor: Colors.black12,
    appBarTheme: const AppBarTheme(
      elevation: 0,
      color: Colors.white,
    ),
    // cardColor: const Color(0xFF222222),

    // scaffoldBackgroundColor: const Color(0xFF0E0E0E),
  ).copyWith(
    visualDensity: VisualDensity.adaptivePlatformDensity,
  );
}
