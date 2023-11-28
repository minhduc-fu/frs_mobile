import 'package:flutter/material.dart';

import 'color_constants.dart';
import 'dismension_constants.dart';
import 'textstyle_constants.dart';

class MyTextField extends StatelessWidget {
  final controller;
  final String hintText;
  final bool obscureText;
  final bool invalid = false;
  final TextInputType? textInputType;
  final Widget? prefixIcon;
  final Widget? suffixIcon;

  const MyTextField(
      {super.key,
      required this.controller,
      required this.hintText,
      required this.obscureText,
      this.textInputType,
      this.prefixIcon,
      this.suffixIcon});

  @override
  Widget build(BuildContext context) {
    // var _emailError = 'Email không hợp lệ';
    // var _passwordError = 'Password phải trên 6 ký tự';
    // var _emailInvalid = false; // hợp lệ
    // var _passwordInvalid = false;
    return TextField(
      keyboardType: textInputType,
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        prefixIconColor: ColorPalette.primaryColor,
        suffixIconColor: ColorPalette.primaryColor,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        // errorText: invalid ? messageError : null,
        labelText: hintText,
        labelStyle: TextStyles.defaultStyle.setColor(ColorPalette.textHide),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(kDefaultCircle14),
          borderSide: BorderSide(color: ColorPalette.textHide),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: ColorPalette.primaryColor),
        ),
        fillColor: Colors.white,
        filled: true,
        hintText: hintText,
        hintStyle: TextStyles.defaultStyle.setColor(ColorPalette.textHide),
      ),
    );
  }
}
