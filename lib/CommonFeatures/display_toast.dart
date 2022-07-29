import 'package:flutter/material.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:motion_toast/resources/arrays.dart';
class DisplayToast {
  DisplayToast._();
  static void DisplayErrorToast(context, message) {
    MotionToast.error(
        title: const Text(
          'Error',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        description: Text(message),
        width: 450,
        animationType: AnimationType.fromRight,
        toastDuration: const Duration(seconds: 2))
        .show(context);
  }

  static void DisplaySuccessToast(context, message) {
    MotionToast.success(
        title: const Text(
          'Success',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        description: Text(message),
        animationType: AnimationType.fromRight,
        width: 450,
        toastDuration: const Duration(seconds: 2))
        .show(context);
  }
}
