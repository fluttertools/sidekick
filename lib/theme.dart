import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

ThemeData darkPurpleTheme() {
  return customDarkTheme(
    cardColor: const Color(0xFF180D2F),
    scaffoldBackgroundColor: const Color(0xFF0F0823),
    primarySwatch: Colors.deepOrange,
    accentColor: Colors.deepOrangeAccent,
  );
}

ThemeData darkBlueTheme() {
  return customDarkTheme(
    cardColor: const Color(0xFF092045),
    scaffoldBackgroundColor: const Color(0xFF081231),
    primarySwatch: Colors.cyan,
    accentColor: Colors.cyan,
  );
}

ThemeData darkTheme() {
  return customDarkTheme(
    cardColor: const Color(0xFF2B2D2F),
    scaffoldBackgroundColor: const Color(0xFF1D1E1F),
    primarySwatch: Colors.cyan,
    accentColor: Colors.cyan,
  );
}

/// Dark theme
ThemeData customDarkTheme({
  Color cardColor,
  Color scaffoldBackgroundColor,
  Color primarySwatch,
  Color accentColor,
}) {
  return ThemeData(
    textTheme: GoogleFonts.ibmPlexSansTextTheme(ThemeData.dark().textTheme),
    brightness: Brightness.dark,
    primarySwatch: primarySwatch,
    cardColor: cardColor,
    scaffoldBackgroundColor: scaffoldBackgroundColor,
    accentColor: accentColor,
    dividerColor: Colors.white10,
    popupMenuTheme: const PopupMenuThemeData(color: Colors.black),
    appBarTheme: const AppBarTheme(
      elevation: 0,
      color: Colors.black54,
    ),
    chipTheme: ThemeData.dark().chipTheme.copyWith(
          backgroundColor: Colors.black12,
        ),
  ).copyWith(
    visualDensity: VisualDensity.adaptivePlatformDensity,
  );
}

ThemeData get lightTheme {
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
