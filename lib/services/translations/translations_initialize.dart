import 'dart:convert';

import 'package:flutter/services.dart';

class FlutterTranslations {
  static Map<String, String>? en;
  static Map<String, String>? es;

  static Future<void> initialize() async {
    print("Fetching translations");
    en = Map<String, String>.from(json
        .decode(await rootBundle.loadString('assets/translations/en.json')));
    es = Map<String, String>.from(json
        .decode(await rootBundle.loadString('assets/translations/es.json')));
  }
}
