// ignore_for_file: constant_identifier_names

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:ssumake/API/register_API.dart';
import 'package:ssumake/Login_Register/Register/register_background.dart';
import 'package:ssumake/CommonFeatures/custom_button.dart';
import 'package:ssumake/Model/User/register_user_model.dart';

import '../../CommonFeatures/display_toast.dart';
import '../../Constants/color.dart';
import '../../CommonFeatures/input_decoration.dart';
import '../../Constants/global_var.dart';
import '../../Homepage/home_page.dart';
import '../Login/already_have_an_account.dart';
import '../Login/login_page.dart';

class RegisterBody extends StatefulWidget {
  const RegisterBody({Key? key}) : super(key: key);

  @override
  State<RegisterBody> createState() => _RegisterBodyState();
}

class _RegisterBodyState extends State<RegisterBody> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKeyPhone = GlobalKey<FormState>();

  late DateTime _selectedDate = DateTime.now();
  final DateTime _firstDate = DateTime(1900, 1);
  final DateTime _lastDate = DateTime.now();
  Gender _gender = Gender.Male;

  bool _isEnableTextFormField = false;

  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _verifyController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: RegisterBackground(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: kDefaultPadding / 2 * 5),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "Đăng Ký Thành Viên".toUpperCase(),
                    style: const TextStyle(
                        color: kPrimaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 26),
                  ),
                  SizedBox(height: size.height * 0.03),
                  SvgPicture.asset(
                    "assets/icons/signup.svg",
                    height: size.height * 0.35,
                  ),
                  Form(
                    key: _formKeyPhone,
                    child: RoundedInputField(
                      controller: _phoneController,
                      hintText: "Số Điện Thoại",
                      icon: Icons.phone,
                      type: TextInputType.phone,
                      onChanged: (value) {},
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Vui lòng điền đầy đủ thông tin';
                        } else if (value.length > 11) {
                          return 'Số Điện Thoại phải nhập bé hơn 12 ký tự';
                        } else if (!RegExp(r'^(\+84|0[1|3|5|7|8|9])+([0-9]{8})')
                            .hasMatch(value)) {
                          return 'Số điện thoại không đúng số điện thoại Việt Nam';
                        } else {
                          return null;
                        }
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: kDefaultPadding / 2,
                        horizontal: kDefaultPadding * 2.4),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: size.width / 2.4,
                          child: VerifyRoundedInputField(
                            controller: _verifyController,
                            hintText: "Xác thực SĐT",
                            isEnable: _isEnableTextFormField,
                            type: TextInputType.number,
                            onChanged: (value) {},
                            validator: (value) {
                              if (value!.isEmpty || value.length != 6) {
                                return 'Vui lòng điền đầy đủ mã xác thực bao gồm 6 số';
                              } else {
                                return null;
                              }
                            },
                          ),
                        ),
                        const Spacer(),
                        CustomVerifyButton(
                            text: 'Xác thực SĐT',
                            press: () {
                              if (_formKeyPhone.currentState!.validate()) {
                                onClickGetCodeVerify(_phoneController.text);
                                print('enable');
                                setState(() {
                                  _isEnableTextFormField = true;
                                });
                              } else {
                                print('disable');
                                setState(() {
                                  _isEnableTextFormField = false;
                                });
                              }
                            }),
                      ],
                    ),
                  ),
                  RoundedInputField(
                    controller: _nameController,
                    onChanged: (value) {},
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Vui lòng điền đầy đủ thông tin';
                      } else {
                        return null;
                      }
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: kDefaultPadding * 2.4,
                        vertical: kDefaultPadding / 2),
                    child: GestureDetector(
                      onTap: () async {
                        DateTime? newDate = await showDatePicker(
                          initialDate: _lastDate,
                          firstDate: _firstDate,
                          lastDate: _lastDate,
                          helpText: 'Ngày sinh nhật',
                          context: context,
                        );
                        if (newDate != null) {
                          setState(() {
                            _selectedDate = newDate;
                          });
                        }
                      },
                      child: Container(
                        height: size.height * 0.06,
                        decoration: BoxDecoration(
                          color: kPrimaryLightColor,
                          border: Border.all(
                            color: Colors.transparent,
                          ),
                          borderRadius: BorderRadius.circular(28),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: kDefaultPadding),
                          child: Row(children: [
                            const Padding(
                              padding: EdgeInsets.only(
                                  right: kDefaultPadding / 4 * 3),
                              child: Icon(
                                Icons.cake,
                                color: kPrimaryColor,
                              ),
                            ),
                            Text(
                              DateFormat('dd/MM/yyyy').format(_selectedDate),
                              style: const TextStyle(
                                  color: kPrimaryColor, fontSize: 17),
                            ),
                          ]),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: kDefaultPadding * 2.4),
                    child: Row(
                      children: <Widget>[
                        for (var gender in Gender.values)
                          Row(children: [
                            Radio(
                              value: gender,
                              activeColor: Colors.black,
                              groupValue: _gender,
                              onChanged: (value) {
                                setState(() {
                                  print(value);
                                  _gender = value as Gender;
                                });
                              },
                            ),
                            Text(gender.name)
                          ]),
                      ],
                    ),
                  ),
                  RoundedPasswordField(
                    controller: _passwordController,
                    onChanged: (value) {},
                    isConfirm: false,
                    validator: (val) {
                      String errMs = '';
                      if (val!.isEmpty) {
                        return 'Vui lòng điền đầy đủ mật khẩu';
                      } else if (!RegExp(r'^(?=.*?[A-Z])').hasMatch(val)) {
                        errMs.isEmpty ? errMs += '' : errMs += '\n';
                        errMs += 'Mật khẩu cần ít nhất 1 chữ in hoa';
                      } else if (!RegExp(r'^(?=.*[a-z])').hasMatch(val)) {
                        errMs.isEmpty ? errMs += '' : errMs += '\n';
                        errMs += 'Mật khẩu cần ít nhất 1 chữ thường';
                      } else if (!RegExp(r'^(?=.*?[0-9])').hasMatch(val)) {
                        errMs.isEmpty ? errMs += '' : errMs += '\n';
                        errMs += 'Mật khẩu cần ít nhất 1 chữ số';
                      } else if (!RegExp(r'^(?=.*?[!@#\$&*.~])')
                          .hasMatch(val)) {
                        errMs.isEmpty ? errMs += '' : errMs += '\n';
                        errMs += 'Mật khẩu phải bao gồm 1 ký tự đặc biệt';
                      } else if (!RegExp(r'^.{8,}').hasMatch(val)) {
                        errMs.isEmpty ? errMs += '' : errMs += '\n';
                        errMs += 'Mật khẩu cần có ít nhất 8 ký tự';
                      } else {}
                      return errMs.isNotEmpty ? errMs : null;
                    },
                  ),
                  RoundedPasswordField(
                    controller: _confirmPasswordController,
                    onChanged: (value) {},
                    isConfirm: true,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Vui lòng điền đầy đủ nhập lại mật khẩu';
                      } else if (_passwordController.text !=
                          _confirmPasswordController.text) {
                        return "Mật khẩu và nhập lại mật khẩu không trùng khớp";
                      } else {
                        return null;
                      }
                    },
                  ),
                  CustomButtonLarge(
                    text: "Đăng Ký",
                    press: () {
                      bool check = false;
                      if (_formKey.currentState!.validate()) {
                        check = true;
                      } else {
                        check = false;
                      }

                      if (_formKeyPhone.currentState!.validate()) {
                        check = true;
                      } else {
                        check = false;
                      }

                      if (check) {
                        onClickRegister(
                            _passwordController.text,
                            _selectedDate,
                            _phoneController.text,
                            _gender == Gender.Male ? 1 : 0,
                            _nameController.text,
                            _verifyController.text);
                      }
                    },
                  ),
                  SizedBox(height: size.height * 0.03),
                  AlreadyHaveAnAccount(
                    isLoginPage: false,
                    press: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return const LoginPage();
                          },
                        ),
                      );
                    },
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
      ),
    );
  }

  Future<void> onClickRegister(
      String password,
      DateTime dBO,
      String phoneNumber,
      int gender,
      String fullname,
      String codeVerify) async {
    try {
      RegisterUserModel user = RegisterUserModel(
          password: password,
          dateofbirth: dBO,
          phoneNumber: phoneNumber,
          gender: gender,
          fullname: fullname);
      final result = await RegisterAPI.register(user, codeVerify);
      if (result.statusCode == 200) {
        if (result.body == "true") {
          DisplayToast.displaySuccessToast(context, 'Đăng ký thành công');
          Timer(const Duration(seconds: 2), () {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => const LoginPage()));
          });
        } else {
          DisplayToast.displayErrorToast(context, result.body);
        }
      } else {
        DisplayToast.displayErrorToast(context, 'Đăng ký thất bại');
      }
    } catch (e) {
      DisplayToast.displayErrorToast(context, 'Đăng ký thất bại');
    }
  }

  Future<void> onClickGetCodeVerify(String phoneNumber) async {
    try {
      final result = await RegisterAPI.getCodeVerifyPhone(phoneNumber);
      if (result.statusCode == 200) {
        if (result.body == "true") {
          DisplayToast.displaySuccessToast(
              context, 'Lấy mã xác thực thành công');
        } else {
          DisplayToast.displayErrorToast(context, result.body);
        }
      } else {
        DisplayToast.displayErrorToast(context, 'Lấy mã xác thực thất bại');
      }
    } catch (e) {
      DisplayToast.displayErrorToast(context, 'Lấy mã xác thực thất bại fail');
    }
  }
}
