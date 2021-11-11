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

/// Update the external user [id] for this subscribed device.
void setPushNotificationUserId(String id) {
  OneSignal.shared.setExternalUserId(id);
}
