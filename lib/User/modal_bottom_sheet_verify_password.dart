import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ssumake/CommonFeatures/show_custom_modal_bottom_sheet.dart';
import 'package:ssumake/Constants/color.dart';

import '../API/update_user_API.dart';
import '../CommonFeatures/custom_button.dart';
import '../CommonFeatures/display_toast.dart';
import '../CommonFeatures/input_decoration.dart';
import '../Model/User/user_model.dart';

class ModalBottomSheetCheckPassword extends StatefulWidget {
  const ModalBottomSheetCheckPassword({Key? key, required this.isPhone}) : super(key: key);
  final bool isPhone;

  @override
  State<ModalBottomSheetCheckPassword> createState() =>
      _ModalBottomSheetCheckPasswordState();
}

class _ModalBottomSheetCheckPasswordState
    extends State<ModalBottomSheetCheckPassword> {
  final GlobalKey<FormState> _formKeyPasswordUpdate = GlobalKey<FormState>();

  final _passwordController = TextEditingController();

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
          key: _formKeyPasswordUpdate,
          child: Container(
            color: Colors.white,
            child: SingleChildScrollView(
              child: Column(
                children: [
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
                    text: "Xác nhận mật khẩu",
                    press: () async {
                      if (_formKeyPasswordUpdate.currentState!.validate()) {
                        if(await onClickCheckChange()){
                          ShowModalBottomSheet.showUpdatePhoneEmail(context, widget.isPhone);
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
            u.phoneNumber, _passwordController.text);
        print(result);
        if (result == 200) {
          Navigator.pop(context);
          return true;
        } else {
          DisplayToast.displayErrorToast(context, 'Không thể đổi thông tin');
          return false;
        }
      }
      else {
        return false;
      }
    } catch (e) {
      DisplayToast.displayErrorToast(context, 'Không thể đổi thông tin fail');
      return false;
    }
  }
}
