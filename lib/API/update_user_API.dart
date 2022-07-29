import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:ssumake/Model/User/change_phone_number.dart';
import 'package:ssumake/Model/User/update_user_model.dart';
import '../Constants/uri.dart';
import '../Model/User/change_email.dart';

class UpdateUserAPI {
  UpdateUserAPI._();

  static Future<dynamic> changePhoneNumber(
      ChangePhoneNumberUserModel changePhoneNumberUser, String? token) async {
    try {
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
      ChangeEmailUserModel changeEmailUser, String? token) async {
    try {
      if (changeEmailUser.emailOrPhoneChange!.isNotEmpty &&
          changeEmailUser.phoneNumber!.isNotEmpty &&
          changeEmailUser.codeVerify!.isNotEmpty) {
        final response = await http.post(
            Uri.parse(URI.BASE_URI + URI.CHANGE_PHONE_NUMBER),
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
      UpdateUserModel updateUserModel, String? token) async {
    try {
      if (updateUserModel.customerId!.isNotEmpty &&
          updateUserModel.fullname!.isNotEmpty &&
          updateUserModel.address!.isNotEmpty &&
          updateUserModel.cwtId != 0 &&
          token != null &&
          token.isNotEmpty) {
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
                  "adress": updateUserModel.address,
                  "cwtId": updateUserModel.cwtId,
                }));
        print(response.body);
        return response.statusCode;
      }
    } catch (e) {
      throw Exception('Đổi thông tin thất bại');
    }
  }
}
