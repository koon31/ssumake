import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:ssumake/Model/Dish/dish_detail_model.dart';

class DishList extends ChangeNotifier {
  List<DishModel> dishes = List.empty();

  void getAllDishesFromAPI(String str) {
    dishes = List<DishModel>.from(
        json.decode(str).map((x) => DishModel.fromJson(x)));
    notifyListeners();
  }

  void removeAllDishes() {
    if (dishes.isNotEmpty) {
      dishes.clear();
      notifyListeners();
    }
  }
}

class DishModel {
  int? dishId;
  String? dishName;
  String? dishDescription;
  String? dishCooking;
  List<DishDetailModel>? dishDetails;

  DishModel(
      {required this.dishId,
        required this.dishName,
        required this.dishDescription,
        required this.dishCooking, this.dishDetails});

  DishModel.empty() {
    dishId = 0;
    dishName = '';
    dishDescription = '';
    dishCooking = '';
    dishDetails = List<DishDetailModel>.empty();
  }

  factory DishModel.fromJson(Map<String, dynamic> json) {
    List<DishDetailModel>? dDetails = List<DishDetailModel>.from(json['dishDetails'].map((x) => DishDetailModel.fromJson(x)));
    for(int i = 0; i < dDetails.length; ++i) {
      print(dDetails[i].ingredient);
    }
  return DishModel(
  dishId: json["dishId"],
  dishName: json["dishName"],
  dishDescription: json["dishDescription"],
  dishCooking: json["dishCooking"], dishDetails: dDetails);
}

  Map<String, dynamic> toJson() => {
    "dishId": dishId,
    "dishName": dishName,
    "dishDescription": dishDescription,
    "dishCooking": dishCooking,
    "dishDetails": dishDetails,
  };
}
