import 'dart:convert';
import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../Constants/uri.dart';

class LoginAPI {
  LoginAPI._();

  static Future<dynamic> login(String phoneNumber, String password) async {
    try {
      String? deviceId = await getDeviceId();
      print(deviceId);
      if (phoneNumber.isNotEmpty &&
          password.isNotEmpty &&
          deviceId != null &&
          deviceId.isNotEmpty) {
        return await http.post(
            Uri.parse((URI.EDITABLE_BASE_URI.isEmpty?URI.BASE_URI:URI.EDITABLE_BASE_URI) + URI.USER_LOGIN + "?namePage=customerpage"),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8'
            },
            body: jsonEncode({
              "username": phoneNumber,
              "password": password,
              "uidPhone": deviceId
            }));
      }
    } catch (e) {
      throw Exception('Đăng nhập thất bại');
    }
  }

  static Future<String?> getDeviceId() async {
    var deviceInfo = DeviceInfoPlugin();
    if (Platform.isIOS) {
      // import 'dart:io'
      var iosDeviceInfo = await deviceInfo.iosInfo;
      return iosDeviceInfo.identifierForVendor; // unique ID on iOS
    } else if (Platform.isAndroid) {
      var androidDeviceInfo = await deviceInfo.androidInfo;
      return androidDeviceInfo.androidId; // unique ID on Android
    }
    return null;
  }

  static Future<dynamic> getLoggedInUser() async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      var user = preferences.getStringList('user');
      String? token;
      if(user!=null) token = user[0];
      if (user != null && user[1].isNotEmpty && token!=null && token.isNotEmpty) {
        print(user[0]);
        print(user[1]);
        var response = await http.get(
            Uri.parse((URI.EDITABLE_BASE_URI.isEmpty?URI.BASE_URI:URI.EDITABLE_BASE_URI) + URI.GET_LOGGED_IN_USER + user[1]),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
              'Accept': 'application/json',
              'Authorization': 'Bearer $token',
            },);
        print(response.body);
        return response;
      }
    } catch (e) {
      throw Exception('Lấy thông tin khách hàng thất bại');
    }
  }
}
