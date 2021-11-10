import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ummobile/modules/drawer/utils/open_external_explorer.dart';

class ItemSite extends StatelessWidget {
  final String imagePath;
  final String url;
  final double size;
  final double separation;

  const ItemSite({
    Key? key,
    required this.imagePath,
    required this.url,
    this.size: 150.0,
    this.separation: 40.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: this.separation),
      child: ClipOval(
        child: Material(
          color: Colors.white, // button color
          child: InkWell(
            splashColor: Color.fromRGBO(0, 208, 216, 1), // inkwell color
            child: SvgPicture.asset(imagePath,
                width: this.size, height: this.size, semanticsLabel: 'UM Logo'),
            onTap: () {
              openExternalExplorer(url);
            },
          ),
        ),
      ),
    );
  }
}
