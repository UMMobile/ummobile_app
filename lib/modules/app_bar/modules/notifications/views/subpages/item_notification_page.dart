import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ummobile/modules/app_bar/modules/notifications/controllers/notifications_controller.dart';
import 'package:ummobile/modules/app_bar/views/appBar.dart';

import 'widgets/content_item_notification.dart';

/// Page widget showing the single notification content
class ItemNotificationPage extends StatelessWidget {
  /// The id of the Onesignal notification
  final String notificationId;

  const ItemNotificationPage({
    Key? key,
    required this.notificationId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: UmAppBar(
        title: 'notifications'.tr.capitalizeFirst!,
        showActionIcons: false,
      ),
      body: ContentItemNotification(
        notification: Get.find<NotificationsController>().read(notificationId),
      ),
    );
  }
}
