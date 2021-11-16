import 'package:fade_shimmer/fade_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Widget for a rectangle shape widget with shimmer effect
class RectShimmer extends StatelessWidget {
  /// The top margin of the widget
  final double top;

  /// The bottom margin of the widget
  final double bottom;

  /// The left margin of the widget
  final double left;

  /// The right margin of the widget
  final double right;

  /// The height of the widget
  final double height;

  /// The width of the widget
  final double width;

  /// The roundness of the borders
  final double radius;

  const RectShimmer({
    Key? key,
    this.top = 0,
    this.bottom = 0,
    this.left = 0,
    this.right = 0,
    this.radius = 0,
    this.width = double.infinity,
    required this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(left, top, right, bottom),
      child: FadeShimmer(
        height: height,
        width: width,
        radius: radius,
        fadeTheme: Get.isDarkMode ? FadeTheme.dark : FadeTheme.light,
      ),
    );
  }
}

/// Widget for a circle shape widget with shimmer widget
class RoundShimmer extends StatelessWidget {
  /// The top margin of the widget
  final double top;

  /// The bottom margin of the widget
  final double bottom;

  /// The left margin of the widget
  final double left;

  /// The right margin og the widget
  final double right;

  /// The radius size of the widget
  final double size;

  const RoundShimmer({
    Key? key,
    this.top = 0,
    this.bottom = 0,
    this.left = 0,
    this.right = 0,
    required this.size,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(left, top, right, bottom),
      child: FadeShimmer.round(
        size: size,
        fadeTheme: Get.isDarkMode ? FadeTheme.dark : FadeTheme.light,
      ),
    );
  }
}
