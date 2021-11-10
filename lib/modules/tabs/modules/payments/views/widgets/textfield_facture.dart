import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ummobile/modules/tabs/modules/payments/controllers/payments_controller.dart';

// ignore: must_be_immutable
class TextFieldFacture extends StatefulWidget {
  final String textLabel;
  final String textHint;
  final String valueController;

  const TextFieldFacture(
      {Key? key,
      required this.textHint,
      required this.textLabel,
      required this.valueController})
      : super(key: key);

  @override
  _TextFieldFactureState createState() => _TextFieldFactureState();
}

class _TextFieldFactureState extends State<TextFieldFacture> {
  late TextEditingController _textEditingController;
  Color _borderColorFocused = Colors.red;
  Color _borderColor = Colors.deepPurple;

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
      _borderColorFocused = Colors.green;
      _borderColor = Get.theme.colorScheme.secondary;
    } else {
      _borderColorFocused = Colors.red;
      _borderColor = Colors.red;
    }
    Get.find<PaymentsController>().captureOptionalData(
        _textEditingController.text, widget.valueController);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: TextField(
      textInputAction: TextInputAction.next,
      controller: _textEditingController,
      decoration: InputDecoration(
        hintText: 'ej. ' + widget.textHint,
        labelText: widget.textLabel,
        floatingLabelBehavior: FloatingLabelBehavior.always,
        focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: _borderColorFocused, width: 2.5)),
        enabledBorder:
            UnderlineInputBorder(borderSide: BorderSide(color: _borderColor)),
      ),
    ));
  }
}
