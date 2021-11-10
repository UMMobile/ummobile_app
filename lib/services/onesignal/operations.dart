import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:ummobile/statics/environment.dart';

Future<void> initializeOneSignal() async {
  OneSignal.shared.setLogLevel(OSLogLevel.verbose, OSLogLevel.none);

  OneSignal.shared.setAppId(environment['one_signal_id']);

  /*OneSignal.shared
      .setInFocusDisplayType(OSNotificationDisplayType.notification);*/

  await OneSignal.shared
      .promptUserForPushNotificationPermission(fallbackToSettings: true);
}

void setPushNotificationUserId(String id) {
  OneSignal.shared.setExternalUserId(id);
}
