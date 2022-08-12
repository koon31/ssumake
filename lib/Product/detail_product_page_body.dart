import 'package:flutter/material.dart';
import 'package:ssumake/Product/detail_product.dart';

import '../Constants/color.dart';
import '../Model/Product/product_model.dart';
import 'counter_with_add_to_cart_btn.dart';
import 'product_color_and_size.dart';
import 'product_description.dart';

class DetailProductPageBody extends StatefulWidget {
  final ProductModel product;
  final String cateSubCateTitle;
  final bool isAdd;
  const DetailProductPageBody({Key? key, required this.product, required this.cateSubCateTitle, required this.isAdd /*required this.quantityOfProducts, required this.onNumberOfProductsChanged*/}) : super(key: key);

  @override
  State<DetailProductPageBody> createState() => DetailProductPageBodyState();
}

class DetailProductPageBodyState extends State<DetailProductPageBody> {
  @override
  void initState(){
    super.initState();
    // quantityOfProducts =widget.quantityOfProducts!=0||widget.quantityOfProducts!=null?0:widget.quantityOfProducts;
  }
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    print(size.height);
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          SizedBox(
            height: size.height,
            child: Stack(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(top: size.height * 0.34),
                  padding: EdgeInsets.only(
                    top: size.height * 0.1,
                    left: kDefaultPadding,
                    right: kDefaultPadding,
                    bottom: kDefaultPadding*2.5,
                  ),
                  height: size.height-size.height*0.34,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(24),
                      topRight: Radius.circular(24),
                    ),
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        ProductColorAndSize(product: widget.product),
                        const SizedBox(height: kDefaultPadding / 2),
                        ProductDescription(product: widget.product),
                        const SizedBox(height: kDefaultPadding / 2),
                        const CounterWithFavBtn(),
                        const SizedBox(height: kDefaultPadding / 2),
                        //AddToCart(product: widget.product, quantityOfProducts: quantityOfProducts, onNumberOfProductsChanged: widget.onNumberOfProductsChanged,)
                      ],
                    ),
                  ),
                ),
                DetailProduct(product: widget.product, cate_SubCateTitle: widget.cateSubCateTitle,)
              ],
            ),
          )
        ],
      ),
    );
  }
}