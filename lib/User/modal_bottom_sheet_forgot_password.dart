import 'dart:async';

import 'package:flutter/material.dart';
import 'package:ssumake/Constants/color.dart';
import 'package:ssumake/Model/User/forgot_password.dart';
import '../API/update_user_API.dart';
import '../CommonFeatures/custom_button.dart';
import '../CommonFeatures/display_toast.dart';
import '../CommonFeatures/input_decoration.dart';

class ModalBottomSheetForgotPassword extends StatefulWidget {
  const ModalBottomSheetForgotPassword({Key? key}) : super(key: key);

  @override
  State<ModalBottomSheetForgotPassword> createState() =>
      _ModalBottomSheetForgotPasswordState();
}

class _ModalBottomSheetForgotPasswordState
    extends State<ModalBottomSheetForgotPassword> {
  final GlobalKey<FormState> _formKeyPhoneForgotPassword =
      GlobalKey<FormState>();
  final GlobalKey<FormState> _formKeyVerifyPhoneForgotPassword =
      GlobalKey<FormState>();

  final _phoneController = TextEditingController();
  final _verifyController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmNewPasswordController = TextEditingController();

  bool _isEnableTextFormField = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Column(
      children: [
        titleModalBottomSheet(),
        Form(
          key: _formKeyPhoneForgotPassword,
          child: Container(
            color: Colors.white,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Form(
                    key: _formKeyVerifyPhoneForgotPassword,
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
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding:
                              const EdgeInsets.only(right: kDefaultPadding),
                          child: SizedBox(
                            width: size.width / 2.12,
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
                        ),
                        CustomVerifyButton(
                            text: 'Xác thực SĐT',
                            press: () async {
                              if (_formKeyVerifyPhoneForgotPassword
                                  .currentState!
                                  .validate()) {
                                if (await onClickGetCodeVerify()) {
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
                  RoundedPasswordField(
                    controller: _newPasswordController,
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
                    controller: _confirmNewPasswordController,
                    onChanged: (value) {},
                    isConfirm: true,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Vui lòng điền đầy đủ nhập lại mật khẩu';
                      } else if (_newPasswordController.text !=
                          _confirmNewPasswordController.text) {
                        return "Mật khẩu và nhập lại mật khẩu không trùng khớp";
                      } else {
                        return null;
                      }
                    },
                  ),
                  CustomButtonLarge(
                    text: "Cập nhật số điện thoại",
                    press: () {
                      bool check = false;
                      if (_formKeyVerifyPhoneForgotPassword.currentState!
                          .validate()) {
                        check = true;
                      } else {
                        check = false;
                      }

                      if (_formKeyPhoneForgotPassword.currentState!
                          .validate()) {
                        check = true;
                      } else {
                        check = false;
                      }
                      if (check) {
                        onClickForgotPassword();
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
        Padding(padding: MediaQuery.of(context).viewInsets),
      ],
    );
  }

  Container titleModalBottomSheet() {
    return Container(
      margin: const EdgeInsets.only(top: kDefaultPadding * 1.4),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20), topRight: Radius.circular(20)),
        color: Colors.grey,
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 1),
        child: Row(
          children: [
            const Expanded(
              child: Padding(
                padding: EdgeInsets.only(left: 46),
                child: Text(
                  'Cập nhật mật khẩu',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.close, size: 23),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20)),
        ),
      ),
    );
  }

  Future<void> onClickForgotPassword() async {
    try {
      ForgotPasswordModel user = ForgotPasswordModel(
          phonenumber: _phoneController.text,
          code: _verifyController.text,
          newPassword: _newPasswordController.text);
      final result = await UpdateUserAPI.forgotPassword(user);
      print(result);
      if (result.statusCode == 200) {
        if (result.body != "false") {
          Navigator.pop(context);
          DisplayToast.displaySuccessToast(context, 'Đổi mật khẩu thành công');
        } else {
          DisplayToast.displayErrorToast(context, result.body);
        }
      } else {
        DisplayToast.displayErrorToast(context, 'Đổi mật khẩu thất bại');
      }
    } catch (e) {
      DisplayToast.displayErrorToast(context, 'Đổi mật khẩu thất bại fail');
    }
  }

  Future<bool> onClickGetCodeVerify() async {
    try {
      final result = await UpdateUserAPI.getCodeVerifyPhoneForgotPassword(
          _phoneController.text);
      if (result.statusCode == 200) {
        if (result.body == "true") {
          DisplayToast.displaySuccessToast(
              context, 'Lấy mã xác thực thành công');
          return true;
        } else {
          DisplayToast.displayErrorToast(context, result.body);
          return false;
        }
      } else {
        DisplayToast.displayErrorToast(context, 'Lấy mã xác thực thất bại');
        return false;
      }
    } catch (e) {
      DisplayToast.displayErrorToast(context, 'Lấy mã xác thực thất bại fail');
      return false;
    }
  }
}
