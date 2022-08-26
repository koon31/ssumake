// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ssumake/Model/Product/discount_model.dart';

import '../Constants/color.dart';
import '../Model/Product/product_model.dart';

class DetailProduct extends StatelessWidget {
  const DetailProduct({
    Key? key,
    required this.product,
    required this.cate_SubCateTitle,
  }) : super(key: key);
  final String cate_SubCateTitle;
  final ProductModel product;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
          left: kDefaultPadding, right: kDefaultPadding, top: kDefaultPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            cate_SubCateTitle.isNotEmpty ? cate_SubCateTitle : "NoTitle",
            style: const TextStyle(color: Colors.white),
          ),
          Text(
            product.productName!,
            style: Theme.of(context)
                .textTheme
                .headline4
                ?.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: kDefaultPadding),
          Row(
            children: <Widget>[
              Consumer<DiscountList>(builder: (context, value, child) {
                DiscountModel? d =product.discountId != null ? value.findDiscountById(product.discountId!):null;
                return RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                          text: "Giá\n",
                          style: Theme.of(context)
                              .textTheme
                              .headline6
                              ?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold)),
                      product.discountId == null || d == null
                          ? TextSpan(
                              text: product.price!.toStringAsFixed(1) + "VND",
                              style: Theme.of(context)
                                  .textTheme
                                  .headline4
                                  ?.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                            )
                          : TextSpan(
                              text: product.price!.toStringAsFixed(1) + "VND\n",
                              style: Theme.of(context)
                                  .textTheme
                                  .headline4
                                  ?.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
                                      decoration: TextDecoration.lineThrough),
                            ),
                      d != null
                          ? d.discountPercent == 0
                              ? TextSpan(
                                  text: (product.price! -
                                              (d.discountMoney as num))
                                          .toStringAsFixed(1) +
                                      "VND",
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline4
                                      ?.copyWith(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                )
                              : TextSpan(
                                  text: (product.price! *
                                              (100 -
                                                  (d.discountPercent as num)) /
                                              100)
                                      .toStringAsFixed(1) +
                                      "VND",
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline4
                                      ?.copyWith(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                )
                          : const TextSpan(
                              text: '',
                            ),
                    ],
                  ),
                );
              }),
              const SizedBox(width: kDefaultPadding),
              Expanded(
                child: Hero(
                  tag: "${product.productId}",
                  child: SizedBox(
                    height: 200,
                    width: 200,
                    child: Image.network(
                      product.productImageURl!,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
