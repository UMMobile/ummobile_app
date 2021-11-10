import 'package:flutter/material.dart' hide Notification;
import 'package:ummobile/modules/app_bar/modules/notifications/views/widgets/notification_tile.dart';
import 'package:ummobile_sdk/ummobile_sdk.dart';

class NotificationAnimatedList {
  static final GlobalKey<AnimatedListState> notificationsListKey =
      GlobalKey<AnimatedListState>();

  void addItem(int index) {
    if (notificationsListKey.currentState != null)
      notificationsListKey.currentState!.insertItem(index);
  }

  void removeItem({
    required int index,
    Notification? notificationRemoved,
  }) {
    if (notificationsListKey.currentState != null)
      notificationsListKey.currentState!.removeItem(
        index,
        (context, animation) => (notificationRemoved != null)
            ? NotificationTile(
                notification: notificationRemoved,
                animation: animation,
              )
            : Container(),
      );
  }
}
