// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ssumake/Model/Product/category_model.dart';
import 'package:ssumake/Model/Product/discount_model.dart';

import '../Constants/color.dart';
import '../Model/Product/product_model.dart';
import '../Model/Product/sub_category_model.dart';

class DetailProduct extends StatelessWidget {
  const DetailProduct({
    Key? key,
    required this.product,
  }) : super(key: key);
  final ProductModel product;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: kDefaultPadding,),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
        Consumer2<CategoryList, SubCategoryList>(builder: (context, categories, subCategories, child) {
          SubCategoryModel sc = subCategories.subCategories.firstWhere((element) => element.subCategoryId == product.subCategoryId);
          CategoryModel c = categories.categories.firstWhere((element) => element.categoryId == sc.categoryId);
          return Text(
              '${c.categoryName} / ${sc.subCategoryName}',
              style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
            );
          },),
          Text(
            product.productName!,
            style: Theme.of(context)
                .textTheme
                .headline4
                ?.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
          ),
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
