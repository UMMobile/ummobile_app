import 'package:flutter/material.dart';
import 'package:get/get.dart';
//import 'package:ummobile/modules/tabs/controllers/navigation_controller.dart';

import 'package:ummobile/modules/app_bar/views/appBar.dart';

import 'subpages/permissions/page_permissions.dart';
import 'subpages/vacations/page_vacations.dart';

class FormsPage extends StatefulWidget {
  FormsPage({
    Key? key,
  }) : super(key: key);

  @override
  _FormsPageState createState() => _FormsPageState();
}

class _FormsPageState extends State<FormsPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: UmAppBar(
        title: 'forms'.tr.capitalizeFirst!,
      ),
      body: ListView(
        children: [
          Card(
            child: ListTile(
              leading: Icon(Icons.beach_access_rounded),
              title: Text('vacations'.tr.capitalizeFirst!),
              trailing: Icon(Icons.navigate_next_rounded),
              onTap: () => Get.to(VacationsPage()),
            ),
          ),
          Card(
            child: ListTile(
              leading: Icon(Icons.wallet_travel_rounded),
              title: Text('permissions'.tr.capitalizeFirst!),
              trailing: Icon(Icons.navigate_next_rounded),
              onTap: () => Get.to(PermissionsPage()),
            ),
          ),
        ],
      ),
    );
  }
}
