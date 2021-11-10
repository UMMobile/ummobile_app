import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class UMTextField extends StatefulWidget {
  /// The label for the text field.
  final String label;

  /// The keyboard type.
  final TextInputType textInputType;

  /// The marker to know if is enable or not.
  final bool enable;

  /// The max lines.
  final int? linesHeigth;

  /// The text field placeholder.
  final String? placeholder;

  /// The controller for the text field.
  final TextEditingController? controller;

  /// The formatters for limitting users input
  final List<TextInputFormatter>? inputFormatters;

  UMTextField({
    required this.label,
    this.textInputType: TextInputType.text,
    this.enable: true,
    this.linesHeigth,
    this.placeholder,
    this.controller,
    this.inputFormatters,
  });

  @override
  _UMTextFieldState createState() => _UMTextFieldState();
}

class _UMTextFieldState extends State<UMTextField> {
  FocusNode focus = FocusNode();
  late bool labelUp;

  bool get haveContent =>
      widget.controller != null ? widget.controller!.text.isNotEmpty : false;

  @override
  void initState() {
    super.initState();
    this.labelUp = this.haveContent;
    this.focus.addListener(this._onFocusChange);
  }

  @override
  void dispose() {
    this.focus.dispose();
    super.dispose();
  }

  _onFocusChange() {
    setState(() {
      this.labelUp = this.focus.hasFocus || this.haveContent;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextField(
        autofocus: false,
        keyboardType: widget.textInputType,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          hintText: widget.placeholder,
          labelText: widget.label,
          alignLabelWithHint: true,
          labelStyle: TextStyle(
            fontSize: 14,
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            color: widget.enable
                ? Theme.of(context).colorScheme.secondary
                : Colors.grey,
            fontWeight: widget.enable ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        maxLines: widget.linesHeigth,
        controller: widget.controller,
        enabled: widget.enable,
        focusNode: focus,
        inputFormatters: widget.inputFormatters,
        style: TextStyle(
          color: widget.enable ? Theme.of(context).primaryColor : Colors.grey,
        ),
      ),
    );
  }
}
