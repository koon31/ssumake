import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ssumake/API/login_API.dart';
import 'package:ssumake/Homepage/home_page.dart';
import 'package:ssumake/Login_Register/Register/register_page.dart';
import 'package:ssumake/Model/User/user_model.dart';
import '../../CommonFeatures/custom_button.dart';
import '../../CommonFeatures/display_toast.dart';
import '../../CommonFeatures/input_decoration.dart';
import '../../Constants/color.dart';
import 'already_have_an_account.dart';
import 'login_background.dart';

class LoginBody extends StatefulWidget {
  const LoginBody({
    Key? key,
  }) : super(key: key);

  @override
  State<LoginBody> createState() => _LoginBodyState();
}

class _LoginBodyState extends State<LoginBody> {
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return LoginBackground(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              "LOGIN",
              style: TextStyle(
                  color: kPrimaryColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 26),
            ),
            SizedBox(height: size.height * 0.03),
            SvgPicture.asset(
              "assets/icons/login.svg",
              height: size.height * 0.35,
            ),
            SizedBox(height: size.height * 0.03),
            RoundedInputField(
              controller: _phoneController,
              hintText: "Số Điện Thoại",
              type: TextInputType.phone,
              onChanged: (value) {},
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Vui lòng điền đầy đủ số điện thoại';
                } else {
                  return null;
                }
              },
            ),
            RoundedPasswordField(
              controller: _passwordController,
              onChanged: (value) {},
              isConfirm: false,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Vui lòng điền đầy đủ mật khẩu';
                } else {
                  return null;
                }
              },
            ),
            CustomButtonLarge(
              text: "LOGIN",
              press: () {
                onClickLogin(_phoneController.text, _passwordController.text);
                // Navigator.pushReplacement(
                //   context,
                //   MaterialPageRoute(
                //     builder: (context) {
                //       return const HomePage();
                //     },
                //   ),
                // );
              },
            ),
            SizedBox(height: size.height * 0.03),
            AlreadyHaveAnAccount(
              press: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return const RegisterPage();
                    },
                  ),
                );
              },
              isLoginPage: true,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> onClickLogin(String phoneNumber, String password) async {
    try {
      final result = await LoginAPI.login(phoneNumber, password);
      final UserModel? loggedInUser =
          UserModel.fromMap(jsonDecode(result.body));
      if (loggedInUser != null) Provider.of<User>(context, listen: false).login(loggedInUser);
      SharedPreferences preferences = await SharedPreferences.getInstance();
      preferences.setStringList('user', [loggedInUser!.phoneNumber!, loggedInUser.id!]);
      if (loggedInUser != null) {
        DisplayToast.DisplaySuccessToast(context, 'Đăng nhập thành công');
        Timer(const Duration(seconds: 3), () {
          // 3 seconds over, navigate to Page2.
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const HomePage()));
        });
      } else {
        DisplayToast.DisplayErrorToast(context, 'Đăng nhập thất bại');
      }
    } catch (e) {
      DisplayToast.DisplayErrorToast(context, 'Đăng nhập thất bại fail');
    }
  }
}
