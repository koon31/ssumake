import 'dart:convert';

import 'package:flutter/material.dart';

class CategoryList extends ChangeNotifier {
  List<CategoryModel> categories = List.empty();

  void getAllCategoriesFromAPI(String str) {
    categories = List<CategoryModel>.from(
        json.decode(str).map((x) => CategoryModel.fromJson(x)));
    notifyListeners();
  }

  void removeAllCategories() {
    if (categories.isNotEmpty) {
      categories.clear();
      notifyListeners();
    }
  }
}

class CategoryModel {
  int? categoryId;
  String? categoryName;

  CategoryModel.empty() {
    categoryId = 0;
    categoryName = '';
  }

  CategoryModel({required this.categoryId, required this.categoryName});

  factory CategoryModel.fromJson(Map<String, dynamic> json) => CategoryModel(
        categoryId: json["categoryId"],
        categoryName: json["categoryName"],
      );

  Map<String, dynamic> toJson() => {
        "categoryId": categoryId,
        "categoryName": categoryName,
      };
}
