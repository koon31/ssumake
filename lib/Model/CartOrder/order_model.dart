import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:ssumake/Model/CartOrder/order_detail_model.dart';

class OrderHistory with ChangeNotifier{
  List<OrderModel> orderHistory = List<OrderModel>.empty();

  void getAllOrderHistoryFromAPI(String str) {
    orderHistory = List<OrderModel>.from(
        json.decode(str).map((x) => OrderModel.fromJson(x)));
    notifyListeners();
  }

  void removeAllOrderHistory() {
    if (orderHistory.isNotEmpty) {
      orderHistory.clear();
      notifyListeners();
    }
  }

}

class OrderModel {
  String? custormerId;
  DateTime? dateCreate;
  String? address;
  int? paymentMethodId;
  double? totalPrice;
  int? discountId;
  int? status;
  List<OrderDetailModel>? orderDetails;

  OrderModel.empty() {
    custormerId = '';
    dateCreate = DateTime.now();
    address = '';
    paymentMethodId = 0;
    totalPrice = 0;
    discountId = 0;
    status = 0;
    orderDetails = List<OrderDetailModel>.empty();
  }

  OrderModel(
      {required this.custormerId,
        required this.dateCreate,
        required this.address,
        required this.paymentMethodId, required this.totalPrice, this.discountId, required this.status,this.orderDetails });


  factory OrderModel.fromJson(Map<String, dynamic> json) {
    DateTime dc = DateTime.parse(json['dateCreate'].toString());
    List<OrderDetailModel>? orderDetailHistory = List<OrderDetailModel>.from(json['orderdetails'].map((x) => OrderDetailModel.fromJson(x)));
    for(int i = 0; i < orderDetailHistory.length; ++i) {
    }
    return OrderModel(
    custormerId: json["custormerId"]??'',
    dateCreate: dc,
    address: json["address"]??'',
    paymentMethodId: json["paymentMethodId"]??1,
    totalPrice: json["totalPrice"].toDouble()??0,
    discountId: json["discountId"]??null,
    status: json["status"]??0,
    orderDetails: orderDetailHistory,
  );}

  Map<String, dynamic> toJson() => {
    "custormerId": custormerId,
    "dateCreate": dateCreate,
    "address": address,
    "paymentMethodId": paymentMethodId,
    "totalPrice": totalPrice,
    "discountId": discountId,
    "status": status,
    "orderDetails": orderDetails,
  };
}