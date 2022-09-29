import 'dart:async';
import 'package:http/http.dart' as http;
import '../Constants/uri.dart';

class DistrictAPI {
  DistrictAPI._();
  static Future<dynamic> getDistrictsByProvinceId(String provinceId) async {
    try {
      final response = await http.get(
          Uri.parse((URI.EDITABLE_BASE_URI.isEmpty?URI.BASE_URI:URI.EDITABLE_BASE_URI) + URI.GET_DISTRICTS_BY_PROVINCE + provinceId),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8'
          });
      return response.body;
    } catch (e) {
      throw Exception('Lấy thông tin Quận/Huyện thất bại');
    }
  }
}
