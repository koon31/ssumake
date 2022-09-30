import 'dart:convert';

import 'package:http/http.dart' as http;
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
        print(userRegister.dateofbirth!.toIso8601String());
        final response = await http.post(
            Uri.parse((URI.EDITABLE_BASE_URI.isEmpty?URI.BASE_URI:URI.EDITABLE_BASE_URI) + URI.USER_REGISTER + "?code=" + codeVerify),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8'
            },
            body: jsonEncode({
              "phonenumber": userRegister.phoneNumber,
              "password": userRegister.password,
              "dateofbirth": userRegister.dateofbirth!.toIso8601String(),
              "gender": userRegister.gender==1?true:false,
              "fullname": userRegister.fullname,
            }));
        print(response.statusCode);
        print(response.body);
        return response;
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
            Uri.parse((URI.EDITABLE_BASE_URI.isEmpty?URI.BASE_URI:URI.EDITABLE_BASE_URI) + URI.GET_CODE_VERIFY_PHONE + phoneNumber),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8'
            });
        print(response.statusCode);
        return response;
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
            Uri.parse((URI.EDITABLE_BASE_URI.isEmpty?URI.BASE_URI:URI.EDITABLE_BASE_URI) + URI.GET_CODE_VERIFY_EMAIL + email),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8'
            });
        return response;
      }
    } catch (e) {
      throw Exception('Lấy mã xác thực thất bại');
    }
  }
}
