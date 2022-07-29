import 'dart:convert';

import 'package:flutter/material.dart';

class ProvinceList with ChangeNotifier{
  List<ProvinceModel> provinces = List<ProvinceModel>.empty();

  void getAllProvincesFromAPI(String str) {
    provinces = List<ProvinceModel>.from(
        json.decode(str).map((x) => ProvinceModel.fromJson(x)));
    notifyListeners();
  }

  void removeAllProvinces() {
    if (provinces.isNotEmpty) {
      provinces.clear();
      notifyListeners();
    }
  }

}

class ProvinceModel {
  int? provinceId;
  String? name;
  String? slug;
  String? type;

  ProvinceModel.empty() {
    provinceId = 0;
    name = '';
    slug = '';
    type = '';
  }

  ProvinceModel(
      {required this.provinceId,
      required this.name,
      required this.slug,
      required this.type});

  factory ProvinceModel.fromJson(Map<String, dynamic> json) => ProvinceModel(
    provinceId: json["provinceId"],
    name: json["name"],
    slug: json["slug"],
    type: json["type"],
  );

  Map<String, dynamic> toJson() => {
    "provinceId": provinceId,
    "name": name,
    "slug": slug,
    "type": type,
  };
}
