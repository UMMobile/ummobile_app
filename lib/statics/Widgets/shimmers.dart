import 'package:fade_shimmer/fade_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RectShimmer extends StatelessWidget {
  final double top;
  final double bottom;
  final double left;
  final double right;
  final double height;
  final double width;
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

class RoundShimmer extends StatelessWidget {
  final double top;
  final double bottom;
  final double left;
  final double right;
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
