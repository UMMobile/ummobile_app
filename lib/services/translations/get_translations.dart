import 'package:get/get.dart';
import 'package:ummobile/services/translations/translations_initialize.dart';

class Messages extends Translations {
  @override
  Map<String, Map<String, String>> get keys =>
      {"en": FlutterTranslations.en!, "es_MX": FlutterTranslations.es!};
}
