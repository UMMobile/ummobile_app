import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ImageUserExpanded extends StatelessWidget {
  final String? imageRoute;
  ImageUserExpanded({Key? key, this.imageRoute}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: Text('profile_image'.tr.capitalizeFirst!,
            style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.black,
      body: Center(
        child: InteractiveViewer(
            clipBehavior: Clip.none,
            child: Image.memory(base64Decode(imageRoute!))),
      ),
    );
  }
}
