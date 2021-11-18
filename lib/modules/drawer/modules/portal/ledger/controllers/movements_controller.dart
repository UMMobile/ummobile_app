import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:ummobile/modules/drawer/modules/portal/ledger/models/movements_section.dart';
import 'package:ummobile/modules/login/controllers/login_controller.dart';
import 'package:ummobile/statics/templates/controller_template.dart';
import 'package:ummobile_sdk/ummobile_sdk.dart';

class MovementsController extends ControllerTemplate
    with StateMixin<List<MovementsDateSorted>> {
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
  List<MovementsDateSorted> sortMovements(List<Movement> movements) {
    List<MovementsDateSorted> sortedMovements = [];
    MovementsDateSorted noDateMovements = MovementsDateSorted(
      date: "withoutDate".tr,
      movements: [],
    );

    DateTime? previousMovementDate;

    for (int i = 0; i < movements.length; i++) {
      DateTime? checkMovementDate = movements[i].date;

      if (checkMovementDate == null) {
        noDateMovements.movements.add(movements[i]);
      } else if (previousMovementDate == null) {
        sortedMovements.add(
          MovementsDateSorted(
            date: DateFormat('MMMM yyyy').format(checkMovementDate),
            movements: [movements[i]],
          ),
        );
      } else if (previousMovementDate.month == checkMovementDate.month) {
        sortedMovements.last.movements.add(movements[i]);
      } else if (previousMovementDate.month != checkMovementDate.month) {
        sortedMovements.add(
          MovementsDateSorted(
            date: DateFormat('MMMM yyyy').format(checkMovementDate),
            movements: [movements[i]],
          ),
        );
      }

      previousMovementDate = checkMovementDate;
    }
    sortedMovements = sortedMovements.reversed.toList();
    sortedMovements.add(noDateMovements);

    return sortedMovements;
  }
}
