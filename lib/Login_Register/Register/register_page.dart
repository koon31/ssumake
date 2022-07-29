import 'package:flutter/material.dart';
import 'package:ssumake/Login_Register/Register/register_body.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Material(child: RegisterBody(), );
  }
}
