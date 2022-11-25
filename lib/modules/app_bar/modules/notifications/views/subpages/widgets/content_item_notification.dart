import 'package:flutter/material.dart' hide Notification;
import 'package:get/get.dart';
import 'package:ummobile/modules/app_bar/modules/notifications/controllers/notifications_controller.dart';
import 'package:ummobile_sdk/ummobile_sdk.dart';

/// Widget that displays the notification content
///
/// The notification content language is based from the app locale
class ContentItemNotification extends StatelessWidget {
  /// The UMMobile SDK notification object
  final Notification notification;

  const ContentItemNotification({Key? key, required this.notification})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (!this.notification.isSeen) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        Get.find<NotificationsController>().markAsRead(this.notification.id);
      });
    }

    return Container(
      width: MediaQuery.of(context).size.width,
      child: ListView(
        padding: EdgeInsets.only(top: 30.0, left: 20.0, right: 20.0),
        children: [
          Text(
            notification.headingTr(
                Get.locale != null ? Get.locale!.languageCode : 'es'),
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 26.0),
          ),
          SizedBox(
            height: 10.0,
          ),
          Text(
            notification.contentTr(
                Get.locale != null ? Get.locale!.languageCode : 'es'),
            style: TextStyle(fontSize: 14.0),
          )
        ],
      ),
    );
  }
}
