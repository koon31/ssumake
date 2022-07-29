import 'package:flutter/material.dart';

class CustomTextStyle {
  CustomTextStyle._();

  static TextStyle? custom1(BuildContext context) {
    return Theme.of(context)
        .textTheme
        .titleLarge
        ?.copyWith(color: Colors.black, fontWeight: FontWeight.bold);
  }
}