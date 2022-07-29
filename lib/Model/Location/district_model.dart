import 'dart:convert';

import 'package:flutter/material.dart';

class DistrictList with ChangeNotifier{
  List<DistrictModel> districts = List<DistrictModel>.empty();

  void getAllProvincesByProvinceIdFromAPI(String str) {
    districts = List<DistrictModel>.from(
        json.decode(str).map((x) => DistrictModel.fromJson(x)));
    notifyListeners();
  }

  void removeAllDistricts() {
    if (districts.isNotEmpty) {
      districts.clear();
      notifyListeners();
    }
  }
}

class DistrictModel {
  int? districtId;
  int? provinceId;
  String? name;
  String? type;

  DistrictModel.empty() {
    districtId = 0;
    provinceId = 0;
    name = '';
    type = '';
  }

  DistrictModel(
      {required this.districtId,
      required this.provinceId,
      required this.name,
      required this.type});


  factory DistrictModel.fromJson(Map<String, dynamic> json) => DistrictModel(
    districtId: json["districtId"],
    provinceId: json["provinceId"],
    name: json["name"],
    type: json["type"],
  );

  Map<String, dynamic> toJson() => {
    "districtId": districtId,
    "provinceId": provinceId,
    "name": name,
    "type": type,
  };
}
