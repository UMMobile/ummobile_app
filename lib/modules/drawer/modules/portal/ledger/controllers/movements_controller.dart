import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:ummobile/modules/drawer/modules/portal/ledger/models/movements_section.dart';
import 'package:ummobile/modules/login/controllers/login_controller.dart';
import 'package:ummobile/statics/templates/controller_template.dart';
import 'package:ummobile_sdk/ummobile_sdk.dart';

class MovementsController extends ControllerTemplate
    with StateMixin<List<MovementsSection>> {
  Future<UMMobileFinancial> get financialApi async {
    String accessToken = await Get.find<LoginController>().token;
    return UMMobileFinancial(token: accessToken);
  }

  /// True if the user is in the select a balance page
  bool balanceSelectable = false;

  @override
  void onInit() {
    super.onInit();
  }

  void displayBalanceSelectPage() {
    // ignore: unused_local_variable
    bool balanceSelectable = true;
    change(null, status: RxStatus.empty());
  }

  /// Loads the movements of the [balanceId]
  void fetchMovements(String balanceId) async {
    change(null, status: RxStatus.loading());
    call<Movements>(
      httpCall: () async => await (await financialApi).getMovements(balanceId),
      onSuccess: (data) =>
          change(sortMovements(data.current), status: RxStatus.success()),
      onCallError: (status) => change(null, status: status),
      onError: (e) => change(null, status: RxStatus.error(e.toString())),
    );
  }

  /// Returns the list of movements sorted by dates
  ///
  /// Sorting is done from newer to oldest dates
  List<MovementsSection> sortMovements(List<Movement> movements) {
    List<MovementsSection> sortedSections = [];
    MovementsSection noDateSection = MovementsSection(
      title: "withoutDate".tr,
      movements: [],
    );

    DateTime? previousMovementDate;
    for (Movement movement in movements) {
      if (movement.date == null) {
        // Movements with no date
        noDateSection.movements.add(movement);
      } else if (previousMovementDate == null) {
        // Single movement
        sortedSections.add(
          MovementsSection(
            title: DateFormat('MMMM yyyy').format(movement.date!),
            movements: [movement],
          ),
        );
      } else if (previousMovementDate.month == movement.date!.month) {
        // Movements in same month
        sortedSections.last.movements.add(movement);
      } else if (previousMovementDate.month != movement.date!.month) {
        // First movement on a different month
        sortedSections.add(
          MovementsSection(
            title: DateFormat('MMMM yyyy').format(movement.date!),
            movements: [movement],
          ),
        );
      }

      previousMovementDate = movement.date;
    }

    // Get the rigth order
    sortedSections = sortedSections.reversed.toList();
    sortedSections.forEach((section) {
      List<Movement> reversed = section.movements.reversed.toList();
      section.movements.clear();
      section.movements.addAll(reversed);

      // If something still is out of order this should do the work
      section.movements.sort((a, b) => b.date!.compareTo(a.date!));
    });

    sortedSections.add(noDateSection);
    return sortedSections;
  }
}
