import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:ummobile/modules/drawer/controllers/drawer.dart';
import 'package:ummobile/modules/drawer/views/drawer.dart';
import 'package:ummobile/modules/tabs/controllers/navigation_controller.dart';
import 'package:ummobile/statics/widgets/overlays/dialog_overlay.dart';

import '../models/page_tab_view.dart';

class TabsView extends StatefulWidget {
  final List<PageTabView> views;

  TabsView({Key? key, required this.views}) : super(key: key);

  @override
  _TabsViewState createState() => _TabsViewState();
}

class _TabsViewState extends State<TabsView>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    Get.put<NavigationController>(
        NavigationController(tabs: widget.views, ticker: this));
    super.initState();
  }

  @override
  void dispose() {
    Get.delete<NavigationController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetX<NavigationController>(builder: (_) {
      return WillPopScope(
        child: Scaffold(
          key: _.drawerKey,
          drawer: UmDrawer(),
          body: TabBarView(
            controller: _.tabController,
            physics: NeverScrollableScrollPhysics(),
            children: _.mainTabs,
          ),
          bottomNavigationBar: BottomNavigationBar(
            items: _.bottomNavigationBarRootItems,
            currentIndex: _.selectedIndex.value,
            type: BottomNavigationBarType.fixed,
            selectedItemColor: Get.theme.colorScheme.secondary,
            showSelectedLabels: false,
            showUnselectedLabels: false,
            onTap: _.onItemTapped,
          ),
        ),
        onWillPop: () async {
          if (Get.find<UmDrawerController>().isOpen) {
            Get.back();
            return false;
          } else if (Navigator.of(_.navStack[_.tabController.index]!)
              .canPop()) {
            Navigator.of(_.navStack[_.tabController.index]!).pop();
            _.changeStatus(_.tabController.index, null);
            return false;
          } else {
            if (_.tabController.index == 0) {
              _.changeStatus(_.tabController.index, 0);
              openDialogWindow(
                title: "warning".tr.capitalizeFirst!,
                message: "exit_application".tr,
                onCancel: () => Get.back(),
                onConfirm: () =>
                    SystemChannels.platform.invokeMethod('SystemNavigator.pop'),
              ); // close the app // close the app
              return true;
            } else {
              _.onItemTapped(0);
              return false;
            }
          }
        },
      );
    });
  }
}
