import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DiscountList extends ChangeNotifier {
  List<DiscountModel> discounts = List.empty();

  void getAllDiscountsFromAPI(String str) {
    discounts = List<DiscountModel>.from(
        json.decode(str).map((x) => DiscountModel.fromJson(x))).where((element) => element.dateEnd!.compareTo(DateTime.now())>-1).toList();
    notifyListeners();
  }

  void removeAllDiscounts() {
    if (discounts.isNotEmpty) {
      discounts.clear();
      notifyListeners();
    }
  }

  DiscountModel? findDiscountById(int id) {
    return discounts.firstWhereOrNull((element) => element.discountId == id);
  }
}

class DiscountModel {
  int? discountId;
  String? discountName;
  DateTime? dateCreate;
  DateTime? dateEnd;
  double? discountPercent;
  double? discountMoney;

  DiscountModel.empty() {
    discountId = 0;
    discountName = '';
    dateCreate = DateTime.now();
    dateEnd = DateTime.now();
    discountPercent = 0;
    discountMoney = 0;
  }

  DiscountModel(
      {required this.discountId,
      this.discountName,
      required this.dateCreate,
      required this.dateEnd,
      this.discountPercent,
      this.discountMoney});

  factory DiscountModel.fromJson(Map<String, dynamic> json) {
    DateTime dC = DateFormat('dd/MM/yyyy').parse(
        json["dateCreate"].toString().substring(8, 10) +
            '/' +
            json["dateCreate"].toString().substring(5, 7) +
            '/' +
            json["dateCreate"].toString().substring(0, 4));
    DateTime dE = DateFormat('dd/MM/yyyy').parse(
        json["dateEnd"].toString().substring(8, 10) +
            '/' +
            json["dateEnd"].toString().substring(5, 7) +
            '/' +
            json["dateEnd"].toString().substring(0, 4));
    return DiscountModel(
      discountId: json["discountId"],
      discountName: json["discountName"],
      dateCreate: json["dateCreate"] != '' ? dC : DateTime.now(),
      dateEnd: json["dateEnd"] != '' ? dE : DateTime.now(),
      discountPercent:json["discountPercent"]==null?0.toDouble(): json["discountPercent"].toDouble(),
      discountMoney: json["discountMoney"]==null?0.toDouble():json["discountMoney"].toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {
        "discountId": discountId,
        "discountName": discountName,
        "dateCreate": dateCreate,
        "dateEnd": dateEnd,
        "discountPercent": discountPercent,
        "discountMoney": discountMoney,
      };
}
