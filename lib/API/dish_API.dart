import 'package:http/http.dart' as http;
import '../Constants/uri.dart';

class DishAPI {
  DishAPI._();

  static Future<dynamic> getDishByProductId(String? productId) async {
    try {
      if (productId!=null && productId.isNotEmpty) {
        final response = await http.get(
          Uri.parse((URI.EDITABLE_BASE_URI.isEmpty?URI.BASE_URI:URI.EDITABLE_BASE_URI) + URI.GET_DISH_BY_PRODUCT+productId),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Accept': 'application/json',
          },
        );
        //print(response.body);
        return response.body;
      }
    } catch (e) {
      throw Exception('Lấy món ăn thất bại');
    }
  }
}