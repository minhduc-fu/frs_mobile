import 'package:flutter/material.dart';
import 'package:frs_mobile/core/constants/color_constants.dart';
import 'package:frs_mobile/core/constants/dismension_constants.dart';
import 'package:frs_mobile/core/constants/textstyle_constants.dart';

class MyTextFormField extends StatelessWidget {
  final controller;
  final String hintText;
  final bool? obscureText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final TextInputType? keyboardType;
  final AutovalidateMode? autovalidateMode;
  final bool? enable;

  const MyTextFormField({
    super.key,
    required this.controller,
    required this.hintText,
    this.validator,
    this.obscureText = false,
    this.prefixIcon,
    this.suffixIcon,
    this.keyboardType,
    this.autovalidateMode,
    this.onChanged,
    this.enable = true,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      enabled: enable,
      obscureText: obscureText!,
      keyboardType: keyboardType,
      controller: controller,
      onChanged: onChanged,
      validator: validator,
      autovalidateMode: autovalidateMode,
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(kDefaultCircle14),
          borderSide: BorderSide(color: Colors.grey),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(kDefaultCircle14),
          borderSide: BorderSide(color: ColorPalette.textHide),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: ColorPalette.primaryColor),
          borderRadius: BorderRadius.circular(kDefaultCircle14),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(kDefaultCircle14),
          borderSide: BorderSide(color: Colors.redAccent),
        ),
        errorStyle: TextStyles.defaultStyle.setColor(Colors.redAccent),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(kDefaultCircle14),
          borderSide: BorderSide(color: Colors.redAccent),
        ),
        fillColor: Colors.white,
        filled: true,
        hintStyle: TextStyles.defaultStyle.setColor(ColorPalette.textHide),
      ),
    );
  }
}
