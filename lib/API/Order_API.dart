import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:ssumake/Model/CartOrder/order_model.dart';
import '../Constants/uri.dart';
import '../Model/CartOrder/order_detail_model.dart';

class OrderAPI {
  OrderAPI._();

  static Future<dynamic> addOrder(OrderModel order, String? token) async {
    try {
      print('mua');
      if (order.custormerId != null &&
          order.custormerId!.isNotEmpty &&
          order.dateCreate != null &&
          order.address != null &&
          order.address!.isNotEmpty &&
          order.orderDetails != null &&
          order.orderDetails != List<OrderDetailModel>.empty() &&
          token != null &&
          token.isNotEmpty) {
        print(jsonEncode({
          "custormerId": order.custormerId,
          "dateCreate": order.dateCreate!.toIso8601String(),
          "address": order.address,
          "paymentMethodId": order.paymentMethodId,
          "totalPrice": order.totalPrice,
          "discountId": order.discountId,
          "status": order.status,
          "orderDetails": jsonEncode(order.orderDetails),
        }));
        final response =
            await http.post(Uri.parse(URI.BASE_URI + URI.CHANGE_CUSTOMER_INFO),
                headers: <String, String>{
                  'Content-Type': 'application/json; charset=UTF-8',
                  'Accept': 'application/json',
                  'Authorization': 'Bearer $token',
                },
                body: jsonEncode({
                  "custormerId": order.custormerId,
                  "dateCreate": order.dateCreate!.toIso8601String(),
                  "address": order.address,
                  "paymentMethodId": order.paymentMethodId,
                  "totalPrice": order.totalPrice,
                  "discountId": order.discountId,
                  "status": order.status,
                  "orderDetails": jsonEncode(order.orderDetails),
                }));
        print(response.statusCode);
        return response.statusCode;
      }
    } catch (e) {
      throw Exception('Thêm order thất bại');
    }
  }
}
