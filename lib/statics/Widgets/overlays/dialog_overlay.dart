import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Opens a confirmation dialog with a [title] and a [message]
/// inside the application.
///
/// The actions of the button are set in the [onCancel] and [onConfirm] parameters
void openDialogWindow(
    {required String title,
    required String message,
    Function? onCancel,
    Function? onConfirm}) {
  Get.dialog(
    AlertDialog(
      title: Text(title, textAlign: TextAlign.center),
      contentPadding: EdgeInsets.fromLTRB(24, 0, 24, 24),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
              margin: const EdgeInsets.symmetric(vertical: 15),
              child: Text(message, textAlign: TextAlign.center)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              OutlinedButton(
                onPressed: onCancel as void Function()?,
                child: Text(
                  'cancel'.tr,
                  style: TextStyle(
                    color: (Get.isDarkMode) ? Colors.white : Colors.grey[800],
                  ),
                ),
              ),
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                ),
                onPressed: onConfirm as void Function()?,
                child: Text(
                  'confirm'.tr,
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    ),
    barrierDismissible: false,
  );
}

/// Opens a loading dialog with a loading message [text]
void openLoadingDialog(String text) {
  Get.dialog(
    AlertDialog(
      contentPadding: EdgeInsets.all(20),
      content: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          CircularProgressIndicator(),
          Expanded(
            child: Text(
              text,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.normal,
              ),
            ),
          ),
        ],
      ),
    ),
    barrierDismissible: false,
  );
}
