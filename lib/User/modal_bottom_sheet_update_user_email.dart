import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ssumake/Constants/color.dart';
import 'package:ssumake/Model/User/change_email.dart';
import 'package:ssumake/User/update_user_page.dart';
import '../API/register_API.dart';
import '../API/update_user_API.dart';
import '../CommonFeatures/custom_button.dart';
import '../CommonFeatures/display_toast.dart';
import '../CommonFeatures/input_decoration.dart';
import '../Model/User/user_model.dart';

class ModalBottomSheetUpdateUserEmail extends StatefulWidget {
  const ModalBottomSheetUpdateUserEmail({Key? key}) : super(key: key);

  @override
  State<ModalBottomSheetUpdateUserEmail> createState() =>
      _ModalBottomSheetUpdateUserEmailState();
}

class _ModalBottomSheetUpdateUserEmailState
    extends State<ModalBottomSheetUpdateUserEmail> {
  final GlobalKey<FormState> _formKeyEmailUpdate = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKeyNewEmailUpdate = GlobalKey<FormState>();

  final _newEmailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _verifyController = TextEditingController();

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
          key: _formKeyEmailUpdate,
          child: Container(
            color: Colors.white,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Form(
                    key: _formKeyNewEmailUpdate,
                    child: RoundedInputField(
                      controller: _newEmailController,
                      hintText: "Email mới",
                      icon: Icons.email,
                      type: TextInputType.emailAddress,
                      onChanged: (value) {},
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Vui lòng điền đầy đủ thông tin';
                        } else if (!RegExp(r'^[a-zA-Z0-9.!#$%&*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$')
                            .hasMatch(value)) {
                          return 'Email không hợp lệ';
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
                              hintText: "Xác thực Email",
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
                            text: 'Xác thực Email',
                            press: () async {
                              if (_formKeyNewEmailUpdate.currentState!
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
                  RoundedInputField(
                    controller: _phoneController,
                    hintText: "Số Điện Thoại",
                    icon: Icons.phone,
                    type: TextInputType.phone,
                    onChanged: (value) {},
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Vui lòng điền đầy đủ thông tin';
                      } else if (value != Provider.of<User>(context, listen: false).user!.phoneNumber!) {
                        return 'Số Điện Thoại không khớp với Số Điện Thoại đã đăng kí';
                      }else if (value.length > 11) {
                        return 'Số Điện Thoại phải nhập bé hơn 12 ký tự';
                      }
                      else if (!RegExp(r'^(\+84|0[1|3|5|7|8|9])+([0-9]{8})')
                          .hasMatch(value)) {
                        return 'Số điện thoại không đúng số điện thoại Việt Nam';
                      } else {
                        return null;
                      }
                    },
                  ),
                  CustomButtonLarge(
                    text: "Cập nhật email",
                    press: () {
                      if (_formKeyEmailUpdate.currentState!.validate()) {
                        if(_formKeyNewEmailUpdate.currentState!.validate()){
                          onClickChangeEmail();
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
                  'Cập nhật email',
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

  Future<void> onClickChangeEmail() async {
    try {
      ChangeEmailUserModel user = ChangeEmailUserModel(
          emailOrPhoneChange: _newEmailController.text,
          phoneNumber: _phoneController.text,
          codeVerify: _verifyController.text);
      final result = await UpdateUserAPI.changeEmail(user);
      print(result);
      if (result.statusCode == 200) {
        if (result.body == "true") {
          int count = 0;
          Navigator.of(context).popUntil((_) => count++ >= 3);
          Navigator.push(context,
              MaterialPageRoute(builder: (context) {
                return const UpdateUserPage();
              }));
          DisplayToast.displaySuccessToast(
              context, 'Đổi email thành công');
        }
        else {
          DisplayToast.displayErrorToast(context, result.body);
        }
      } else {
        DisplayToast.displayErrorToast(context, 'Đổi email thất bại');
      }
    } catch (e) {
      DisplayToast.displayErrorToast(
          context, 'Đổi email thất bại fail');
    }
  }

  Future<bool> onClickGetCodeVerify() async {
    try {
      var provider = Provider.of<User>(context, listen: false);
      UserModel user = provider.user!;
      if (_newEmailController.text != user.email) {
        print(_newEmailController.text);
        final result =
        await RegisterAPI.getCodeVerifyEmail(_newEmailController.text);
        if (result == 200) {
          DisplayToast.displaySuccessToast(
              context, 'Lấy mã xác thực thành công');
          return true;
        } else {
          DisplayToast.displayErrorToast(context, 'Lấy mã xác thực thất bại');
          return false;
        }
      } else {
        DisplayToast.displayErrorToast(
            context, 'Email mới không được trùng');
        return false;
      }
    } catch (e) {
      DisplayToast.displayErrorToast(context, 'Lấy mã xác thực thất bại fail');
      return false;
    }
  }
}
