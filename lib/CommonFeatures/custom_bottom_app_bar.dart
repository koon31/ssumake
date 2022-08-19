import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ssumake/Model/Product/discount_model.dart';
import '../Constants/color.dart';
import '../Model/Product/product_model.dart';
import '../Model/CartOrder/product_in_cart_model.dart';

class CustomBottomAppBarHomePage extends StatefulWidget {
  const CustomBottomAppBarHomePage(
      {Key? key,
      required this.message,
      required this.buttonLabel1,
      required this.buttonLabel2,
      required this.press})
      : super(key: key);
  final String message;
  final double buttonLabel1;
  final int buttonLabel2;
  final Function() press;

  @override
  State<CustomBottomAppBarHomePage> createState() =>
      _CustomBottomAppBarHomePageState();
}

class _CustomBottomAppBarHomePageState
    extends State<CustomBottomAppBarHomePage> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
        padding: const EdgeInsets.symmetric(
            vertical: kDefaultPadding / 4, horizontal: kDefaultPadding),
        color: Colors.transparent,
        height: widget.buttonLabel2 > 0 ? size.height / 15 : 0,
        child: messageContent(size));
  }

  Widget messageContent(Size size) {
    return GestureDetector(
      onTap: () {},
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: kDefaultPadding / 3),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: const [
                    Text(
                      'Giao Đến',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                          fontWeight: FontWeight.w500),
                    ),
                    Icon(
                      Icons.keyboard_arrow_down,
                      color: Colors.black,
                      size: 20,
                    ),
                  ],
                ),
                const Flexible(
                  flex: 3,
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child:  Text(
                      'Các sản phẩm sẽ được giao đến địa chỉ',
                      style: TextStyle(color: kTextColor, fontSize: 13),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Flexible(flex: 1, child: FittedBox(fit:BoxFit.scaleDown, child: customButtonOfSnackBar(size))),
        ],
      ),
    );
  }

  Widget customButtonOfSnackBar(Size size) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: kDefaultPadding / 5),
      width: size.width / 3.25,
      height: size.height / 20,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(29),
        child: customElevatedButton(),
      ),
    );
  }

  Widget customElevatedButton() {
    return ElevatedButton(
      onPressed: widget.press,
      style: ElevatedButton.styleFrom(
        primary: kPrimaryColor,
        padding: EdgeInsets.zero,
        visualDensity: const VisualDensity(vertical: -4),
        textStyle: const TextStyle(
          color: kPrimaryColor,
          fontSize: 17,
          fontWeight: FontWeight.w500,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Container(
            decoration: const BoxDecoration(
                shape: BoxShape.circle, color: Colors.white),
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Padding(
                padding: const EdgeInsets.all(2),
                child: Text(
                  widget.buttonLabel2.toString(),
                  style: const TextStyle(color: kPrimaryColor),
                ),
              ),
            ),
          ),
          SizedBox(width: 1,),
          Flexible(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                widget.buttonLabel1.toStringAsFixed(1),
                style: const TextStyle(
                  color: kPrimaryLightColor,
                ),
              ),
            ),
          ),
          const Icon(
            Icons.keyboard_arrow_right,
            color: Colors.black,
            size: 20,
          ),
        ],
      ),
    );
  }
}

class CustomBottomAppBarCart extends StatefulWidget {
  const CustomBottomAppBarCart({Key? key, required this.press})
      : super(key: key);
  final Function() press;

  @override
  State<CustomBottomAppBarCart> createState() => _CustomBottomAppBarCartState();
}

class _CustomBottomAppBarCartState extends State<CustomBottomAppBarCart> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
        padding: const EdgeInsets.symmetric(
            vertical: kDefaultPadding / 2, horizontal: kDefaultPadding),
        color: kPrimaryColor,
        height: size.height / 12,
        child: messageContent(size));
  }

  Widget messageContent(Size size) {
    return Padding(
          padding: const EdgeInsets.all(0),
          child: Consumer2<ProductsInCart, DiscountList>(
              builder: (context, psInCart, discounts, child) {
            double price = 0;
            for (int i = 0; i < psInCart.getNumberOfProducts(); ++i) {
              ProductModel p = psInCart.getProductAt(i);
              DiscountModel? d = p.discountId != null
                  ? discounts.discounts.firstWhereOrNull(
                      (element) => element.discountId == p.discountId)
                  : null;
              price += d != null
                  ? d.discountPercent != 0
                      ? psInCart.getQuantityOfProducts(p)! *
                          p.price! *
                          (100 - (d.discountPercent as num)) /
                          100
                      : psInCart.getQuantityOfProducts(p)! *
                          (p.price! - d.discountMoney!)
                  : psInCart.getQuantityOfProducts(p)! * p.price!;
            }
            return Container(
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: kDefaultPadding / 4),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Giao Đến • ${psInCart.getTotalQuantityOfProducts()} sản phẩm',
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w500),
                        ),
                        Text(
                          "${price.toStringAsFixed(1)}VND",
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  customButtonOfBottomAppBarCart(size),
                ],
              ),
            );
          },),

    );
  }

  Widget customButtonOfBottomAppBarCart(Size size) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      width: size.width / 3,
      height: size.height / 20,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(29),
        child: customElevatedButton(),
      ),
    );
  }

  Widget customElevatedButton() {
    return ElevatedButton(
      onPressed: widget.press,
      style: ElevatedButton.styleFrom(
        primary: Colors.white,
        padding: const EdgeInsets.symmetric(
          horizontal: 0,
          // vertical: 20,
        ),
      ),
      child: Text(
        "Đặt hàng".toUpperCase(),
        style: const TextStyle(
          color: kPrimaryColor,
          fontSize: 15,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
