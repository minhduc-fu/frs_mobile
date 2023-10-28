import 'package:demo_frs_app/core/constants/color_constants.dart';
import 'package:demo_frs_app/core/constants/dismension_constants.dart';
import 'package:demo_frs_app/core/constants/textstyle_constants.dart';
import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  final controller;
  final String hintText;
  final bool obscureText;
  // final String messageError;
  final bool invalid = false;
  final Widget? prefixIcon;
  final Widget? suffixIcon;

  const MyTextField(
      {super.key,
      required this.controller,
      required this.hintText,
      required this.obscureText,
      // required this.messageError,
      this.prefixIcon,
      this.suffixIcon});

  @override
  Widget build(BuildContext context) {
    // var _emailError = 'Email không hợp lệ';
    // var _passwordError = 'Password phải trên 6 ký tự';
    // var _emailInvalid = false; // hợp lệ
    // var _passwordInvalid = false;
    return TextField(
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
