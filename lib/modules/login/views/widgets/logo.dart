import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// UMLogo for the login header
class LoginLogo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final String logoPath = 'assets/img/login_logo.svg';

    return Padding(
      padding: EdgeInsets.fromLTRB(10, 10, 10, 70),
      child: SvgPicture.asset(
        logoPath,
        semanticsLabel: 'UM Logo',
        allowDrawingOutsideViewBox: false,
        fit: BoxFit.scaleDown,
        height: MediaQuery.of(context).size.height / 4,
      ),
    );
  }
}
