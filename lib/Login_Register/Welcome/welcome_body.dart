import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../Constants/color.dart';
import '../../CommonFeatures/custom_button.dart';
import '../Login/login_page.dart';
import '../Register/register_page.dart';
import 'welcome_background.dart';

class WelcomeBody extends StatelessWidget {
  const WelcomeBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      decoration: const BoxDecoration(color: Colors.white),
      child: BackgroundWelcome(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: size.width * 0.1,
          ),
          child: Column(
            children: [
              Expanded(
                flex: 2,
                child: SvgPicture.asset(
                  "assets/icons/welcome_supermarket.svg",
                  height: size.height * 0.45,
                ),
              ),
              DefaultTextStyle(
                style: TextStyle(
                  fontSize: size.height * 0.05,
                  fontWeight: FontWeight.bold,
                  color: kPrimaryColor,
                ),
                child: const Text(
                  'Smart Supermarket',
                  textAlign: TextAlign.center,
                ),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomButtonLarge(
                      text: "LOGIN",
                      press: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context)
                              => const LoginPage()
                          ),
                        );
                      },
                      height: size.height * 0.07,
                    ),
                    CustomButtonLarge(
                      text: "REGISTER",
                      color: kPrimaryLightColor,
                      textColor: Colors.black,
                      press: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return const RegisterPage();
                            },
                          ),
                        );
                      },
                      height: size.height * 0.07,
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}