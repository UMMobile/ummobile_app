import 'package:flutter/material.dart';

class PageTabView {
  final Widget page;
  final Icon icon;
  final String? label;

  PageTabView({
    required this.page,
    required this.icon,
    this.label,
  });
}
