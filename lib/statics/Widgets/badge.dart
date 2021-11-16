import 'package:flutter/material.dart';

/// Widget that can display badge on top of a [child]
class Badge extends StatelessWidget {
  /// The top position of the badge widget
  final double top;

  /// The right position of the badge widget
  final double right;

  /// The widget on which the badge will be on top of
  final Widget child;

  /// The content inside the badge
  final String? value;

  /// The badge color
  final Color color; // the  background color of the badge - default is red

  Badge(
      {required this.child,
      this.value,
      this.color = Colors.red,
      this.top = 0,
      this.right = 0});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      clipBehavior: Clip.none,
      children: [
        child,
        (value != null && value != "0")
            ? Positioned(
                right: right,
                top: top,
                child: Container(
                  padding: EdgeInsets.all(2.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: color,
                  ),
                  constraints: BoxConstraints(
                    minWidth: 16,
                    minHeight: 16,
                  ),
                  child: Text(
                    value!,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 10,
                    ),
                  ),
                ),
              )
            : Container()
      ],
    );
  }
}
