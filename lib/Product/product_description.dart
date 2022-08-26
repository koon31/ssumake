import 'package:flutter/material.dart';

import '../Constants/color.dart';
import '../Model/Product/product_model.dart';

class ProductDescription extends StatelessWidget {
  const ProductDescription({
    Key? key,
    required this.product,
  }) : super(key: key);

  final ProductModel product;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top:kDefaultPadding),
      child: product.productDescribe == null
          ? const SizedBox.shrink()
          : Text(
              product.productDescribe!,
              style: const TextStyle(height: 1.5),
            ),
    );
  }
}
