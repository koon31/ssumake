import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import '../Constants/uri.dart';
import '../Model/User/register_user_model.dart';

class RegisterAPI {
  RegisterAPI._();

  static Future<dynamic> register(
      RegisterUserModel userRegister, String codeVerify) async {
    try {
      if (codeVerify.isNotEmpty &&
          userRegister.password!.isNotEmpty &&
          userRegister.phoneNumber!.isNotEmpty &&
          userRegister.fullname!.isNotEmpty) {
        //String dob = DateFormat('yyyy-MM-dd').format(userRegister.dateofbirth!);
        final response = await http.post(
            Uri.parse(URI.BASE_URI + URI.USER_REGISTER + "?code=" + codeVerify),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8'
            },
            body: jsonEncode({
              "phoneNumber": userRegister.phoneNumber,
              "password": userRegister.password,
              "dayOfBirth": userRegister.dateofbirth!.toIso8601String(),
              "gender": userRegister.gender==1?true:false,
              "fullname": userRegister.fullname,
            }));
        print(response.statusCode);
        print(response.body);
        return response.statusCode;
      }
    } catch (e) {
      throw Exception('Đăng ký thất bại');
    }
  }

  static Future<dynamic> getCodeVerifyPhone(String phoneNumber) async {
    try {
      if (phoneNumber.isNotEmpty) {
        print('lay ma xac thuc');
        final response = await http.get(
            Uri.parse(URI.BASE_URI + URI.GET_CODE_VERIFY_PHONE + phoneNumber),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8'
            });
        print(response.statusCode);
        return response.statusCode;
      }
    } catch (e) {
      throw Exception('Lấy mã xác thực thất bại');
    }
  }
  static Future<dynamic> getCodeVerifyEmail(String email) async {
    try {
      if (email.isNotEmpty) {
        print('lay ma xac thuc');
        //email = email.replaceAll(RegExp(r'@'), '%40');
        // print(email);
        final response = await http.get(
            Uri.parse(URI.BASE_URI + URI.GET_CODE_VERIFY_EMAIL + email),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8'
            });
        print(response.statusCode);
        print(response.body);
        return response.statusCode;
      }
    } catch (e) {
      throw Exception('Lấy mã xác thực thất bại');
    }
  }
}
