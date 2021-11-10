import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ummobile/modules/app_bar/views/appBar.dart';

import 'page_permissions.dart';

class PermissionInfoPage extends StatelessWidget {
  final Permission permision;

  PermissionInfoPage({required this.permision});

  @override
  Widget build(BuildContext context) {
    final String pageName = 'information_male'.trParams({
      'element': 'permission'.tr,
    }).capitalizeFirst!;
    return Scaffold(
      appBar: UmAppBar(
        title: pageName,
        showActionIcons: false,
      ),
      body: Container(
          child: ListView(
        children: [
          Text(pageName),
          Wrap(
            children: [
              Text(permision.start.toString()),
              Text(permision.end.toString()),
            ],
          )
        ],
      )),
    );
  }
}
