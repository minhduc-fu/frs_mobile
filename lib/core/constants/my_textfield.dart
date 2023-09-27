import 'package:demo_frs_app/core/constants/color_constants.dart';
import 'package:demo_frs_app/core/constants/textstyle_constants.dart';
import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  final controller;
  final String hintText;
  final bool obscureText;
  final String messageError;
  final bool invalid = false;

  const MyTextField(
      {super.key,
      required this.controller,
      required this.hintText,
      required this.obscureText,
      required this.messageError});

  @override
  Widget build(BuildContext context) {
    // var _emailError = 'Email không hợp lệ';
    // var _passwordError = 'Password phải trên 6 ký tự';
    // var _emailInvalid = false; // hợp lệ
    // var _passwordInvalid = false;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          errorText: invalid ? messageError : null,
          labelText: hintText,
          labelStyle: TextStyles.defaultStyle.setColor(ColorPalette.textHide),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
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
      ),
    );
  }
}
