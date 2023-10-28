import 'package:flutter/material.dart';
import '../../core/constants/color_constants.dart';

Widget buildIndicator(bool isActive, Size size) {
  return AnimatedContainer(
    duration: Duration(milliseconds: 300),
    curve: Curves.bounceInOut,
    margin: EdgeInsets.symmetric(horizontal: 10), // cách từng cục item
    width: isActive ? 20 : 10,
    decoration: BoxDecoration(
      color: isActive ? ColorPalette.primaryColor : ColorPalette.textHide,
      borderRadius: BorderRadius.circular(5),
      // boxShadow: [
      //   BoxShadow(color: Colors.black38, offset: Offset(3, 6), blurRadius: 3),
      // ],
    ),
  );
}
