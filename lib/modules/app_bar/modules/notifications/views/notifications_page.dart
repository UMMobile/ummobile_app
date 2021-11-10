import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ummobile/modules/app_bar/modules/notifications/controllers/notifications_controller.dart';
import 'package:ummobile/modules/app_bar/views/appBar.dart';
import 'package:ummobile/statics/widgets/overlays/dialog_overlay.dart';
import 'package:ummobile/statics/widgets/shimmers.dart';

import 'widgets/list_notifications.dart';

class NotificationsPage extends GetView<NotificationsController> {
  NotificationsPage({Key? key}) : super(key: key);
  final NotificationsController _notificationsController =
      Get.put(NotificationsController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: UmAppBar(
        title: 'notifications'.tr.capitalizeFirst!,
        customActions: <Widget>[
          IconButton(
            icon: Icon(Icons.delete_sweep),
            onPressed: () => openDialogWindow(
              title: "delete_all_notifications".tr,
              message: "irreversible_action".tr,
              onCancel: () => Get.back(),
              onConfirm: () {
                _notificationsController.removeAll();
                Get.back();
              },
            ),
          ),
        ],
      ),
      body: controller.obx(
        (state) => Obx(
          () => RefreshIndicator(
            child: ListNotifications(
              notifications: _notificationsController.itemsSorted,
            ),
            onRefresh: () async {
              await _notificationsController.refresh();
            },
          ),
        ),
        onLoading: _ShimmerNotifications(),
        onEmpty: RefreshIndicator(
          child: Container(
            padding: EdgeInsets.all(20),
            width: double.infinity,
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: [
                Text(
                  'empty_notifications'.tr.capitalizeFirst!,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ),
          onRefresh: () async {
            await _notificationsController.refresh();
          },
        ),
        onError: (e) => controller.internetPage(e),
      ),
    );
  }
}

class _ShimmerNotifications extends StatelessWidget {
  const _ShimmerNotifications({Key? key}) : super(key: key);

  List<Widget> _shimmerchildren() {
    List<Widget> list = List.empty(growable: true);

    for (int i = 0; i < 10; i++) {
      bool readed = false;
      if (i < 5) {
        readed = true;
      }
      list.add(
        ListTile(
          minLeadingWidth: 20,
          leading: (readed)
              ? Container(
                  height: double.infinity,
                  margin: EdgeInsets.symmetric(vertical: 20),
                  child: RoundShimmer(size: 14),
                )
              : null,
          title: RectShimmer(height: 18),
          subtitle: RectShimmer(height: 14),
          trailing: Container(
            height: double.infinity,
            margin: EdgeInsets.symmetric(vertical: 15),
            child: RectShimmer(
              height: 20,
              width: 25,
            ),
          ),
        ),
      );
    }

    return list;
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: NeverScrollableScrollPhysics(),
      children: _shimmerchildren(),
    );
  }
}
