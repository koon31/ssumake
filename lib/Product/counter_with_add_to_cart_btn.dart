import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ssumake/Constants/color.dart';
import 'package:ssumake/Product/add_to_cart.dart';
import 'package:ssumake/Product/detail_product_page_body.dart';

import '../Model/Product/product_model.dart';
import '../Model/CartOrder/product_in_cart_model.dart';
import 'cart_counter.dart';
import 'detail_product_page.dart';

class CounterWithFavBtn extends StatefulWidget {
  const CounterWithFavBtn({Key? key}) : super(key: key);

  @override
  State<CounterWithFavBtn> createState() => _CounterWithFavBtnState();
}

class _CounterWithFavBtnState extends State<CounterWithFavBtn> {
  late ProductModel product;
  late int quantityOfProducts;
  late final bool isAdd;

  @override
  void initState() {
    // TODO: implement initState
    final DetailProductPage? detailProductPage =
        context.findAncestorWidgetOfExactType<DetailProductPage>();
    if (detailProductPage == null) {
      final DetailProductPageBody? detailProductPageBody =
          context.findAncestorWidgetOfExactType<DetailProductPageBody>();
      product = detailProductPageBody!.product;
      isAdd = detailProductPageBody.isAdd;
    } else {
      product = detailProductPage.product;
      isAdd = true;
    }
    quantityOfProducts = Provider.of<ProductsInCart>(context, listen: false)
        .getQuantityOfProducts(
            product)!; //widget.quantityOfProducts!=0||widget.quantityOfProducts!=null?0:widget.quantityOfProducts;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        CartCounter(onQuantityChange: (int quantity) {
          setState(() {
            quantityOfProducts = quantity;
          });
          print(quantity.toString() + quantityOfProducts.toString());
        }),
        Expanded(
          child: Padding(
              padding: const EdgeInsets.only(left: kDefaultPadding / 2),
              child: AddToCart(quantityOfProducts: quantityOfProducts)),
        )
        // Container(
        //   padding: const EdgeInsets.all(8),
        //   height: 32,
        //   width: 32,
        //   decoration: const BoxDecoration(
        //     color: Color(0xFFFF6464),
        //     shape: BoxShape.circle,
        //   ),
        //   child: SvgPicture.asset("assets/icons/heart.svg"),
        // )
      ],
    );
  }
}
