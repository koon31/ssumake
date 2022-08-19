import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ssumake/API/login_API.dart';
import 'package:ssumake/CommonFeatures/show_custom_modal_bottom_sheet.dart';
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
  GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: LoginBackground(
        child: SingleChildScrollView(
          child: Form(
            key: loginFormKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text(
                  "Đăng nhập",
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
                  text: "Đăng nhập",
                  press: () {
                    if (loginFormKey.currentState!.validate()) {
                      onClickLogin(
                          _phoneController.text, _passwordController.text);
                    }
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
                Container(
                  margin:
                      const EdgeInsets.symmetric(vertical: kDefaultPadding / 4),
                  width: size.width * 0.8,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(29),
                    child: Row(
                      children: [
                        Spacer(),
                        GestureDetector(
                          onTap: () {ShowModalBottomSheet.showForgotPassword(context);},
                          child: const Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: kDefaultPadding),
                            child: Text(
                              'Quên mật khẩu',
                              style: TextStyle(
                                  color: kPrimaryColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: size.height * 0.02),
                Container(
                  margin: const EdgeInsets.only(bottom: kDefaultPadding / 2),
                  width: size.width * 0.8,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(29),
                    child: Row(
                      children: const [
                        Expanded(
                            child: Divider(
                          height: 1.5,
                          thickness: 1,
                          color: kPrimaryLightColor,
                        )),
                        SizedBox(
                          width: 5,
                        ),
                        Expanded(
                            child: Divider(
                          height: 1.5,
                          thickness: 1,
                          color: kPrimaryLightColor,
                        )),
                        SizedBox(
                          width: 5,
                        ),
                        Expanded(
                            child: Divider(
                          height: 1.5,
                          thickness: 1,
                          color: kPrimaryLightColor,
                        )),
                        SizedBox(
                          width: 5,
                        ),
                        Expanded(
                            child: Divider(
                          height: 1.5,
                          thickness: 1,
                          color: kPrimaryLightColor,
                        )),
                        SizedBox(
                          width: 5,
                        ),
                        Expanded(
                            child: Divider(
                          height: 1.5,
                          thickness: 1,
                          color: kPrimaryLightColor,
                        )),
                      ],
                    ),
                  ),
                ),
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
                GestureDetector(
                  onTap: () async => Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const HomePage())),
                  child: const Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: kDefaultPadding / 2),
                    child: DefaultTextStyle(
                      style: TextStyle(
                          color: kPrimaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 15),
                      child: Text(
                        'Chuyển đến Trang chủ',
                      ),
                    ),
                  ),
                ),
                Padding(padding: MediaQuery.of(context).viewInsets),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> onClickLogin(String phoneNumber, String password) async {
    try {
      if (phoneNumber.isNotEmpty && password.isNotEmpty) {
        final result = await LoginAPI.login(phoneNumber, password);
        if (result.statusCode == 200) {
          final UserModel? loggedInUser =
        UserModel.fromMap(jsonDecode(result.body));
          if (loggedInUser!=null) {
            Provider.of<User>(context, listen: false).login(loggedInUser);
            SharedPreferences preferences = await SharedPreferences.getInstance();
            preferences
                .setStringList('user', [loggedInUser.token!, loggedInUser.id!]);
            DisplayToast.displaySuccessToast(context, 'Đăng nhập thành công');
            Timer(const Duration(seconds: 2), () {
              // 3 seconds over, navigate to Page2.
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => const HomePage()));
            });
          }
          else {
            DisplayToast.displayErrorToast(context, "Sai số điện thoại hoặc mật khẩu");
          }
        } else {
          DisplayToast.displayErrorToast(context, 'Đăng nhập thất bại');
        }
      }
    } catch (e) {
      DisplayToast.displayErrorToast(context, 'Đăng nhập thất bại fail');
    }
  }
}
