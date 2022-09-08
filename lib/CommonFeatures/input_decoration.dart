import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../Constants/color.dart';

class RoundedInputField extends StatefulWidget {
  final String hintText;
  final IconData icon;
  final TextInputType type;
  final String? suffixText;
  final ValueChanged<String> onChanged;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final int? maxLength;

  const RoundedInputField({
    Key? key,
    required this.controller,
    this.validator,
    this.type = TextInputType.name,
    this.hintText = "Họ và Tên",
    this.icon = Icons.person,
    this.suffixText,
    required this.onChanged,
    this.maxLength,
  }) : super(key: key);

  @override
  State<RoundedInputField> createState() => _RoundedInputFieldState();
}

class _RoundedInputFieldState extends State<RoundedInputField> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding * 2.4, vertical: kDefaultPadding / 2),
      child: TextFormField(
        controller: widget.controller,
        keyboardType: widget.type,
        onChanged: widget.onChanged,
        cursorColor: kPrimaryColor,
        validator: widget.validator,
        decoration: InputDecoration(
          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(28), borderSide: BorderSide.none),
          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(28), borderSide: BorderSide.none),
          errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(28), borderSide: BorderSide.none),
          focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(28), borderSide: BorderSide.none),
          filled: true,
          fillColor: kPrimaryLightColor,
          prefixIcon: Icon(
            widget.icon,
            color: kPrimaryColor,
          ),
          suffixText: widget.suffixText,
          hintText: widget.hintText,
          border: InputBorder.none,
        ),
      ),
    );
  }
}

class VerifyRoundedInputField extends StatefulWidget {
  final String hintText;
  final IconData icon;
  final TextInputType type;
  final ValueChanged<String> onChanged;
  final TextEditingController controller;
  final bool isEnable;
  final String? Function(String?)? validator;

  const VerifyRoundedInputField({
    Key? key,
    this.isEnable = false,
    required this.controller,
    this.type = TextInputType.name,
    this.hintText = "Họ và Tên",
    this.icon = Icons.verified_user,
    required this.onChanged,
    this.validator,
  }) : super(key: key);

  @override
  State<VerifyRoundedInputField> createState() => _VerifyRoundedInputFieldState();
}

class _VerifyRoundedInputFieldState extends State<VerifyRoundedInputField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      keyboardType: widget.type,
      onChanged: widget.onChanged,
      cursorColor: kPrimaryColor,
      enabled: widget.isEnable,
      validator: widget.validator,
      maxLength: 6,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(6),
      ],
      decoration: InputDecoration(
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(28), borderSide: BorderSide.none),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(28), borderSide: BorderSide.none),
        disabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(28), borderSide: BorderSide.none),
        errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(28), borderSide: BorderSide.none),
        focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(28), borderSide: BorderSide.none),
        filled: true,
        fillColor: kPrimaryLightColor,
        prefixIcon: Icon(
          widget.icon,
          color: kPrimaryColor,
        ),
        hintText: widget.hintText,
        border: InputBorder.none,
        hintStyle: const TextStyle(fontSize: 14),
        counterText: '',
      ),
    );
  }
}

// ignore: must_be_immutable
class RoundedPasswordField extends StatefulWidget {
  final ValueChanged<String> onChanged;
  final bool isConfirm;
  final TextEditingController controller;
  final String? Function(String?)? validator;

  const RoundedPasswordField({
    Key? key,
    required this.validator,
    required this.controller,
    required this.isConfirm,
    required this.onChanged,
  }) : super(key: key);

  @override
  State<RoundedPasswordField> createState() => _RoundedPasswordFieldState();
}

class _RoundedPasswordFieldState extends State<RoundedPasswordField> {
  bool _isObscure = true;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding * 2.4, vertical: kDefaultPadding / 2),
      child: TextFormField(
        controller: widget.controller,
        obscureText: _isObscure,
        onChanged: widget.onChanged,
        cursorColor: kPrimaryColor,
        decoration: InputDecoration(
          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(28), borderSide: BorderSide.none),
          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(28), borderSide: BorderSide.none),
          errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(28), borderSide: BorderSide.none),
          focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(28), borderSide: BorderSide.none),
          filled: true,
          fillColor: kPrimaryLightColor,
          hintText: widget.isConfirm ? "Nhập lại mật khẩu" : "Mật khẩu",
          prefixIcon: const Icon(
            Icons.lock,
            color: kPrimaryColor,
          ),
          suffixIcon: IconButton(
            icon: Icon(_isObscure ? Icons.visibility_off : Icons.visibility),
            color: kPrimaryColor,
            onPressed: () {
              setState(() {
                _isObscure = !_isObscure;
              });
            },
          ),
          border: InputBorder.none,
        ),
        validator: widget.validator,
      ),
    );
  }
}
