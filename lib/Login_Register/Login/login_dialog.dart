import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../API/location_API.dart';
import '../../API/login_API.dart';
import '../../CommonFeatures/custom_button.dart';
import '../../CommonFeatures/display_toast.dart';
import '../../CommonFeatures/input_decoration.dart';
import '../../Constants/color.dart';
import '../../Model/Location/location_model.dart';
import '../../Model/User/user_model.dart';

class LoginDialog extends StatefulWidget {
  const LoginDialog({Key? key}) : super(key: key);

  @override
  State<LoginDialog> createState() => _LoginDialogState();
}

class _LoginDialogState extends State<LoginDialog> {
  GlobalKey<FormState> loginDialogFormKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)), //this right here
      child: SizedBox(
        height: size.width*0.7,
        width: size.width*0.7,
        child: Form(
          key: loginDialogFormKey,
          child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Đăng nhập",
                style: TextStyle(
                    color: kPrimaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 26),
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
              CustomButtonMedium(
                text: "Đăng nhập",
                press: () {
                  if (loginDialogFormKey.currentState!.validate()) {
                    onClickLogin(_phoneController.text, _passwordController.text);
                  }
                },
              ),
            ],
          ),
        ),
    ));
  }

  Future<void> onClickLogin(String phoneNumber, String password) async {
    try {
      if(phoneNumber.isNotEmpty && password.isNotEmpty){
        var userProvider = Provider.of<User>(context, listen: false);
        final result = await LoginAPI.login(phoneNumber, password);
        final UserModel? loggedInUser =
        UserModel.fromMap(jsonDecode(result.body));
        if (loggedInUser != null) {
          userProvider.login(loggedInUser);
          SharedPreferences preferences = await SharedPreferences.getInstance();
          preferences
              .setStringList('user', [loggedInUser.token!, loggedInUser.id!]);
          if(loggedInUser.cwtId==null || loggedInUser.cwtId==0) {
            final resultGetLoggedIn = await LoginAPI.getLoggedInUser();
            final UserModel? loggedInGetUser = UserModel.fromMap(jsonDecode(resultGetLoggedIn.body));
            if(loggedInGetUser!=null) userProvider.login(loggedInGetUser);
          }
          await getLoggedInUserLocation(loggedInUser);
          Navigator.pop(context);
          DisplayToast.displaySuccessToast(context, 'Đăng nhập thành công');
        } else {
          DisplayToast.displayErrorToast(context, 'Đăng nhập thất bại');
        }
      }
    } catch (e) {
      DisplayToast.displayErrorToast(context, 'Đăng nhập thất bại fail');
    }
  }
  Future<void> getLoggedInUserLocation(UserModel? user) async {
    var provider = Provider.of<Location>(context, listen: false);
    String? strLocation;
    if (user != null) {
      if (user.cwtId != null && user.cwtId != 0) {
        strLocation = await LocationAPI.getLocationByCWTId(
            user.cwtId.toString());
      }
      if (strLocation != null && strLocation.isNotEmpty) {
        provider.getLocationFromAPI(strLocation);
      }
    }
  }
}
