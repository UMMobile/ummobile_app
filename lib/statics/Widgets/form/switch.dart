import 'package:flutter/material.dart';

class UMSwitch extends StatelessWidget {
  /// The label for the widget
  final String label;

  /// The initial value.
  final bool value;

  /// The function to be executed on change.
  final void Function(bool)? onChanged;

  UMSwitch({
    required this.label,
    this.value: false,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 8.0, bottom: 0),
      child: Column(
        children: [
          Text(
            this.label,
            style: TextStyle(
              color: Theme.of(context).colorScheme.secondary,
              fontWeight: FontWeight.bold,
            ),
          ),
          Switch.adaptive(
            value: this.value,
            onChanged: this.onChanged,
          ),
        ],
      ),
    );
  }
}
