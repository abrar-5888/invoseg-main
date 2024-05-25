import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Snackbars {
  Snackbars._();

  static void errorSnackBar(String title, String message) {
    Get.snackbar(title, message,
        duration: const Duration(seconds: 1),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.8),
        titleText: Text(
          title,
          style: const TextStyle(color: Colors.white),
        ),
        messageText: Text(
          message,
          style: const TextStyle(color: Colors.white),
        ),
        mainButton: TextButton(
            onPressed: () {
              Get.back();
            },
            child: const Text(
              'OK',
              style: TextStyle(color: Colors.white),
            )),
        margin: const EdgeInsets.only(bottom: 8));
  }

  static void successSnackBar(String title, String message) {
    Get.snackbar(title, message,
        duration: const Duration(seconds: 1),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.withOpacity(0.8),
        titleText: Text(
          title,
          style: const TextStyle(color: Colors.white),
        ),
        messageText: Text(
          message,
          style: const TextStyle(color: Colors.white),
        ),
        mainButton: TextButton(
            onPressed: () {
              Get.back();
            },
            child: const Text(
              'OK',
              style: TextStyle(color: Colors.white),
            )),
        margin: const EdgeInsets.only(bottom: 8));
  }
}
