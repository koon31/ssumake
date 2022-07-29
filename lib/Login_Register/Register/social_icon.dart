import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../Constants/color.dart';

class SocialIcon extends StatelessWidget {
  final String iconSrc;
  final Function() press;

  const SocialIcon({
    Key? key,
    required this.iconSrc,
    required this.press,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: press,
      style: ElevatedButton.styleFrom(
        primary: kPrimaryLightColor,
        padding: const EdgeInsets.all(20),
        shape:
            const CircleBorder(side: BorderSide(color: kPrimaryColor, width: 2)),
      ),
      child: SvgPicture.asset(
        iconSrc,
        color: kPrimaryColor,
        height: 20,
        width: 20,
      ),
    );
  }
}
