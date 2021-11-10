import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ummobile/modules/drawer/modules/portal/ledger/controllers/balances_controller.dart';

class BalanceFloatingButton extends GetView<BalancesController> {
  const BalanceFloatingButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return controller.obx(
      (state) => FloatingActionButton(
          child: Icon(
            Icons.table_chart,
            color: Colors.white,
          ),
          onPressed: () {
            controller.accountModalBottomSheet();
          }),
      onLoading: Container(),
      onError: (e) {
        print(e);
        return Container();
      },
    );
  }
}
