import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ssumake/Constants/color.dart';
import '../API/register_API.dart';
import '../API/update_user_API.dart';
import '../CommonFeatures/custom_button.dart';
import '../CommonFeatures/display_toast.dart';
import '../CommonFeatures/input_decoration.dart';
import '../Model/User/change_phone_number.dart';
import '../Model/User/user_model.dart';
import 'update_user_page.dart';

class ModalBottomSheetUpdateUserPhone extends StatefulWidget {
  const ModalBottomSheetUpdateUserPhone({Key? key}) : super(key: key);

  @override
  State<ModalBottomSheetUpdateUserPhone> createState() =>
      _ModalBottomSheetUpdateUserPhoneState();
}

class _ModalBottomSheetUpdateUserPhoneState
    extends State<ModalBottomSheetUpdateUserPhone> {
  final GlobalKey<FormState> _formKeyPhoneUpdate = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKeyNewPhoneUpdate = GlobalKey<FormState>();

  final _oldPhoneController = TextEditingController();
  final _newPhoneController = TextEditingController();
  final _confirmNewPhoneController = TextEditingController();
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
          key: _formKeyPhoneUpdate,
          child: Container(
            color: Colors.white,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  RoundedInputField(
                    controller: _oldPhoneController,
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
                  Form(
                    key: _formKeyNewPhoneUpdate,
                    child: RoundedInputField(
                      controller: _newPhoneController,
                      hintText: "Số Điện Thoại mới",
                      icon: Icons.phone,
                      type: TextInputType.phone,
                      onChanged: (value) {},
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Vui lòng điền đầy đủ thông tin';
                        } else if (value == _oldPhoneController.text) {
                          return 'Số Điện Thoại mới phải khác Số Điện Thoại cũ';
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
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: kDefaultPadding / 2,
                        horizontal: kDefaultPadding * 2.4),
                    child: Row(
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
                            press: () async {
                              if (_formKeyNewPhoneUpdate.currentState!
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
                    controller: _confirmNewPhoneController,
                    hintText: "Xác nhận Số Điện Thoại mới",
                    icon: Icons.phone,
                    type: TextInputType.phone,
                    onChanged: (value) {},
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Vui lòng điền đầy đủ thông tin';
                      } else if (value != _newPhoneController.text) {
                        return 'Số Điện Thoại phải xác trùng với Số Điện Thoại mới';
                      } else {
                        return null;
                      }
                    },
                  ),
                  CustomButtonLarge(
                    text: "Cập nhật số điện thoại",
                    press: () {
                      if (_formKeyPhoneUpdate.currentState!.validate()) {
                        onClickChangeNumber();
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
                  'Cập nhật số điện thoại',
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

  Future<void> onClickChangeNumber() async {
    try {
      ChangePhoneNumberUserModel user = ChangePhoneNumberUserModel(
          emailOrPhoneChange: _newPhoneController.text,
          phoneNumber: _oldPhoneController.text,
          codeVerify: _verifyController.text);
      final result = await UpdateUserAPI.changePhoneNumber(user);
      print(result);
      if (result.statusCode == 200) {
        if(result.body == "true") {
          int count = 0;
          Navigator.of(context).popUntil((_) => count++ >= 3);
          Navigator.push(context,
              MaterialPageRoute(builder: (context) {
                return const UpdateUserPage();
              }));
          DisplayToast.displaySuccessToast(
              context, 'Đổi số điện thoại thành công');
        }
        else {
          DisplayToast.displayErrorToast(context, result.body);
        }
      } else {
        DisplayToast.displayErrorToast(context, 'Đổi số điện thoại thất bại');
      }
    } catch (e) {
      DisplayToast.displayErrorToast(
          context, 'Đổi số điện thoại thất bại fail');
    }
  }

  Future<bool> onClickGetCodeVerify() async {
    try {
      var provider = Provider.of<User>(context, listen: false);
      UserModel user = provider.user!;
      if (_newPhoneController.text != user.phoneNumber) {
        print(_newPhoneController.text);
        final result =
            await RegisterAPI.getCodeVerifyPhone(_newPhoneController.text);
        if (result.statusCode == 200) {
          if(result.body == "true") {
            DisplayToast.displaySuccessToast(
                context, 'Lấy mã xác thực thành công');
            return true;
          }
          else {
            DisplayToast.displayErrorToast(context, result.body);
            return false;
          }
        } else {
          DisplayToast.displayErrorToast(context, 'Lấy mã xác thực thất bại');
          return false;
        }
      } else {
        DisplayToast.displayErrorToast(
            context, 'Số điện thoại mới không được trùng');
        return false;
      }
    } catch (e) {
      DisplayToast.displayErrorToast(context, 'Lấy mã xác thực thất bại fail');
      return false;
    }
  }
}
