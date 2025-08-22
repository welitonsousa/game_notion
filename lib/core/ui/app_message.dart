import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppMessage {
  static void error(String message) {
    Get.snackbar(
      'Ops',
      message,
      backgroundColor: Colors.red,
      colorText: Colors.white,
    );
  }

  static void success(String message) {
    Get.snackbar(
      'Sucesso',
      message,
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
  }
}
