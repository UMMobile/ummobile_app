import 'package:flutter/material.dart';

class UserSettings {
  ThemeMode themeMode;
  Locale? language;

  UserSettings({
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

  String _themeModeToString(ThemeMode themeMode) {
    switch (themeMode) {
      case ThemeMode.light:
        return "light";
      case ThemeMode.dark:
        return "dark";
      case ThemeMode.system:
        return "system";
    }
  }

  factory UserSettings.fromJson(Map<String, dynamic> json) => UserSettings(
        themeMode: _stringToThemeMode(json["themeMode"] ?? "system"),
        language: (json["language"] != null)
            ? supportedLocales[json["language"]]
            : null,
      );

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {
      "themeMode": _themeModeToString(themeMode),
    };
    if (language != null) {
      json["language"] = supportedLocales.indexOf(language!);
    }

    return json;
  }
}
