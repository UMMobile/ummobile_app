import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:ummobile/modules/tabs/modules/payments/controllers/payments_controller.dart';

class MoneyTextField extends StatefulWidget {
  @override
  _MoneyTextFieldState createState() => _MoneyTextFieldState();
}

class _MoneyTextFieldState extends State<MoneyTextField> {
  final PaymentsController _accountController = Get.find<PaymentsController>();
  late TextEditingController _textEditingController;
  bool error = false;

  void initState() {
    super.initState();
    _textEditingController = TextEditingController();
    _textEditingController.addListener(_getLatestValue);
  }

  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  _getLatestValue() {
    if (_textEditingController.text.isNotEmpty) {
      error = false;
    } else {
      error = true;
    }
    _accountController.paymentTextFields.amountSum =
        _textEditingController.text;
    _accountController.buttonEnableCondition();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _textEditingController,
      keyboardType: TextInputType.number,
      inputFormatters: <TextInputFormatter>[
        FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))
      ],
      decoration: InputDecoration(
        focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(
                color: Theme.of(context).colorScheme.secondary, width: 2.5)),
        enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(
                color: Theme.of(context).colorScheme.secondary, width: 1)),
        prefixIcon: Icon(
          Icons.monetization_on,
          color: Theme.of(context).colorScheme.secondary,
        ),
        errorText: error ? 'invalid_amount_hint'.tr : null,
      ),
    );
  }
}
