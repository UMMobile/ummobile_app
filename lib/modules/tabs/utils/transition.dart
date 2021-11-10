import 'package:flutter/material.dart';

/// * Method that reloads the widget tree of the passed widget
void resetPage(Widget widget, BuildContext context) {
  Navigator.pushReplacement(
    context,
    PageRouteBuilder(
      transitionDuration: Duration.zero,
      pageBuilder: (_, __, ___) => widget,
    ),
  );
}
