import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'textfield_facture.dart';

class FactureFieldsContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border(
              left: BorderSide(
                  color: Theme.of(context).colorScheme.secondary, width: 2.0))),
      padding: EdgeInsets.only(left: 10.0),
      child: Column(
        children: <Widget>[
          TextFieldFacture(
              textLabel: 'rfc_name'.tr,
              textHint: 'factura sA',
              valueController: 'NameRFC'),
          TextFieldFacture(
            textLabel: 'RFC',
            textHint: 'UMO8409105C4',
            valueController: 'RFC',
          ),
          TextFieldFacture(
              textLabel: 'cfdi_use'.tr,
              textHint: 'G03',
              valueController: 'CFDI'),
          TextFieldFacture(
              textLabel: 'address'.tr,
              textHint: 'Libertad 1300 Montemorelos',
              valueController: 'Domicilio'),
        ],
      ),
    );
  }
}
