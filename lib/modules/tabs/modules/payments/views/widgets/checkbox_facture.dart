import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ummobile/modules/tabs/modules/payments/controllers/payments_controller.dart';

import 'container_facture.dart';

class CheckboxFacture extends StatefulWidget {
  @override
  _CheckboxFactureState createState() => _CheckboxFactureState();
}

class _CheckboxFactureState extends State<CheckboxFacture> {
  final PaymentsController _accountController = Get.find<PaymentsController>();
  bool _checked = false;

  @override
  Widget build(BuildContext context) {
    final checkBox = ListTile(
      contentPadding: EdgeInsets.only(left: 2.5),
      title: Row(
        children: <Widget>[
          Container(child: Text('facture'.tr.capitalizeFirst!)),
          AbsorbPointer(
            child: Checkbox(value: _checked, onChanged: (bool? value) {}),
          )
        ],
      ),
      onTap: () {
        setState(() {
          _checked = !_checked;
          _accountController.paymentTextFields.wantsFacture = _checked;
          _accountController.clearOptionalData();
          _accountController.buttonEnableCondition();
        });
      },
    );

    return Container(
      margin: EdgeInsets.only(left: 20.0, right: 20.0, bottom: 20.0),
      child: Column(
        children: _checked
            ? <Widget>[checkBox, FactureFieldsContainer()]
            : <Widget>[checkBox],
      ),
    );
  }
}
