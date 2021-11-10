import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart';
import 'package:get/get.dart';

import 'image_dialog.dart';

/// * Runs the post action depending on the url provided by the service
actionPost(String url, String imagePath, BuildContext context) async {
  if (url.isEmpty) return;
  if (url == "#" && imagePath.isNotEmpty) {
    Get.dialog(
      ImageDialog(imagePath: imagePath),
      barrierDismissible: true,
    );
  } else if (url.contains("http")) {
    await launch(
      url,
      customTabsOption: CustomTabsOption(
        toolbarColor: Theme.of(context).colorScheme.secondary,
        enableDefaultShare: true,
        enableUrlBarHiding: true,
        showPageTitle: true,
        extraCustomTabs: const <String>[
          // ref. https://play.google.com/store/apps/details?id=org.mozilla.firefox
          'org.mozilla.firefox',
          // ref. https://play.google.com/store/apps/details?id=com.microsoft.emmx
          'com.microsoft.emmx',
        ],
      ),
    );
  } else {
    await launch(
      "https://conectate.um.edu.mx/articulo/" + url,
      customTabsOption: CustomTabsOption(
        toolbarColor: Theme.of(context).primaryColor,
        enableDefaultShare: true,
        enableUrlBarHiding: true,
        showPageTitle: true,
        extraCustomTabs: const <String>[
          'org.mozilla.firefox',
          'com.microsoft.emmx',
        ],
      ),
    );
  }
}
