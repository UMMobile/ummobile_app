

DateTime dayAfter() {
  final DateTime now = DateTime.now();
  return DateTime(now.year, now.month, now.day + 1);
}
