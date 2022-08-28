import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ssumake/CommonFeatures/custom_discount_tag.dart';
import 'package:ssumake/Model/Product/discount_model.dart';

import '../Constants/color.dart';
import '../Model/Product/product_model.dart';
import '../Model/Product/unit_model.dart';

class ItemCard extends StatelessWidget {
  final ProductModel? product;
  final Function() press;

  const ItemCard({
    Key? key,
    required this.product,
    required this.press,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: press,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.all(kDefaultPadding),
             height: 180,
             width: 180,
            decoration: BoxDecoration(
              color: kPrimaryColor,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Hero(
              tag: "${product!.productId}",
              child: Stack(
                children: [
                  Image.network(product!.productImageURl!),
                  product?.discountId != null
                      ? Consumer<DiscountList>(
                      builder: (context, value, child) {
                        DiscountModel? d =
                        value.findDiscountById(product!.discountId!);
                        return d != null
                            ? d.discountPercent != 0
                            ? Row(
                          mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                          children: [
                            CustomDiscountTag(
                              title: d.discountPercent,
                              isPercent: true,
                            ),
                            (d.discountPercent! > 25)
                                ? const CustomShockPriceTag(
                                title: 'Giá sốc')
                                : const SizedBox.shrink()
                          ],
                        )
                            : Row(
                          mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                          children: [
                            CustomDiscountTag(
                              title: d.discountMoney,
                              isPercent: false,
                            ),
                            (d.discountMoney! >
                                (product?.price! as num) / 4)
                                ? const CustomShockPriceTag(
                                title: 'Giá sốc')
                                : const SizedBox.shrink()
                          ],
                        )
                            : const SizedBox.shrink();
                      })
                      : const SizedBox.shrink(),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
                vertical: kDefaultPadding / 4, horizontal: kDefaultPadding / 2),
            child: Text(
              product!.productName!,
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
              maxLines: 2,
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: kDefaultPadding / 2),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Consumer<DiscountList>(builder: (context, value, child) {
                  DiscountModel? d = product!.discountId != null?
                      value.findDiscountById(product!.discountId!):null;
                  return product?.discountId == null
                      ? Text(
                          "${product!.price?.toStringAsFixed(1)}VND",
                          style: const TextStyle(
                              fontWeight: FontWeight.w800, fontSize: 15),
                        )
                      : d != null
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "${product!.price?.toStringAsFixed(1)}VND",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 15,
                                      decoration: TextDecoration.lineThrough),
                                ),
                                d.discountPercent != 0
                                    ? Text(
                                        "${(product!.price! * (100 - (d.discountPercent as num)) / 100).toStringAsFixed(1)}VND",
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w800,
                                            fontSize: 14),
                                      )
                                    : Text(
                                        "${(product!.price! - (d.discountMoney as num)).toStringAsFixed(1)}VND",
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w800,
                                            fontSize: 15),
                                      )
                              ],
                            )
                          : Text(
                              "${product!.price?.toStringAsFixed(1)}VND",
                              style: const TextStyle(
                                  fontWeight: FontWeight.w800, fontSize: 15),
                            );
                }),
                Consumer<UnitList>(builder: (context, value, child) {
                  return Text(
                    "${value.findUnitById(product!.unitId!).name}",
                    style: const TextStyle(
                        fontWeight: FontWeight.w400, fontSize: 15),
                  );
                }),
              ],
            ),
          )
        ],
      ),
    );
  }
}
