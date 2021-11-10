import 'package:get/get.dart';
import 'package:ummobile/modules/drawer/modules/portal/ledger/controllers/balances_controller.dart';
import 'package:ummobile/modules/drawer/modules/portal/ledger/controllers/movements_controller.dart';

class LedgerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BalancesController>(() => BalancesController());
    Get.lazyPut<MovementsController>(() => MovementsController());
  }
}