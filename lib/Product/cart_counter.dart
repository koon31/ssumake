import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Constants/color.dart';
import '../Model/Product/product_model.dart';
import '../Model/CartOrder/product_in_cart_model.dart';
import 'detail_product_page_body.dart';

class CartCounter extends StatefulWidget {
  const CartCounter({Key? key, this.onQuantityChange}) : super(key: key);
  final Function(int)? onQuantityChange;

  @override
  _CartCounterState createState() => _CartCounterState();
}

class _CartCounterState extends State<CartCounter> {
  int quantityOfProductsInCart = 0;
  late ProductModel product;
  late final bool isAdd;

  @override
  void initState() {
    super.initState();
      final DetailProductPageBody? detailProductPageBody =
          context.findAncestorWidgetOfExactType<DetailProductPageBody>();
      product = detailProductPageBody!.product;
      isAdd = detailProductPageBody.isAdd;
    quantityOfProductsInCart =
        Provider.of<ProductsInCart>(context, listen: false)
            .getQuantityOfProducts(product)!;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        buildOutlineButton(
          icon: Icons.remove,
          press: () {
            if (isAdd) {
              if (quantityOfProductsInCart > 1) {
                setState(() {
                  quantityOfProductsInCart--;
                  widget.onQuantityChange!(quantityOfProductsInCart);
                });
              }
            } else if(quantityOfProductsInCart > 0) {
              setState(() {
                quantityOfProductsInCart--;
                widget.onQuantityChange!(quantityOfProductsInCart);
              });
            }
          },
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding / 2),
          child: Text(
            // if our item is less then 10 then  it shows 01 02 like that
            (isAdd)
                ? quantityOfProductsInCart == 0
                    ? (quantityOfProductsInCart += 1).toString().padLeft(2, "0")
                    : quantityOfProductsInCart.toString().padLeft(2, "0")
                : quantityOfProductsInCart.toString().padLeft(2, "0"),
            // quantityOfProductsInCart>0?quantityOfProductsInCart.toString().padLeft(2, "0"):quantityOfProductsInCart.toString(),
            style: Theme.of(context).textTheme.headline6,
          ),
        ),
        buildOutlineButton(
            icon: Icons.add,
            press: () {
              setState(() {
                if (product.quantity! > quantityOfProductsInCart){
                  quantityOfProductsInCart++;
                  widget.onQuantityChange!(quantityOfProductsInCart);
                }
              });
            }),
      ],
    );
  }

  SizedBox buildOutlineButton({required IconData icon, Function()? press}) {
    return SizedBox(
      width: 40,
      height: 32,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          primary: kPrimaryColor,
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(13),
          ),
        ),
        onPressed: press,
        child: Icon(icon),
      ),
    );
  }
}
