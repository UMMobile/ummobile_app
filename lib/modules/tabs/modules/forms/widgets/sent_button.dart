import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ButtonSent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(right: 20.0, left: 20.0, bottom: 40.0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            foregroundColor: Theme.of(context).colorScheme.secondary,
            minimumSize: Size(double.infinity, 40.0),
            disabledForegroundColor: Color.fromRGBO(255, 255, 255, 0.2),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
          ),
          child: Text(
            'checkout'.tr.capitalizeFirst!,
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
          onPressed: (null),
        ));
  }
}
