import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:ummobile/statics/environment.dart';

/// Initialize OneSignal service.
///
/// Connect to OneSignal app with the Id specified on the environment file.
Future<void> initializeOneSignal() async {
  OneSignal.shared.setLogLevel(OSLogLevel.verbose, OSLogLevel.none);

  OneSignal.shared.setAppId(environment['one_signal_id']);

  /*OneSignal.shared
      .setInFocusDisplayType(OSNotificationDisplayType.notification);*/

  await OneSignal.shared
      .promptUserForPushNotificationPermission(fallbackToSettings: true);
}

/// Initialize the listeners for OneSignal events.
///
/// When a new notification arrive and the app is on focus [onReceive] is executed passing the OneSignal notification as his only parameter.
void handleOneSignalEvents({
  void Function(OSNotification)? onReceive,
}) {
  OneSignal.shared.setNotificationWillShowInForegroundHandler(
      // ignore: todo
      // TODO (@jonathangomz): [Fix] When app is not on focus (background) `onReceive` is not executed and cannot mark a notification as received.
      // See https://documentation.onesignal.com/docs/sdk-notification-event-handlers for a possible solution because `setNotificationWillShowInForegroundHandler` function only works when the app is on focus but not on background.
      (OSNotificationReceivedEvent event) {
    if (onReceive != null) {
      onReceive(event.notification);
    }
  });
}

/// Update the external user [id] for this subscribed device.
void setPushNotificationUserId(String id) {
  OneSignal.shared.setExternalUserId(id);
}
