import 'dart:convert';

import 'package:flutter/material.dart';

class DishDetailList with ChangeNotifier{
  List<DishDetailModel> dishDetails = List<DishDetailModel>.empty();

  void getAllDishDetailsFromAPI(String str) {
    dishDetails = List<DishDetailModel>.from(
        json.decode(str).map((x) => DishDetailModel.fromJson(x)));
    notifyListeners();
  }

  void removeAllDishDetails() {
    if (dishDetails.isNotEmpty) {
      dishDetails.clear();
      notifyListeners();
    }
  }
}

class DishDetailModel {
  int? productId;
  String? productName;
  String? quantity;
  String? unitName;

  DishDetailModel(
      {required this.productId,
        required this.productName,
        required this.quantity,
        required this.unitName,
      });

  DishDetailModel.empty() {
    productId = 0;
    productName = '';
    quantity = '';
    unitName = '';
  }

  factory DishDetailModel.fromJson(Map<String, dynamic> json) => DishDetailModel(
    productId: json["productId"],
    productName: json["productName"],
    quantity: json["quantity"],
    unitName: json["unitName"],
    );

  Map<String, dynamic> toJson() => {
    "productId": productId,
    "productName": productName,
    "quantity": quantity,
    "unitName": unitName,
  };
}