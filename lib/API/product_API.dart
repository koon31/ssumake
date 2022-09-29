import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../Constants/uri.dart';

class ProductAPI {
  ProductAPI._();

  static Future<String> getProducts() async {
    try {
      final response = await http.get(
        Uri.parse((URI.EDITABLE_BASE_URI.isEmpty?URI.BASE_URI:URI.EDITABLE_BASE_URI) + URI.GET_PRODUCT),
      );
      //print(response.body);
      return response.body;
    } catch (e) {
      throw Exception('Lấy hàng thất bại');
    }
  }

  static Future<dynamic> getProductByProductId(int id) async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      var user = preferences.getStringList('user');
      String? token;
      if (user != null) token = user[0];
      if (id != 0 && token != null) {
        final response = await http.get(
          Uri.parse((URI.EDITABLE_BASE_URI.isEmpty?URI.BASE_URI:URI.EDITABLE_BASE_URI) + URI.GET_PRODUCT_BY_ID + id.toString()),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          },
        );
        return response.body;
      }
    } catch (e) {
      throw Exception('Lấy hàng thất bại');
    }
  }
}
