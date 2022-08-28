import 'package:flutter/material.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:motion_toast/resources/arrays.dart';

class DisplayToast {
  DisplayToast._();

  static void displayErrorToast(context, message) {
    double width = MediaQuery.of(context).size.width * 0.9;
    double height = MediaQuery.of(context).size.height * 0.1;
    MotionToast.error(
            title: const Text(
              'Error',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            description: Text(message),
            width: width,
            height: height,
            animationType: AnimationType.fromRight,
            toastDuration: const Duration(seconds: 1, milliseconds: 500),)
        .show(context);
  }

  static void displaySuccessToast(context, message) {
    double width = MediaQuery.of(context).size.width * 0.9;
    double height = MediaQuery.of(context).size.height * 0.1;
    MotionToast.success(
            title: const Text(
              'Success',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            description: Text(message),
            animationType: AnimationType.fromRight,
            width: width,
            height: height,
            toastDuration: const Duration(seconds: 1, milliseconds: 500),)
        .show(context);
  }
}
