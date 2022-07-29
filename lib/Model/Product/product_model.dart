import 'dart:convert';

import 'package:flutter/material.dart';

class ProductList extends ChangeNotifier {
  List<ProductModel> products = List.empty();

  void getAllProductsFromAPI(String str) {
    products = List<ProductModel>.from(
        json.decode(str).map((x) => ProductModel.fromJson(x)));
    notifyListeners();
  }

  void removeAllProducts() {
    if (products.isNotEmpty) {
      products.clear();
      notifyListeners();
    }
  }
}

class ProductModel {
  int? productId;
  String? productName;
  String? productCode;
  String? productDescribe;
  String? productImageURl;
  double? price;
  int? quantity;
  int? discountId;
  int? subCategoryId;
  int? unitId;
  int? brandId;
  Color? color;

  ProductModel(
      {required this.productId,
      required this.productName,
      required this.productCode,
      required this.productDescribe,
      required this.productImageURl,
      required this.price,
      required this.quantity,
      this.discountId,
      required this.subCategoryId,
      required this.unitId,
      this.brandId});

  ProductModel.empty() {
    productId = 0;
    productName = '';
    productCode = '';
    productDescribe = '';
    productImageURl = '';
    price = 0;
    quantity = 0;
    subCategoryId = 0;
  }

  factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(
      productId: json["productId"],
      productName: json["productName"],
      productCode: json["productCode"],
      productDescribe: json["productDescribe"],
      productImageURl: json["productImageURl"],
      price: json["price"].toDouble(),
      quantity: json["quantity"],
      discountId: json["discountId"],
      subCategoryId: json["subCategoryId"],
      unitId: json["unitId"],
      brandId: json["brandId"]);

  Map<String, dynamic> toJson() => {
        "productId": productId,
        "productName": productName,
        "productCode": productCode,
        "productDescribe": productDescribe,
        "productImageURl": productImageURl,
        "price": price,
        "quantity": quantity,
        "discountId": discountId,
        "subCategoryId": subCategoryId,
        "unitId": unitId,
        "brandId": brandId
      };
}
