import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ummobile/modules/login/controllers/login_controller.dart';

/// * Card that appears at the end of the User Login Cards that lets the user enter a
/// * manual login on click
class AddLogin extends StatelessWidget {
  const AddLogin({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () => Get.find<LoginController>().showQuickLogins(false),
      style: TextButton.styleFrom(
        primary: Colors.grey,
        shape: RoundedRectangleBorder(
          side: BorderSide(
            width: 2,
            style: BorderStyle.solid,
            color: Theme.of(context).cardColor,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        elevation: 0,
        padding: EdgeInsets.all(5),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: 50,
            width: 50,
            margin: EdgeInsets.only(bottom: 5),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor.withOpacity(0.8),
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                width: 2,
                color: Theme.of(context).cardColor,
              ),
            ),
            child: Icon(
              Icons.add,
              size: 24,
              color: Theme.of(context).hintColor,
            ),
          ),
          Text(
            'add'.trParams({'element': 'user'.tr}),
            textAlign: TextAlign.center,
            style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: 14, color: Colors.white),
          ),
        ],
      ),
    );
  }
}
