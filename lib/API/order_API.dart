import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ssumake/Model/CartOrder/order_model.dart';
import '../Constants/uri.dart';
import '../Model/CartOrder/order_detail_model.dart';

class OrderAPI {
  OrderAPI._();

  static Future<dynamic> addOrder(OrderModel order) async {
    try {
      print('mua');
      SharedPreferences preferences = await SharedPreferences.getInstance();
      var user = preferences.getStringList('user');
      String? token;
      if(user!=null) token = user[0];
      print(token);
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
          "orderDetails": order.orderDetails,
        }));
        final response =
            await http.post(Uri.parse(URI.BASE_URI + URI.ADD_ORDER),
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
                  "disabled": true,
                  "status": order.status,
                  "orderdetails": order.orderDetails,
                }));
        print(response.statusCode);
        print(response.body);
        return response;
      }
    } catch (e) {
      throw Exception('Thêm order thất bại');
    }
  }

  static Future<dynamic> getOrderHistory(String? customerId) async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      var user = preferences.getStringList('user');
      String? token;
      if(user!=null) token = user[0];
      print(token);
      if (customerId!=null && customerId.isNotEmpty && token!=null && token.isNotEmpty) {
        final response = await http.get(
        Uri.parse(URI.BASE_URI + URI.GET_ORDER+customerId),
          headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
        print(response.body);
        return response.body;
      }
    } catch (e) {
      throw Exception('Lấy lịch sử đơn hàng thất bại');
    }
  }
}
