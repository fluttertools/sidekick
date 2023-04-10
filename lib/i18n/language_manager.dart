import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class LanguageManager {
  factory LanguageManager() {
    return _languageManager;
  }

  LanguageManager._internal();

  static final LanguageManager _languageManager = LanguageManager._internal();

  final List<Locale> _supportedLanguagesCodes = [
    const Locale('en', 'US'),
    const Locale('en', 'GB'),
    const Locale('ar', 'SA'),
    const Locale('bn', 'BD'),
    const Locale('de', 'DE'),
    const Locale('es', 'ES'),
    const Locale('sv', 'SE'),
    const Locale('zh', 'CN'),
    const Locale('zh', 'TW'),
    const Locale('ko', 'KR'),
    const Locale('ja', 'JP'),
    const Locale('pl', 'PL'),
    const Locale('pt', 'BR'),
    const Locale('it', 'IT'),
    const Locale('uk', 'UA'),
    const Locale('uz', 'LA'),
    const Locale('uz', 'CY'),
    const Locale('ru', 'RU'),
    const Locale('hi', 'IN'),
    const Locale('id', 'ID'),
    const Locale('fr', 'FR'),
    const Locale('tr', 'TR'),
  ];

  List<String> getListOfLocalesAsString() {
    return List<String>.generate(
        languageManager._supportedLanguagesCodes.length,
        (i) =>
            languageManager._supportedLanguagesCodes[i].languageCode.toLowerCase() +
            '_' +
            languageManager._supportedLanguagesCodes[i].countryCode!.toUpperCase());
  }

  String formatter(Object value, String? format, Locale locale) {
    switch (format) {
      case 'uppercase':
        return value.toString().toUpperCase();
      case 'lowercase':
        return value.toString().toLowerCase();
      default:
        if (value is DateTime) {
          return DateFormat(format, locale.toString()).format(value);
        }
    }
    return value.toString();
  }

  Iterable<Locale> get supportedLocales => _supportedLanguagesCodes.map<Locale>((language) => language);
}

LanguageManager languageManager = LanguageManager();
