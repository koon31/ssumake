import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../API/product_API.dart';
import '../CommonFeatures/custom_title_style.dart';
import '../Constants/color.dart';
import '../Constants/global_var.dart';
import '../Model/CartOrder/order_detail_model.dart';
import '../Model/CartOrder/order_model.dart';
import '../Model/Product/product_model.dart';
import '../Model/Product/unit_model.dart';

class ProductsInOrderBuilder extends StatefulWidget {
  final OrderModel? selectedOrder;

  const ProductsInOrderBuilder({Key? key, this.selectedOrder}) : super(key: key);

  @override
  State<ProductsInOrderBuilder> createState() => _ProductsInOrderBuilderState();
}

class _ProductsInOrderBuilderState extends State<ProductsInOrderBuilder> {
  late final Future _futureData;
  List<ProductModel>? products;
  OrderModel? order;

  @override
  void initState() {
    super.initState();
    _futureData = loadData();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _futureData,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: kDefaultPadding / 4),
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: order!=null?order?.orderDetails!=null?order?.orderDetails?.length:0:0,
            itemBuilder: (context, index) => productBuilder(index),
          );
        } else {
          return Container();
        }
      },
    );
  }

  productBuilder(int index) {
    return FutureBuilder(
      future: _futureData,
      builder: (context, snapshot) {
        print(order?.dateCreate);
        if (snapshot.connectionState == ConnectionState.done) {
          return Consumer2<OrderHistory, UnitList>(builder: (context, orderHistory, units, child) {
            ProductModel? product =
                products?.firstWhereOrNull((element) => element.productId == order?.orderDetails![index].productId);
            UnitModel? unit = units.units.firstWhereOrNull((element) => element.unitId == product!.unitId);
            return ListTile(
              minVerticalPadding: 0,
              contentPadding: EdgeInsets.zero,
              visualDensity: const VisualDensity(vertical: -4),
              leading: Text("${order?.orderDetails![index].quantity}", style: CustomTextStyle.custom1(context)),
              title: Text("${product!.productName}"),
              subtitle: Text("${unit!.name}"),
              trailing: Text("${formatter.format(order?.orderDetails![index].price!)}VND"),
            );
          });
        } else {
          return Container();
        }
      },
    );
  }

  loadData() async {
    await _getSelectedOrder();
    print(order!.dateCreate);
  }

  _getSelectedOrder() async {
    var orderProvider = Provider.of<OrderHistory>(context, listen: false).orderHistory;
    if (widget.selectedOrder != null) {
      order = widget.selectedOrder!;
    } else {
      order = orderProvider.reduce((last, element) => element.dateCreate!.isAfter(last.dateCreate!) ? element : last);
    }
    await _getProductListInOrder(order!.orderDetails!);
  }

  _getProductListInOrder(List<OrderDetailModel> odds) async {
    var productsProvider = Provider.of<ProductList>(context, listen: false).products;
    List<ProductModel> ps = List<ProductModel>.generate(odds.length, (index) => ProductModel.empty());
    for (OrderDetailModel od in odds) {
      ProductModel? product = productsProvider.firstWhereOrNull((element) => element.productId == od.productId);
      if (product == null && od.productId != null) {
        final String? stringOfProduct = await ProductAPI.getProductByProductId(od.productId!);
        if (stringOfProduct != null && stringOfProduct.isNotEmpty) {
          Map<String, dynamic> map = json.decode(stringOfProduct);
          product = ProductModel.fromJson(map);
        }
      }
      if (product != null) ps[odds.indexOf(od)] = product;
    }
    products = ps;
  }
}
