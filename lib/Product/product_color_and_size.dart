import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Constants/color.dart';
import '../Model/Product/product_model.dart';
import '../Model/Product/unit_model.dart';

class ProductColorAndSize extends StatelessWidget {
  const ProductColorAndSize({
    Key? key,
    required this.product,
  }) : super(key: key);

  final ProductModel product;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: RichText(
            text: TextSpan(
              style: const TextStyle(color: kTextColor),
              children: [
                const TextSpan(text: "Số lượng\n"),
                TextSpan(
                  text: "${product.quantity}",
                  style: Theme.of(context)
                      .textTheme
                      .headline5
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          )
        ),
        Expanded(
          child: Consumer<UnitList>(builder: (context, value, child){
            return RichText(
              text: TextSpan(
                style: const TextStyle(color: kTextColor),
                children: [
                  const TextSpan(text: "Đơn vị\n"),
                  TextSpan(
                    text: "${value.findUnitById(product.unitId!).name}",
                    style: Theme.of(context)
                        .textTheme
                        .headline5
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            );
          }),
        ),
      ],
    );
  }
}
