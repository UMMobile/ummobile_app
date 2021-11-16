import 'package:get/get.dart';
import 'package:ummobile/services/translations/translations_initialize.dart';

/// A class that conatains all the keys for the available langauages in
/// the application
class Messages extends Translations {
  /// Sets the app available languages and defines their content by maps
  @override
  Map<String, Map<String, String>> get keys => {
        "en": FlutterTranslations.en!,
        "es_MX": FlutterTranslations.es!,
      };
}
