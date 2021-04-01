import 'package:flutter/material.dart';

ThemeMode getThemeMode(String raw) {
  if (raw == "light") {
    return ThemeMode.light;
  } else if (raw == "dark") {
    return ThemeMode.dark;
  } else {
    return ThemeMode.system;
  }
}
