import 'package:flutter/material.dart' hide Notification;
import 'package:ummobile/modules/app_bar/modules/notifications/utils/animated_list_actions.dart';
import 'package:ummobile_sdk/ummobile_sdk.dart';

import 'notification_tile.dart';

class ListNotifications extends StatefulWidget {
  final List<Notification> notifications;

  const ListNotifications({Key? key, required this.notifications})
      : super(
          key: key,
        );

  @override
  _ListNotificationsState createState() => _ListNotificationsState();
}

class _ListNotificationsState extends State<ListNotifications> {
  @override
  Widget build(BuildContext context) {
    return AnimatedList(
      key: NotificationAnimatedList.notificationsListKey,
      initialItemCount: widget.notifications.length,
      itemBuilder: (context, index, animation) {
        return NotificationTile(
            notification: widget.notifications[index], animation: animation);
      },
    );
  }
}
