import 'package:flutter/material.dart';

import '../../Constants/color.dart';
class AlreadyHaveAnAccount extends StatelessWidget {
  final bool isLoginPage;
  final Function() press;
  const AlreadyHaveAnAccount({
    Key? key,
    required this.isLoginPage,
    required this.press,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Flexible(
          child: Text(
            isLoginPage ? "Don’t have an Account? " : "Already have an Account? ",
            style: const TextStyle(color: kPrimaryColor, fontSize: 16),
          ),
        ),
        Flexible(
          child: InkWell(
            onTap: press,
            child: Text(
              isLoginPage ? "Register" : "Login",
              style: const TextStyle(
                color: kPrimaryColor,
                fontWeight: FontWeight.bold,
                fontSize: 16
              ),
            ),
          ),
        )
      ],
    );
  }
}