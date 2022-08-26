import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ssumake/Model/CartOrder/product_in_cart_model.dart';
import '../Constants/color.dart';
import '../Model/Product/discount_model.dart';
import '../Model/Product/product_model.dart';
import 'detail_product_page_body.dart';

class AddToCart extends StatefulWidget {
  const AddToCart({
    Key? key,
    required this.quantityOfProducts,
  }) : super(key: key);
  final int quantityOfProducts;

  @override
  State<AddToCart> createState() => _AddToCartState();
}

class _AddToCartState extends State<AddToCart> {
  late ProductModel product;
  late final bool isAdd;

  @override
  void initState() {
    final DetailProductPageBody? detailProductPageBody =
        context.findAncestorWidgetOfExactType<DetailProductPageBody>();
    product = detailProductPageBody!.product;
    isAdd = detailProductPageBody.isAdd;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<ProductsInCart>(context);
    print(widget.quantityOfProducts);
    return SizedBox(
      height: 45,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            primary: kPrimaryColor),
        onPressed: () {
          if (widget.quantityOfProducts > 0) {
            if (!provider.isContainInCart(product)) {
              provider.addToCart(product, widget.quantityOfProducts);
              print('add');
            } else {
              provider.updateToCart(product, widget.quantityOfProducts);
              print(widget.quantityOfProducts);
              print('update');
            }
          } else {
            print('delete');
            print(product.productName! +
                ' ' +
                widget.quantityOfProducts.toString());
            if (provider.isContainInCart(product)) {
              provider.deleteToCart(product);
            } else {
              provider.addToCart(product, widget.quantityOfProducts + 1);
              print('add');
            }
          }
          if (!isAdd) {
            if (provider.getTotalQuantityOfProducts() == 0) {
              int count = 0;
              Navigator.of(context).popUntil((_) => count++ >= 2);
            } else {
              Navigator.pop(context);
            }
          } else {
            Navigator.pop(context);
          }
        },
        child: Consumer<DiscountList>(builder: (context, value, child) {
          DiscountModel? d = product.discountId != null
              ? value.findDiscountById(product.discountId!)
              : null;
          double priceAfterDiscount = product.discountId != null
              ? d != null
                  ? d.discountPercent == 0
                      ? (product.price! - (d.discountMoney as num))
                      : (product.price! *
                          (100 - (d.discountPercent as num)) /
                          100)
                  : product.price!
              : product.price!;
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding/2),
            child: Text(
              isAdd
                  ? widget.quantityOfProducts > 0
                      ? (widget.quantityOfProducts * priceAfterDiscount)
                          .toStringAsFixed(1) + ' VND'
                      : ((widget.quantityOfProducts + 1) * priceAfterDiscount)
                          .toStringAsFixed(1) + ' VND'
                  : widget.quantityOfProducts > 0
                      ? (widget.quantityOfProducts * priceAfterDiscount)
                          .toStringAsFixed(1) + ' VND'
                      : "Bỏ chọn sản phẩm này".toUpperCase(),
              style: const TextStyle(
                fontSize: 17.5,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          );
        }),
      ),
    );
  }

// showSnackBar({var provider}) {
// if(totalQuantityOfProducts>0) {
// isSnackBarShown = true;
// ScaffoldMessenger.of(context)
//   ..removeCurrentSnackBar()
//   ..showSnackBar();
// } else {
//   if(isSnackBarShown) {
//     ScaffoldMessenger.of(context).removeCurrentSnackBar();
//     isSnackBarShown = false;
//   }
// }
// }
}
