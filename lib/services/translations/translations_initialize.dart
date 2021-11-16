import 'dart:convert';

import 'package:flutter/services.dart';

/// An initializator used to retrieve all translated content inside
/// the application
class FlutterTranslations {
  /// The map that contains the app content in english
  static Map<String, String>? en;

  /// The map that contains the app content in spanish
  static Map<String, String>? es;

  /// Fetches the json translations assets and initialize its content
  /// in maps
  static Future<void> initialize() async {
    print("Fetching translations");
    en = Map<String, String>.from(json
        .decode(await rootBundle.loadString('assets/translations/en.json')));
    es = Map<String, String>.from(json
        .decode(await rootBundle.loadString('assets/translations/es.json')));
  }
}
