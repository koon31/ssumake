// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:badges/badges.dart';
import 'package:flutter/material.dart';

class CustomCartButton extends StatefulWidget {
  const CustomCartButton({Key? key, required this.numberOfProducts, this.color, required this.press}) : super(key: key);
  final int numberOfProducts;
  final Color? color;
  final Function() press;

  @override
  State<CustomCartButton> createState() => _CustomCartButtonState();
}

class _CustomCartButtonState extends State<CustomCartButton> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Badge(
        child: Icon(
          Icons.shopping_cart,
          color: widget.color ?? Colors.white,
        ),
        badgeContent: Text(widget.numberOfProducts.toString()),
        showBadge: widget.numberOfProducts>0?true:false,
        position: BadgePosition.topEnd(top: 5, end: -5),
        animationType: BadgeAnimationType.slide,
      ),
      onTap: widget.press,
    );
  }
}
