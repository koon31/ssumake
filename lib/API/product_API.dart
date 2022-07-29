import 'dart:async';
import 'package:http/http.dart' as http;
import '../Constants/uri.dart';

class ProductAPI {
  ProductAPI._();
  static Future<String> getProducts() async {
    try {
      final response = await http.get(
        Uri.parse(URI.BASE_URI + URI.GET_PRODUCT),
      );
      //print(response.body);
      return response.body;
    } catch (e) {
      throw Exception('Lấy hàng thất bại');
    }
  }
}