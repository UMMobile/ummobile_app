import 'package:get/get.dart';

/// Returns the ellapse time between now and [date]
///
/// The time is based at the minor hierarchy posiible
/// in moments, minutes, hours or days
String toAgoTime(DateTime date) {
  var now = new DateTime.now();
  var diff = date.difference(now) * -1;

  if (diff.inHours == 0 && diff.inMinutes == 0)
    return 'moments_ago'.tr;
  else if (diff.inHours == 0)
    return 'notification_time'.trParams({
      'value': diff.inMinutes.toString(),
      'time': 'minute'.trPlural('minutes', diff.inMinutes)
    });
  else if (diff.inHours < 24)
    return 'notification_time'.trParams({
      'value': diff.inHours.toString(),
      'time': 'hour'.trPlural('hours', diff.inHours)
    });
  else
    return 'notification_time'.trParams({
      'value': diff.inDays.toString(),
      'time': 'day'.trPlural('days', diff.inDays)
    });
}
