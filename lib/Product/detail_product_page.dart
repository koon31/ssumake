// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ssumake/CommonFeatures/custom_cart_button.dart';
import 'package:ssumake/CommonFeatures/custom_bottom_app_bar.dart';
import 'package:ssumake/Homepage/home_page.dart';
import 'package:ssumake/Product/detail_product_page_body.dart';

import '../CommonFeatures/show_custom_modal_bottom_sheet.dart';
import '../Constants/color.dart';
import '../Model/Product/product_model.dart';
import '../Model/CartOrder/product_in_cart_model.dart';

class DetailProductPage extends StatefulWidget {
  final ProductModel product;
  final int quantityOfProductsInCart;
  final String cate_SubCate_Title;

  const DetailProductPage(
      {Key? key, required this.product, required this.cate_SubCate_Title, required this.quantityOfProductsInCart})
      : super(key: key);

  @override
  State<DetailProductPage> createState() => DetailProductPageState();
}

class DetailProductPageState extends State<DetailProductPage> {

  @override
  void initState() {
    super.initState();
    // getNumberOfProductsInCarts();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _willPop,
      child: Scaffold(
        // each product have a color
        backgroundColor: widget.product.color,
        appBar: buildAppBar(context),
        bottomNavigationBar: buildBottomAppBar(context),
        body: DetailProductPageBody(
          product: widget.product,
          cateSubCateTitle: widget.cate_SubCate_Title, isAdd: true,
          // quantityOfProducts: quantityOfProducts,
          // onNumberOfProductsChanged: (numberOfProduct) {
          //   setState(() {
          //     getNumberOfProductsInCartsOnChanged(numberOfProduct);
          //     print(quantityOfProducts.toString() + 'DetailProductPage');
          //   });
          // },
        ),
      ),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: widget.product.color,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(
          Icons.arrow_back,
          color: Colors.white,
        ),
        onPressed: () => Navigator.pushAndRemoveUntil<void>(
          context,
          MaterialPageRoute<void>(
              builder: (BuildContext context) => const HomePage()),
          ModalRoute.withName('/'),
        ),
      ),
      actions: <Widget>[
        Consumer<ProductsInCart>(
          builder: (context, value, child) {
            return CustomCartButton(
                numberOfProducts: value.getNumberOfProducts(),
                press: () {
                  if (value.getNumberOfProducts() > 0) ShowModalBottomSheet.showCart(context);
                });
          },
        ),
        const SizedBox(width: kDefaultPadding / 2)
      ],
    );
  }

  BottomAppBar buildBottomAppBar(BuildContext context) {
    return BottomAppBar(
      child: Consumer<ProductsInCart>(builder: (context, value, child) =>
        CustomBottomAppBarHomePage(
            message: "Hello",
            buttonLabel1: value.getTotalPrice(),
            buttonLabel2: value.getTotalQuantityOfProducts(),
            press: () async {
              await ShowModalBottomSheet.showCart(context);
              setState((){});
            }),
      ),
    );
  }

  // void getNumberOfProductsInCarts() {
  //   var provider = Provider.of<ProductsInCartTest>(context, listen: false);
  //   quantityOfProducts = provider.getNumberOfProducts();
  // }

  Future<bool> _willPop() async {
    Navigator.pushAndRemoveUntil<void>(
      context,
      MaterialPageRoute<void>(
          builder: (BuildContext context) => const HomePage()),
      ModalRoute.withName('/'),
    );
    return false;
  }
}
