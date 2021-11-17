import 'package:flutter/material.dart' hide Notification;
import 'package:ummobile/modules/app_bar/modules/notifications/views/widgets/notification_tile.dart';
import 'package:ummobile_sdk/ummobile_sdk.dart';

class NotificationAnimatedList {
  /// The global key for the animated list
  static final GlobalKey<AnimatedListState> notificationsListKey =
      GlobalKey<AnimatedListState>();

  /// Ads an item at the position [index]
  void addItem(int index) {
    if (notificationsListKey.currentState != null)
      notificationsListKey.currentState!.insertItem(index);
  }

  /// Removes an item at the position [index]
  ///
  /// The content of the animation is based by [notificationRemoved]
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
