import 'dart:convert';

import 'package:flutter/material.dart';

class UnitList extends ChangeNotifier {
  List<UnitModel> units = List.empty();

  void getAllUnitsFromAPI(String str) {
    //List<CategoryModel> categoryModelFromJson(String str) =>
    units = List<UnitModel>.from(
        json.decode(str).map((x) => UnitModel.fromJson(x)));
    notifyListeners();
  }

  void removeAllUnits() {
    if (units.isNotEmpty) {
      units.clear();
      notifyListeners();
    }
  }

  UnitModel findUnitById(int id) {
    return units.firstWhere((element) => element.unitId == id);
  }
}

class UnitModel {
  int? unitId;
  String? name;

  UnitModel.empty() {
    unitId = 0;
    name = '';
  }

  UnitModel({required this.unitId, required this.name});

  factory UnitModel.fromJson(Map<String, dynamic> json) => UnitModel(
        unitId: json["unitId"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "unitId": unitId,
        "name": name,
      };
}
