import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ummobile/modules/app_bar/views/appBar.dart';
import 'package:ummobile/modules/tabs/controllers/navigation_controller.dart';
import 'package:ummobile/modules/tabs/modules/payments/controllers/payments_controller.dart';
import 'package:ummobile/statics/widgets/form/bottomsheet/botomsheet.dart';
import 'package:ummobile/statics/widgets/shimmers.dart';

import 'widgets/button_pay.dart';
import 'widgets/checkbox_facture.dart';
import 'widgets/textfield_money.dart';

class PaymentPage extends StatefulWidget {
  PaymentPage({Key? key}) : super(key: key);

  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage>
    with AutomaticKeepAliveClientMixin {
  PaymentsController _paymentsController = Get.find<PaymentsController>();

  bool showCustomTextField = false;

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      appBar: UmAppBar(
        title: 'finance'.tr.capitalizeFirst!,
        leading: IconButton(
          icon: Icon(Icons.menu),
          onPressed: () {
            Get.find<NavigationController>()
                .drawerKey
                .currentState!
                .openDrawer();
          },
        ),
      ),
      body: _paymentsController.obx(
        (balances) => RefreshIndicator(
          onRefresh: () async {
            _paymentsController.refreshContent();
          },
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            children: <Widget>[
              SizedBox(height: 25),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                child: Text('amount_instructions'.tr,
                    style: TextStyle(fontSize: 16)),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: BottomSheetButton(
                  controller: _paymentsController.programController,
                  children: _paymentsController.balancesTitles,
                  hint: 'balance_hint'.tr,
                  icon: Icons.receipt_long,
                  onSelect: (index) {
                    _paymentsController.paymentTextFields.programId =
                        balances![index].id;
                  },
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                child: Text('balance_instructions'.tr,
                    style: TextStyle(fontSize: 16)),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: BottomSheetButton(
                  controller: _paymentsController.amountController,
                  children: _paymentsController.amountTitles,
                  hint: 'amount_hint'.tr,
                  icon: Icons.monetization_on,
                  onSelect: (index) {
                    _paymentsController.paymentTextFields.amountId =
                        balances![index].id;
                    if (index == 0) {
                      _paymentsController.paymentTextFields.amountSum = '';
                      setState(() {
                        showCustomTextField = true;
                      });
                    } else {
                      _paymentsController.paymentTextFields.amountSum =
                          _paymentsController.amountTitles[index];
                    }
                  },
                ),
              ),
              (showCustomTextField)
                  ? Padding(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
                      child: MoneyTextField(),
                    )
                  : SizedBox(),
              CheckboxFacture(),
              ButtonPay(),
            ],
          ),
        ),
        onLoading: _ShimmerPayment(),
        onError: (e) => _paymentsController.internetPage(e),
      ),
    );
  }
}

class _ShimmerPayment extends StatelessWidget {
  const _ShimmerPayment({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: NeverScrollableScrollPhysics(),
      padding: EdgeInsets.symmetric(
        vertical: 25,
        horizontal: 20,
      ),
      children: <Widget>[
        RectShimmer(
          height: 30,
          top: 10,
          bottom: 10,
        ),
        RectShimmer(
          height: 40,
          radius: 10,
          bottom: 10,
        ),
        RectShimmer(
          height: 20,
          top: 10,
          bottom: 10,
        ),
        RectShimmer(
          height: 40,
          radius: 10,
          bottom: 10,
        ),
        Container(
          margin: EdgeInsets.only(bottom: 20, top: 10),
          child: Row(
            children: [
              RectShimmer(
                height: 40,
                width: 40,
                right: 10,
              ),
              RectShimmer(
                height: 30,
                width: 120,
              ),
            ],
          ),
        ),
        RectShimmer(
          height: 60,
          radius: 10,
        ),
      ],
    );
  }
}
