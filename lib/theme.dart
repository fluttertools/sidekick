import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

ThemeData get darkPurpleTheme {
  return _customThemeBuilder(
    cardColor: const Color(0xFF180D2F),
    scaffoldBackgroundColor: const Color(0xFF0F0823),
    primarySwatch: Colors.deepOrange,
    accentColor: Colors.deepOrangeAccent,
  );
}

ThemeData get darkBlueThemea {
  return _customThemeBuilder(
    cardColor: const Color(0xFF092045),
    scaffoldBackgroundColor: const Color(0xFF081231),
    primarySwatch: Colors.cyan,
    accentColor: Colors.cyan,
  );
}

ThemeData get darkTheme {
  return _customThemeBuilder(
    cardColor: const Color(0xFF2B2D2F),
    scaffoldBackgroundColor: const Color(0xFF1D1E1F),
    primarySwatch: Colors.cyan,
    accentColor: Colors.cyan,
  );
}

ThemeData get lightTheme {
  return _customThemeBuilder(
    cardColor: const Color(0xFF092045),
    scaffoldBackgroundColor: const Color(0xFF081231),
    primarySwatch: Colors.cyan,
    accentColor: Colors.cyan,
  );
}

/// Dark theme
ThemeData _customThemeBuilder({
  Color cardColor,
  Color scaffoldBackgroundColor,
  Color primarySwatch,
  Color accentColor,
  Brightness brightness = Brightness.dark,
}) {
  ThemeData baseTheme;
  if (brightness == Brightness.dark) {
    baseTheme = ThemeData.dark();
  } else {
    baseTheme = ThemeData.light();
  }
  return ThemeData(
    textTheme: GoogleFonts.ibmPlexSansTextTheme(baseTheme.textTheme),
    brightness: brightness,
    primarySwatch: primarySwatch,
    cardColor: cardColor,
    scaffoldBackgroundColor: scaffoldBackgroundColor,
    accentColor: accentColor,
    dividerColor: Colors.white10,
    toggleableActiveColor: accentColor,
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        primary: Colors.grey,
        backgroundColor: Colors.grey[850],
        side: BorderSide(
          color: Colors.grey[800],
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        tapTargetSize: MaterialTapTargetSize.padded,
        padding: const EdgeInsets.symmetric(horizontal: 20),
      ),
    ),
    popupMenuTheme: PopupMenuThemeData(
      shape: _roundedShape,
    ),
    dialogTheme: DialogTheme(
      shape: _roundedShape,
      backgroundColor: scaffoldBackgroundColor,
      titleTextStyle: const TextStyle(fontSize: 16),
      contentTextStyle: const TextStyle(
        fontSize: 12,
      ),
    ),
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

RoundedRectangleBorder get _roundedShape {
  return RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(10.0),
  );
}

Color platformBackgroundColor(BuildContext context) {
  if (Platform.isMacOS) {
    return Colors.transparent;
  } else {
    return Theme.of(context).cardColor;
  }
}
