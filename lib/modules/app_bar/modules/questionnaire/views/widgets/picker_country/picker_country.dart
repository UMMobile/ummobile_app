import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ummobile_sdk/ummobile_sdk.dart';

import 'content_picker_country.dart';

void showCountryPicker({
  required ValueChanged<Country> onSelect,
}) {
  Get.bottomSheet(
      CountryListView(
        onSelect: onSelect,
      ),
      backgroundColor: Get.theme.scaffoldBackgroundColor,
      isDismissible: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20), topRight: Radius.circular(20)),
      ));
}
