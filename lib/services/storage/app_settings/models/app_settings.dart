import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppSettings {
  ThemeMode themeMode;
  Locale? language;

  AppSettings({
    required this.themeMode,
    required this.language,
  });

  static final supportedLocales = [
    Locale('es', 'MX'),
    Locale('en'),
  ];

  static ThemeMode _stringToThemeMode(String val) {
    switch (val) {
      case "light":
        return ThemeMode.light;
      case "dark":
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }

  static String themeModeToString(ThemeMode themeMode) {
    switch (themeMode) {
      case ThemeMode.light:
        return "light";
      case ThemeMode.dark:
        return "dark";
      case ThemeMode.system:
        return "system";
    }
  }

  factory AppSettings.fromStorage(
    String? theme,
    int? language,
  ) =>
      AppSettings(
        themeMode: _stringToThemeMode(theme ?? "system"),
        language:
            (language != null) ? supportedLocales[language] : Get.deviceLocale,
      );
}
