import 'dart:async';
import 'package:http/http.dart' as http;
import '../Constants/uri.dart';

class LocationAPI {

  static Future<dynamic> getLocationByCWTId(String cwtId) async {
    try {
      final response = await http.get(
          Uri.parse((URI.EDITABLE_BASE_URI.isEmpty?URI.BASE_URI:URI.EDITABLE_BASE_URI) + URI.GET_LOCATION_BY_CWT + cwtId),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8'
          });
      return response.body;
    } catch (e) {
      throw Exception('Lấy thông tin Location thất bại');
    }
  }
}