import 'package:intl/intl.dart';
import 'package:ssumake/Model/CartOrder/order_detail_model.dart';

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
    DateTime dc = DateFormat('dd/MM/yyyy').parse(json['dateCreate'].toString().substring(8, 10)+'/'+json['dateCreate'].toString().substring(5, 7)+'/'+json['dateCreate'].toString().substring(0, 4));
    return OrderModel(
    custormerId: json["custormerId"],
    dateCreate: dc,
    address: json["address"],
    paymentMethodId: json["paymentMethodId"],
    totalPrice: json["totalPrice"],
    discountId: json["discountId"],
    status: json["status"],
    orderDetails: json["status"],
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