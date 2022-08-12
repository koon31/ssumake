import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../API/location_API.dart';
import '../../API/login_API.dart';
import '../../CommonFeatures/custom_button.dart';
import '../../CommonFeatures/display_toast.dart';
import '../../Model/Location/location_model.dart';
import '../../Model/User/user_model.dart';

class ErrorDialog extends StatefulWidget {
  const ErrorDialog({Key? key, this.message}) : super(key: key);
  final String? message;
  @override
  State<ErrorDialog> createState() => _ErrorDialogState();
}

class _ErrorDialogState extends State<ErrorDialog> {
  final _phoneController = TextEditingController();

  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)), //this right here
        child: SizedBox(
          height: size.width*0.7,
          width: size.width*0.7,
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children:[
                    Text(widget.message!, style: const TextStyle(color: Colors.red),),
                    CustomButtonMedium(
                      text: "OK",
                      press: () {
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              ),
        );
  }
}
