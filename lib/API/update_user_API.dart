import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ssumake/API/login_API.dart';
import 'package:ssumake/Model/User/change_password.dart';
import 'package:ssumake/Model/User/change_phone_number.dart';
import 'package:ssumake/Model/User/forgot_password.dart';
import 'package:ssumake/Model/User/update_user_model.dart';
import '../Constants/uri.dart';
import '../Model/User/change_email.dart';

class UpdateUserAPI {
  UpdateUserAPI._();

  static Future<dynamic> changePhoneNumber(
      ChangePhoneNumberUserModel changePhoneNumberUser) async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      var user = preferences.getStringList('user');
      String? token;
      if(user!=null) token = user[0];
      print(token);
      if (changePhoneNumberUser.emailOrPhoneChange!.isNotEmpty &&
          changePhoneNumberUser.phoneNumber!.isNotEmpty &&
          changePhoneNumberUser.codeVerify!.isNotEmpty) {
        final response = await http.post(
            Uri.parse(URI.BASE_URI + URI.CHANGE_PHONE_NUMBER),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
              'Accept': 'application/json',
        'Authorization': 'Bearer $token',
            },
            body: jsonEncode({
              "emailOrPhoneChange": changePhoneNumberUser.emailOrPhoneChange,
              "codeVerify": changePhoneNumberUser.codeVerify,
              "phonenumber": changePhoneNumberUser.phoneNumber,
            }));
        print(response.body);
        return response;
      }
    } catch (e) {
      print('Đổi số điện thoại thất bại');
    }
  }

  static Future<dynamic> changeEmail(
      ChangeEmailUserModel changeEmailUser) async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      var user = preferences.getStringList('user');
      String? token;
      if(user!=null) token = user[0];
      print(token);
      if (changeEmailUser.emailOrPhoneChange!.isNotEmpty &&
          changeEmailUser.phoneNumber!.isNotEmpty &&
          changeEmailUser.codeVerify!.isNotEmpty) {
        final response = await http.post(
            Uri.parse((URI.EDITABLE_BASE_URI.isEmpty?URI.BASE_URI:URI.EDITABLE_BASE_URI) + URI.CHANGE_EMAIL),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
              'Accept': 'application/json',
        'Authorization': 'Bearer $token',
            },
            body: jsonEncode({
              "emailOrPhoneChange": changeEmailUser.emailOrPhoneChange,
              "codeVerify": changeEmailUser.codeVerify,
              "phonenumber": changeEmailUser.phoneNumber,
            }));
        print(response.body);
        return response;
      }
    } catch (e) {
      print('Đổi Email thất bại');
    }
  }

  static Future<dynamic> changePassword(
      ChangePasswordModel changePassword) async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      var user = preferences.getStringList('user');
      String? token;
      if(user!=null) token = user[0];
      print(token);
      if (changePassword.phonenumber!.isNotEmpty &&
          changePassword.newPassword!.isNotEmpty &&
          changePassword.oldPassword!.isNotEmpty) {
        final response = await http.post(
            Uri.parse((URI.EDITABLE_BASE_URI.isEmpty?URI.BASE_URI:URI.EDITABLE_BASE_URI) + URI.CHANGE_PASSWORD),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
              'Accept': 'application/json',
              'Authorization': 'Bearer $token',
            },
            body: jsonEncode({
              "phonenumber": changePassword.phonenumber,
              "newPassword": changePassword.newPassword,
              "oldPassword": changePassword.oldPassword,
            }));
        print(response.body);
        return response;
      }
    } catch (e) {
      print('Đổi Password thất bại');
    }
  }

  static Future<dynamic> forgotPassword(
      ForgotPasswordModel forgotPassword) async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      var user = preferences.getStringList('user');
      String? token;
      if(user!=null) token = user[0];
      print(token);
      if (forgotPassword.phonenumber!.isNotEmpty &&
          forgotPassword.code!.isNotEmpty &&
          forgotPassword.newPassword!.isNotEmpty) {
        final response = await http.post(
            Uri.parse((URI.EDITABLE_BASE_URI.isEmpty?URI.BASE_URI:URI.EDITABLE_BASE_URI) + URI.FORGOT_PASSWORD),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
              'Accept': 'application/json',
              'Authorization': 'Bearer $token',
            },
            body: jsonEncode({
              "phonenumber": forgotPassword.phonenumber,
              "code": forgotPassword.code,
              "newPassword": forgotPassword.newPassword,
            }));
        print(response.body);
        return response;
      }
    } catch (e) {
       print('Đổi mật khẩu thất bại');
    }
  }

  static Future<dynamic> updateCustomerInfo(
      UpdateUserModel updateUserModel) async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      var user = preferences.getStringList('user');
      String? token;
      if(user!=null) token = user[0];
      print(token);
      if (updateUserModel.customerId!.isNotEmpty &&
          updateUserModel.fullname!.isNotEmpty &&
          token != null && token.isNotEmpty) {
        print(updateUserModel.address);
        final response =
            await http.post(Uri.parse((URI.EDITABLE_BASE_URI.isEmpty?URI.BASE_URI:URI.EDITABLE_BASE_URI) + URI.CHANGE_CUSTOMER_INFO),
                headers: <String, String>{
                  'Content-Type': 'application/json; charset=UTF-8',
                  'Accept': 'application/json',
                  'Authorization': 'Bearer $token',
                },
                body: jsonEncode({
                  "customerId": updateUserModel.customerId,
                  "gender": updateUserModel.gender==1?true:false,
                  "fullname": updateUserModel.fullname,
                  "address": updateUserModel.address,
                  "cwtId": updateUserModel.cwtId,
                }));
        print(response.body);
        return response;
      }
    } catch (e) {
      print('Đổi thông tin thất bại');
    }
  }

  static Future<dynamic> getCodeVerifyPhoneForgotPassword(String phoneNumber) async {
    try {
      if (phoneNumber.isNotEmpty) {
        print('lay ma xac thuc');
        final response = await http.get(
            Uri.parse((URI.EDITABLE_BASE_URI.isEmpty?URI.BASE_URI:URI.EDITABLE_BASE_URI) + URI.GET_CODE_VERIFY_PHONE_FORGOT_PASSWORD+phoneNumber),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8'
            });
        print(response.statusCode);
        return response;
      }
    } catch (e) {
      print('Lấy mã xác thực thất bại fail');
    }
  }

  static Future<dynamic> checkChangeInfo(
      String? phoneNumber, String? password) async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      var user = preferences.getStringList('user');
      String? token;
      if(user!=null) token = user[0];
      print(token);
      String? deviceId = await LoginAPI.getDeviceId();
      if ( phoneNumber != null &&
      phoneNumber.isNotEmpty &&
          password != null &&
          password.isNotEmpty &&
          token != null &&
          token.isNotEmpty && deviceId!=null && deviceId.isNotEmpty) {
        final response =
        await http.post(Uri.parse((URI.EDITABLE_BASE_URI.isEmpty?URI.BASE_URI:URI.EDITABLE_BASE_URI) + URI.CHECK_CHANGE_INFO),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
              'Accept': 'application/json',
              'Authorization': 'Bearer $token',
            },
            body: jsonEncode({
              "username": phoneNumber,
              "password": password,
              "uidPhone": deviceId
            }));
        print(response.body);
        return response;
      }
    } catch (e) {
      print('Không thể đổi thông tin');
    }
  }
}
