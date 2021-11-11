import 'package:get/instance_manager.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:ummobile/modules/app_bar/modules/notifications/controllers/notifications_controller.dart';

void handleOneSignalEvents() {
  // TODO (@jonathangomz): [Fix] When app is not on focus (background) `add` is not executed and cannot mark a notification as received.
  // See https://documentation.onesignal.com/docs/sdk-notification-event-handlers for a possible solution because
  // `setNotificationWillShowInForegroundHandler` function only works when the app is on focus but not on background.
  OneSignal.shared.setNotificationWillShowInForegroundHandler(
      (OSNotificationReceivedEvent event) {
    bool notificationsControllerExist =
        Get.isRegistered<NotificationsController>();

    if (notificationsControllerExist) {
      Get.find<NotificationsController>()
          .add(event.notification.notificationId);
    }
  });
}
