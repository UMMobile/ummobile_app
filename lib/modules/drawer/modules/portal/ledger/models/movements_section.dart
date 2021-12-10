import 'package:ummobile_sdk/ummobile_sdk.dart';

class MovementsSection {
  /// The title for the movements section
  ///
  /// Usually the date with "MMMM yyyy" format but can be any text.
  final String title;

  /// The list of movements grouped by the specified [title].
  final List<Movement> movements;

  MovementsSection({
    required this.title,
    required this.movements,
  });
}
