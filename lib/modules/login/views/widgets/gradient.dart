import 'package:flutter/material.dart';
import 'package:ummobile/statics/settings/colors.dart';

/// Gradient displayed at the back of the login page
class GradientBG extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(gradient: AppColorThemes.mainGradient),
    );
  }
}
