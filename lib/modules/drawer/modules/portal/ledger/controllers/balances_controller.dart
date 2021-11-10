import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ummobile/modules/drawer/modules/portal/ledger/controllers/movements_controller.dart';
import 'package:ummobile/modules/login/controllers/login_controller.dart';
import 'package:ummobile/statics/templates/controller_template.dart';
import 'package:ummobile_sdk/ummobile_sdk.dart';

class BalancesController extends ControllerTemplate
    with StateMixin<List<Balance>> {
  Future<UMMobileFinancial> get financialApi async {
    String accessToken = await Get.find<LoginController>().token;
    return UMMobileFinancial(token: accessToken);
  }

  var id = '';
  var tableTitle = '';
  int? selectedBalanceIndex;

  String get getCurrentAmount {
    if (selectedBalanceIndex == null) return "No amount data";

    return state![selectedBalanceIndex!].current.toStringAsFixed(2);
  }

  @override
  void onInit() {
    fetchBalances();
    super.onInit();
  }

  @override
  void refreshContent() {
    fetchBalances();
    super.refreshContent();
  }

  /// * Mehod in charge of loading the necessary data of the page
  void fetchBalances() async {
    call<List<Balance>>(
      httpCall: () async => await (await financialApi).getBalances(),
      onSuccess: (data) {
        _autoSelectBalance(data);
        change(data, status: RxStatus.success());
      },
      onCallError: (status) => change(null, status: status),
      onError: (e) => change(null, status: RxStatus.error(e.toString())),
    );
  }

  /// * Logic Method for automaticaly select a user balance when there is only one
  void _autoSelectBalance(List<Balance> balances) {
    if (balances.length == 1) {
      Balance onlyBalance = balances[0];
      balanceSelect(onlyBalance.id, onlyBalance.name, 0);
    } else {
      Get.find<MovementsController>().displayBalanceSelectPage();
    }
  }

  /// * Method used when the user manually selects one balance
  void balanceSelect(String selectId, String selectTitle, int index) async {
    id = selectId;
    tableTitle = selectTitle;
    selectedBalanceIndex = index;
    Get.find<MovementsController>().fetchMovements(selectId);
  }

  /// * Method that displays a modal for selecting a balance
  void accountModalBottomSheet() {
    List<Widget> programsSelect = [];

    if (state != null && state!.isNotEmpty) {
      for (int i = 0; i < state!.length; i++) {
        programsSelect.add(ListTile(
            leading: Icon(Icons.receipt_long),
            title: Text(state![i].name),
            onTap: () {
              balanceSelect(state![i].id, state![i].name, i);
              Get.back();
            }));
      }

      Get.bottomSheet(
        Container(
          child: Wrap(children: programsSelect),
        ),
        backgroundColor: Get.theme.scaffoldBackgroundColor,
        isDismissible: true,
        enableDrag: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20)),
        ),
      );
    } else {
      /*snackbarMessage(
          InternetStatusInfo.pageTitle, InternetStatusInfo.pageSubtitle);*/
    }
  }
}
