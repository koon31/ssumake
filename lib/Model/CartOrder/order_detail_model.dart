
import 'dart:convert';

import 'package:flutter/material.dart';

class OrderDetailHistory with ChangeNotifier{
  List<OrderDetailModel> orderDetailHistory = List<OrderDetailModel>.empty();

  void getAllOrderDetailHistoryFromAPI(String str) {
    orderDetailHistory = List<OrderDetailModel>.from(
        json.decode(str).map((x) => OrderDetailModel.fromJson(x)));
    notifyListeners();
  }

  void removeAllOrderDetailHistory() {
    if (orderDetailHistory.isNotEmpty) {
      orderDetailHistory.clear();
      notifyListeners();
    }
  }
}

class OrderDetailModel {
  int? productId;
  int? quantity;
  double? price;

  OrderDetailModel.empty() {
    productId = 0;
    quantity = 0;
    price = 0;
  }

  OrderDetailModel(
      {required this.productId,
        required this.quantity,
        required this.price});


  factory OrderDetailModel.fromJson(Map<String, dynamic> json) => OrderDetailModel(
    productId: json["productId"],
    quantity: json["quantity"],
    price: json["price"].toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "productId": productId,
    "quantity": quantity,
    "price": price,
  };
}