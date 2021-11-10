import 'package:flutter/material.dart';
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart';
import 'package:get/get.dart';
import 'package:ummobile/modules/login/controllers/login_controller.dart';
import 'package:ummobile/modules/tabs/modules/payments/models/payment_values.dart';
import 'package:ummobile/modules/tabs/modules/payments/views/page_payment.dart';
import 'package:ummobile/modules/tabs/modules/payments/views/utils/create_payment.dart';
import 'package:ummobile/modules/tabs/modules/profile/models/user_credentials.dart';
import 'package:ummobile/modules/tabs/utils/transition.dart';
import 'package:ummobile/statics/templates/controller_template.dart';
import 'package:ummobile/statics/widgets/form/bottomsheet/bottomsheet_controller.dart';
import 'package:ummobile/statics/widgets/overlays/dialog_overlay.dart';
import 'package:ummobile_sdk/ummobile_sdk.dart';

class PaymentsController extends ControllerTemplate
    with StateMixin<List<Balance>> {
  Future<UMMobileFinancial> get financialApi async {
    String accessToken = await Get.find<LoginController>().token;
    return UMMobileFinancial(token: accessToken);
  }

  var botonEnableNotif = false.obs;

  var paymentTextFields = PaymentValues.clearData();

  BottomSheetController programController = BottomSheetController();
  BottomSheetController amountController = BottomSheetController();

  List<String> get balancesTitles {
    List<String> returnable = List.empty(growable: true);

    for (int i = 0; i < state!.length; i++) {
      returnable.add(state![i].name);
    }

    return returnable;
  }

  List<String> get amountTitles {
    List<String> returnable = List.empty(growable: true);

    returnable.add('custom'.tr.capitalizeFirst!);

    for (int i = 0; i < state!.length; i++) {
      if (state![i].currentDebt < 0) {
        double amount = state![i].currentDebt * -1;
        returnable.add(amount.toString());
      }
    }

    return returnable;
  }

  @override
  void onInit() {
    fetchBalances();
    super.onInit();
  }

  @override
  void refreshContent() {
    change(null, status: RxStatus.loading());
    fetchBalances();
    super.refreshContent();
  }

  /// * Mehod for clearing all the data previously stored and disable the page send button
  void clearPaymentForm() {
    botonEnableNotif(false);
    paymentTextFields = PaymentValues.clearData();
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

  void _autoSelectBalance(List<Balance> balances) {
    if (balances.length == 1) {
      programController.id = 0;
      programController.text = balances[0].name;
      paymentTextFields.programId = balances[0].id;
    }
  }

  void sendPayment(BuildContext context) async {
    openLoadingDialog('sending'.trParams({
      'element': 'request'.tr,
    }));

    Payment? payment = await createPayment();

    if (payment != null) {
      await call<String>(
        httpCall: () async => await (await financialApi).generatePaymentUrl(
          payment,
          requestInvoice: paymentTextFields.wantsFacture,
        ),
        onSuccess: (data) async {
          clearPaymentForm();
          await launch(
            data,
            customTabsOption: CustomTabsOption(
              toolbarColor: Get.theme.primaryColor,
              enableDefaultShare: true,
              enableUrlBarHiding: true,
              showPageTitle: true,
              extraCustomTabs: const <String>[
                'org.mozilla.firefox',
                'com.microsoft.emmx',
              ],
            ),
          );
          resetPage(PaymentPage(), context);
        },
        onCallError: (status) => change(null, status: status),
        onError: (e) => change(null, status: RxStatus.error(e.toString())),
      );
    }

    Get.back();
  }

  Future<Payment?> createPayment() async {
    String accessToken = await Get.find<LoginController>().token;
    UMMobileUser userApi = UMMobileUser(token: accessToken);

    User? user;
    List<PaymentAdditionalData> adData = [];

    await call<User>(
      httpCall: () async => await userApi.getInformation(),
      onSuccess: (data) => user = data,
      onCallError: (status) => change(null, status: status),
      onError: (e) => change(null, status: RxStatus.error(e.toString())),
    );

    if (user == null) return null;

    adData.add(PaymentAdditionalData(
        id: 1,
        label: 'Nombre Cliente',
        value: user!.name + ' ' + user!.surnames));

    adData.add(PaymentAdditionalData(
        id: 2,
        label: 'Referencia',
        value: userId +
            '-' +
            paymentTextFields.programId! +
            '-' +
            DateTime.now().millisecondsSinceEpoch.toString()));
    adData.add(PaymentAdditionalData(id: 3, label: 'UMMobile', value: 'S'));
    adData.add(PaymentAdditionalData(
        id: 4,
        label: 'isFactura',
        value: paymentTextFields.wantsFacture.toString()));
    if (paymentTextFields.wantsFacture) {
      adData.add(PaymentAdditionalData(
          id: 5, label: 'nombreRFC', value: paymentTextFields.nameRFC!));
      adData.add(PaymentAdditionalData(
          id: 6, label: 'rfc', value: paymentTextFields.rFC!));
      adData.add(PaymentAdditionalData(
          id: 7, label: 'usoCfdi', value: paymentTextFields.useCFDI!));
      adData.add(PaymentAdditionalData(
          id: 8, label: 'domicilio', value: paymentTextFields.address!));
    }

    return Payment(
      reference: userId + '-' + paymentTextFields.programId! + '-',
      amount: double.parse(paymentTextFields.amountSum!),
      expirationDate: dayAfter(),
      clientMail: user!.extras.email,
      additionalData: adData,
    );
  }

  /// * Mehod in charge of checking that every required field is filled to enable the send button
  void buttonEnableCondition() {
    if (!paymentTextFields.wantsFacture) {
      if (paymentTextFields.programId != null &&
          paymentTextFields.amountId != null &&
          (paymentTextFields.amountSum != null &&
              paymentTextFields.amountSum!.isNotEmpty)) {
        botonEnableNotif.value = true;
      } else {
        botonEnableNotif.value = false;
      }
    } else {
      if (paymentTextFields.programId != null &&
          paymentTextFields.amountId != null &&
          (paymentTextFields.amountSum != null &&
              paymentTextFields.amountSum!.isNotEmpty) &&
          (paymentTextFields.nameRFC != null &&
              paymentTextFields.nameRFC!.isNotEmpty) &&
          (paymentTextFields.rFC != null &&
              paymentTextFields.rFC!.isNotEmpty) &&
          (paymentTextFields.useCFDI != null &&
              paymentTextFields.useCFDI!.isNotEmpty) &&
          (paymentTextFields.address != null &&
              paymentTextFields.address!.isNotEmpty)) {
        botonEnableNotif.value = true;
      } else {
        botonEnableNotif.value = false;
      }
    }
  }

// * Method used to stored in the right parameter the value entered in the textFields
  void captureOptionalData(String value, String? type) {
    switch (type) {
      case 'NameRFC':
        paymentTextFields.nameRFC = value;
        break;
      case 'RFC':
        paymentTextFields.rFC = value;
        break;
      case 'CFDI':
        paymentTextFields.useCFDI = value;
        break;
      case 'Domicilio':
        paymentTextFields.address = value;
        break;
      default:
        print('no controller assigned');
    }
    buttonEnableCondition();
  }

// * Method used when the user checks or unchecks the whants facture checkButton
  void clearOptionalData() {
    paymentTextFields.nameRFC = null;
    paymentTextFields.rFC = null;
    paymentTextFields.useCFDI = null;
    paymentTextFields.address = null;
  }
}
