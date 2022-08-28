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
  String? ingredient;
  String? quantity;
  String? unitName;

  DishDetailModel(
      {required this.productId,
        required this.ingredient,
        required this.quantity,
        required this.unitName,
      });

  DishDetailModel.empty() {
    productId = 0;
    ingredient = '';
    quantity = '';
    unitName = '';
  }

  factory DishDetailModel.fromJson(Map<String, dynamic> json) => DishDetailModel(
    productId: json["productId"],
    ingredient: json["ingredient"],
    quantity: json["quantity"],
    unitName: json["unitName"],
    );

  Map<String, dynamic> toJson() => {
    "productId": productId,
    "ingredient": ingredient,
    "quantity": quantity,
    "unitName": unitName,
  };
}