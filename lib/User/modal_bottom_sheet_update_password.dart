import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ssumake/Constants/color.dart';
import 'package:ssumake/Model/User/change_password.dart';
import 'package:ssumake/User/update_user_page.dart';

import '../API/update_user_API.dart';
import '../CommonFeatures/custom_button.dart';
import '../CommonFeatures/display_toast.dart';
import '../CommonFeatures/input_decoration.dart';
import '../Model/User/user_model.dart';

class ModalBottomSheetUpdatePassword extends StatefulWidget {
  const ModalBottomSheetUpdatePassword({Key? key}) : super(key: key);

  @override
  State<ModalBottomSheetUpdatePassword> createState() =>
      _ModalBottomSheetUpdatePasswordState();
}

class _ModalBottomSheetUpdatePasswordState
    extends State<ModalBottomSheetUpdatePassword> {
  final GlobalKey<FormState> _formKeyPasswordUpdate = GlobalKey<FormState>();

  final _oldPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmNewPasswordController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        titleModalBottomSheet(),
        Form(
          key: _formKeyPasswordUpdate,
          child: Container(
            color: Colors.white,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  RoundedPasswordField(
                    controller: _oldPasswordController,
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
                    text: "Cập nhật mật khẩu",
                    press: () async {
                      if (_formKeyPasswordUpdate.currentState!.validate()) {
                        if(await onClickCheckChange()){
                          await onClickChangePassword();
                        }
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
                  'Xác nhận mật khẩu',
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

  Future<bool> onClickCheckChange() async {
    try {
      UserModel? u = Provider.of<User>(context, listen: false).user;
      var result;
      if (u != null && u.phoneNumber != null) {
        result = await UpdateUserAPI.checkChangeInfo(
            u.phoneNumber, _oldPasswordController.text);
        print(result.body);
        if (result.statusCode == 200) {
          if (result.body == "true") {
            return true;
          }
          else {
            DisplayToast.displayErrorToast(context, 'Sai mật khẩu');
            return false;
          }
        } else {
          DisplayToast.displayErrorToast(context, 'Sai mật khẩu');
          return false;
        }
      }
      else {
        DisplayToast.displayErrorToast(context, 'Vui lòng đăng nhập lại');
        return false;
      }
    } catch (e) {
      DisplayToast.displayErrorToast(context, 'Sai mật khẩu fail');
      return false;
    }
  }

  Future<void> onClickChangePassword() async {
    try {
      UserModel? u = Provider.of<User>(context, listen: false).user;
      if (u != null && u.phoneNumber != null) {
        ChangePasswordModel user = ChangePasswordModel(phonenumber: u.phoneNumber, newPassword: _newPasswordController.text, oldPassword: _oldPasswordController.text);
        final result = await UpdateUserAPI.changePassword(user);
        //print(result.body);
        if (result.statusCode == 200) {
          if (result.body == 'true') {
            int count = 0;
            Navigator.of(context).popUntil((_) => count++ >= 3);
            Navigator.push(context,
                MaterialPageRoute(builder: (context) {
                  return const UpdateUserPage();
                }));
            DisplayToast.displaySuccessToast(
                context, 'Đổi mật khẩu thành công');
          }
          else {
            DisplayToast.displayErrorToast(context, result.body);
          }
        }
        else {
          DisplayToast.displayErrorToast(context, 'Đổi mật khẩu thất bại');
        }
      } else {
        DisplayToast.displayErrorToast(context, 'Vui lòng đăng nhập lại');
      }
    } catch (e) {
      DisplayToast.displayErrorToast(
          context, 'Đổi email thất bại fail');
    }
  }
}
