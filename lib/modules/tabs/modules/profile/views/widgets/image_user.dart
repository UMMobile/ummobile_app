import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'image_user_expanded.dart';

class UserImage extends StatelessWidget {
  final String? profileImage;
  const UserImage({Key? key, required this.profileImage}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 20.0),
      child: MaterialButton(
        color: Colors.white,
        child: Container(
          height: 160,
          decoration: BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.contain,
              image: (profileImage!=null && profileImage!.isNotEmpty)
                  ? MemoryImage(base64Decode(profileImage!))
                  : AssetImage('assets/img/default-img.jpg')
                      as ImageProvider<Object>,
            ),
            shape: BoxShape.circle,
          ),
        ),
        padding: EdgeInsets.all(2),
        shape: CircleBorder(),
        onPressed: () {
          if (profileImage!=null && profileImage!.isNotEmpty) {
            Get.to(
              () => ImageUserExpanded(
                imageRoute: profileImage,
              ),
              transition: Transition.zoom,
            );
          }
        },
      ),
    );
  }
}
