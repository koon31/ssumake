import 'dart:convert';

import 'package:flutter/material.dart';

class Location extends ChangeNotifier {
  LocationModel? location;

  void getLocationFromAPI(String str) {
    //List<CategoryModel> categoryModelFromJson(String str) =>
    location = LocationModel.fromJson(jsonDecode(str));
    notifyListeners();
  }

  void removeLocations() {
    if (location!=null) {
      location = null;
      notifyListeners();
    }
  }

}

class LocationModel {
  int? cwtId;
  String? cwt;
  int? districtId;
  String? district;
  int? provinceId;
  String? province;

  LocationModel.empty() {
    cwtId = 0;
    cwt = '';
    districtId = 0;
    district = '';
    provinceId = 0;
    province = '';
  }

  LocationModel({required this.cwtId, required this.cwt,required this.districtId, required this.district, required this.provinceId, required this.province});

  factory LocationModel.fromJson(Map<String, dynamic> json) => LocationModel(
    cwtId: json["cwtId"],
    cwt: json["cwt"],
    districtId: json["districtId"],
    district: json["district"],
    provinceId: json["provinceId"],
    province: json["province"],
  );

  Map<String, dynamic> toJson() => {
    "cwtId": cwtId,
    "cwt": cwt,
    "districtId": districtId,
    "district": district,
    "provinceId": provinceId,
    "province": province,
  };
}
