import 'package:flutter/material.dart';
import 'package:ssumake/Login_Register/Login/login_body.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Material(child: LoginBody());
  }
}
