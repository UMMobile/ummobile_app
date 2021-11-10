import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:get/get_utils/src/extensions/string_extensions.dart';

String boolToString(bool value) {
  return value ? "yes".tr.capitalizeFirst! : "no".tr.capitalizeFirst!;
}
