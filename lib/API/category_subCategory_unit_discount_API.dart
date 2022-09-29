import 'dart:async';
import 'package:http/http.dart' as http;
import '../Constants/uri.dart';

class CategoryAPI {
  CategoryAPI._();
  static Future<String> getCategories() async {
    try {
      final response = await http.get(
        Uri.parse((URI.EDITABLE_BASE_URI.isEmpty?URI.BASE_URI:URI.EDITABLE_BASE_URI) + URI.GET_CATEGORY),
      );
      return response.body;
    } catch (e) {
      throw Exception('Lấy loại hàng lớn thất bại');
    }
  }
}

class SubCategoryAPI{
  SubCategoryAPI._();
  static Future<String> getSubCategoriesByCategoryId(int categoryId) async {
    try {
      final response = await http.get(
        Uri.parse((URI.EDITABLE_BASE_URI.isEmpty?URI.BASE_URI:URI.EDITABLE_BASE_URI) + URI.GET_SUB_CATEGORY+'?id='+categoryId.toString()),
      );
      return response.body;
    } catch (e) {
      throw Exception('Lấy loại hàng nhỏ thất bại');
    }
  }
}

class UnitAPI {
  UnitAPI._();
  static Future<String> getUnits() async {
    try {
      final response = await http.get(
        Uri.parse((URI.EDITABLE_BASE_URI.isEmpty?URI.BASE_URI:URI.EDITABLE_BASE_URI) + URI.GET_UNIT),
      );
      return response.body;
    } catch (e) {
      throw Exception('Lấy đơn vị hàng thất bại');
    }
  }
}

class DiscountAPI {
  DiscountAPI._();
  static Future<String> getDiscounts() async {
    try {
      final response = await http.get(
        Uri.parse((URI.EDITABLE_BASE_URI.isEmpty?URI.BASE_URI:URI.EDITABLE_BASE_URI) + URI.GET_DISCOUNT),
      );
      return response.body;
    } catch (e) {
      throw Exception('Lấy giảm giá hàng thất bại');
    }
  }
}