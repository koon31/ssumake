import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ssumake/API/login_API.dart';
import 'package:ssumake/Model/User/change_phone_number.dart';
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
        return response.statusCode;
      }
    } catch (e) {
      throw Exception('Đổi số điện thoại thất bại');
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
            Uri.parse(URI.BASE_URI + URI.CHANGE_EMAIL),
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
        return response.statusCode;
      }
    } catch (e) {
      throw Exception('Đổi Email thất bại');
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
          updateUserModel.address!.isNotEmpty &&
          updateUserModel.cwtId != 0 &&
          token != null &&
          token.isNotEmpty) {
        print(updateUserModel.address);
        final response =
            await http.post(Uri.parse(URI.BASE_URI + URI.CHANGE_CUSTOMER_INFO),
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
        return response.statusCode;
      }
    } catch (e) {
      throw Exception('Đổi thông tin thất bại');
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
        await http.post(Uri.parse(URI.BASE_URI + URI.CHECK_CHANGE_INFO),
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
        return response.statusCode;
      }
    } catch (e) {
      throw Exception('Không thể đổi thông tin');
    }
  }
}
