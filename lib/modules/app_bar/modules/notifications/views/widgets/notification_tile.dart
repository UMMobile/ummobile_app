import 'package:flutter/material.dart' hide Notification;
import 'package:get/get.dart';
import 'package:ummobile/modules/app_bar/modules/notifications/controllers/notifications_controller.dart';
import 'package:ummobile/modules/app_bar/modules/notifications/utils/to_ago_time.dart';
import 'package:ummobile/modules/app_bar/modules/notifications/views/subpages/item_notification_page.dart';
import 'package:ummobile_sdk/ummobile_sdk.dart';

/// Widget notification tile
///
/// The design of the tile is based by the notification isSeen value
class NotificationTile extends StatefulWidget {
  final Notification notification;
  final Animation<double> animation;

  const NotificationTile({
    Key? key,
    required this.notification,
    required this.animation,
  }) : super(key: key);

  @override
  _NotificationTileState createState() => _NotificationTileState();
}

class _NotificationTileState extends State<NotificationTile> {
  final controller = Get.find<NotificationsController>();

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: Offset(1, 0),
        end: Offset(0, 0),
      ).animate(widget.animation),
      child: Column(children: <Widget>[
        Dismissible(
            key: Key(widget.notification.id),
            direction: DismissDirection.endToStart,
            background: Container(
              alignment: Alignment.centerRight,
              color: Colors.red,
              child: Container(
                margin: EdgeInsets.only(right: 20.0),
                child: Icon(
                  Icons.delete,
                  color: Colors.white,
                ),
              ),
            ),
            child: ListTile(
                minLeadingWidth: 20,
                leading: (!widget.notification.isSeen)
                    ? Container(
                        height: double.infinity,
                        child: Icon(
                          Icons.fiber_manual_record,
                          color: Get.theme.colorScheme.secondary,
                        ),
                      )
                    : null,
                title: Text(
                  widget.notification.headingTr(
                      Get.locale != null ? Get.locale!.languageCode : 'es'),
                  style: TextStyle(
                    fontWeight: (!widget.notification.isSeen)
                        ? FontWeight.bold
                        : FontWeight.normal,
                  ),
                ),
                subtitle: Text(
                  toAgoTime(widget.notification.createAt),
                ),
                trailing: Container(
                    height: double.infinity,
                    child: Icon(Icons.keyboard_arrow_right)),
                onTap: () => Get.to(
                      () => ItemNotificationPage(
                        notificationId: widget.notification.id,
                      ),
                      transition: Transition.rightToLeftWithFade,
                    )),
            onDismissed: (direction) {
              controller.remove(widget.notification.id);
            }),
        Divider(
            color: Colors.grey,
            height: 2,
            indent: 10.0,
            endIndent: 10.0,
            thickness: 0.5),
      ]),
    );
  }
}
