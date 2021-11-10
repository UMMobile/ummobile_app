import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ummobile/modules/tabs/modules/payments/controllers/payments_controller.dart';

class ButtonPay extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetX<PaymentsController>(builder: (_) {
      return Container(
          margin: EdgeInsets.only(right: 20.0, left: 20.0, bottom: 40.0),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: Theme.of(context).colorScheme.secondary,
              minimumSize: Size(double.infinity, 40.0),
              onPrimary: Color.fromRGBO(255, 255, 255, 0.2),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
            ),
            child: Text(
              'checkout'.tr.capitalizeFirst!,
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
            onPressed: (_.botonEnableNotif.value)
                ? () => _.sendPayment(context)
                : null,
          ));
    });
  }
}
