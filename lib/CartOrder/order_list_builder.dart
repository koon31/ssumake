import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../API/product_API.dart';
import '../CommonFeatures/custom_title_style.dart';
import '../CommonFeatures/show_custom_modal_bottom_sheet.dart';
import '../Constants/color.dart';
import '../Constants/global_var.dart';
import '../Model/CartOrder/order_detail_model.dart';
import '../Model/CartOrder/order_model.dart';
import '../Model/Product/product_model.dart';

class OrderListBuilder extends StatefulWidget {
  const OrderListBuilder({Key? key, required this.index}) : super(key: key);
  final int index;

  @override
  State<OrderListBuilder> createState() => _OrderListBuilderState();
}

class _OrderListBuilderState extends State<OrderListBuilder> {
  late final Future _futureData;
  String? name = '';

  @override
  void initState() {
    super.initState();
    _futureData = _getProductNameList();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<OrderHistory>(builder: (context, orderHistory, child) {
      return FutureBuilder(
        future: _futureData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return InkWell(
              onTap: () {
                ShowModalBottomSheet.showOrder(context, orderHistory.orderHistory.reversed.toList()[widget.index]);
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
                child: ListTile(
                  minVerticalPadding: 0,
                  contentPadding: EdgeInsets.zero,
                  visualDensity: const VisualDensity(vertical: -4),
                  leading: const Icon(
                    Icons.delivery_dining,
                    color: Colors.black,
                  ),
                  title: Text(name??'',
                      style: CustomTextStyle.custom1(context), maxLines: 3, overflow: TextOverflow.ellipsis),
                  subtitle: Text(DateFormat("hh:mm - dd/MM/yyyy")
                      .format(orderHistory.orderHistory.reversed.toList()[widget.index].dateCreate!)),
                  trailing: Text(formatter.format(orderHistory.orderHistory.reversed.toList()[widget.index].totalPrice!) + ' VND',
                    style: CustomTextStyle.custom1(context),),
                ),
              ),
            );
          } else {
            return Container();
          }
        },
      );
    },);
  }

  _getProductNameList() async {
    var orderHistory = Provider.of<OrderHistory>(context, listen: false).orderHistory;
    var products = Provider.of<ProductList>(context, listen: false).products;
    String nameProductList = '';
    List<OrderDetailModel> orderDetails = orderHistory.reversed.toList()[widget.index].orderDetails!.toList();
    for (OrderDetailModel od in orderDetails) {
      ProductModel? product = products.firstWhereOrNull((element) => element.productId == od.productId);
      if (product == null && od.productId != null) {
        final String? stringOfProduct = await ProductAPI.getProductByProductId(od.productId!);
        if (stringOfProduct != null && stringOfProduct.isNotEmpty) {
          Map<String, dynamic> map = json.decode(stringOfProduct);
          product = ProductModel.fromJson(map);
        }
      }
      if (nameProductList.isEmpty) {
        if (product?.productName != null && product!.productName!.isNotEmpty) {
          nameProductList += product.productName!;
        }
      } else {
        if (product?.productName != null && product!.productName!.isNotEmpty) {
          nameProductList += ', ' + product.productName!;
        }
      }
    }
    name = nameProductList;
  }
}
