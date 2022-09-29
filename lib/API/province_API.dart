import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../Constants/uri.dart';
import '../Model/Location/province_model.dart';

class ProvinceAPI {
  ProvinceAPI._();
  static Future<dynamic> getProvinces() async {
    try {
      final response = await http.get(
          Uri.parse((URI.EDITABLE_BASE_URI.isEmpty?URI.BASE_URI:URI.EDITABLE_BASE_URI) + URI.GET_PROVINCES),
          );
      return response.body;
    } catch (e) {
      throw Exception('Lấy thông tin Tỉnh/Thành phố thất bại');
    }
  }
}
