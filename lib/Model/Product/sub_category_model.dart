import 'dart:convert';
import 'package:flutter/material.dart';

class SubCategoryList extends ChangeNotifier {
  List<SubCategoryModel> subCategories = List.empty();

  void getAllSubCategoriesFromAPI(String str) {
    //List<CategoryModel> categoryModelFromJson(String str) =>
    if (subCategories.isEmpty) {
      subCategories = List<SubCategoryModel>.from(
          json.decode(str).map((x) => SubCategoryModel.fromJson(x)));
    } else {
      List<SubCategoryModel> scates = List<SubCategoryModel>.from(
          json.decode(str).map((x) => SubCategoryModel.fromJson(x)));
      subCategories.addAll(scates);
    }
    notifyListeners();
  }

  void removeAllSubCategories() {
    if (subCategories.isNotEmpty) {
      subCategories.clear();
      notifyListeners();
    }
  }
}

class SubCategoryModel {
  int? subCategoryId;
  int? categoryId;
  String? subCategoryName;


  @override
  bool operator ==(Object other) {
    return other is SubCategoryModel
        &&
      other.subCategoryId == subCategoryId &&
    other.categoryId == categoryId &&
    other.subCategoryName == subCategoryName;
  }
  @override
  int get hashCode {
  return Object.hash(subCategoryId, categoryId,subCategoryName);
  }


  SubCategoryModel.empty() {
    subCategoryId = 0;
    categoryId = 0;
    subCategoryName = '';
  }

  SubCategoryModel(
      {required this.subCategoryId,
      required this.categoryId,
      required this.subCategoryName});

  factory SubCategoryModel.fromJson(Map<String, dynamic> json) =>
      SubCategoryModel(
        subCategoryId: json["subCategoryId"],
        categoryId: json["categoryId"],
        subCategoryName: json["subCategoryName"],
      );

  Map<String, dynamic> toJson() => {
        "subCategoryId": subCategoryId,
        "categoryId": categoryId,
        "subCategoryName": subCategoryName,
      };


}
