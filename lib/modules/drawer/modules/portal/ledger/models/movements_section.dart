import 'package:ummobile_sdk/ummobile_sdk.dart';

class MovementsDateSorted {
  /// The movements date
  ///
  /// The format used is MMMM yyyy
  final String date;

  /// The list of movements inside the [date] month
  final List<Movement> movements;

  MovementsDateSorted({
    required this.date,
    required this.movements,
  });
}
