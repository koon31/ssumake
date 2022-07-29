import 'package:flutter/material.dart';
import 'package:ssumake/Constants/color.dart';

class CustomDiscountTag extends StatelessWidget {
  const CustomDiscountTag({Key? key, this.title, required this.isPercent})
      : super(key: key);
  final double? title;
  final bool isPercent;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
          top: kDefaultPadding / 10, left: kDefaultPadding / 10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding / 10),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5), color: Colors.red),
        child: isPercent
            ? Text(
                '- ' + title.toString() + '%',
                style: const TextStyle(color: Colors.white),
              )
            : Text(
                '- ' + title.toString() + 'VND',
                style: const TextStyle(color: Colors.white),
              ),
      ),
    );
  }
}

class CustomShockPriceTag extends StatelessWidget {
  const CustomShockPriceTag({Key? key, required this.title})
      : super(key: key);
  final String? title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
          top: kDefaultPadding / 10, right: kDefaultPadding / 10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding / 10),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5), color: Colors.red),
        child:  Text(
          title!,
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}