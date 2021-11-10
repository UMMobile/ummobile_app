import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// * Shows a bottom message with the info passed
void snackbarMessage(String title, String message) {
  Get.snackbar(
    title,
    "",
    messageText: Text(message),
    snackPosition: SnackPosition.BOTTOM,
    backgroundColor: (Get.isDarkMode) ? Colors.grey[800] : Colors.white,
    margin: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
    boxShadows: <BoxShadow>[
      BoxShadow(
        color: Colors.grey[800]!.withOpacity(0.5),
        spreadRadius: 5,
        blurRadius: 7,
        offset: Offset(0, 3), // changes position of shadow
      ),
    ],
    isDismissible: false,
  );
}
