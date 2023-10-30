import 'package:flutter/material.dart';
import '../../core/constants/color_constants.dart';
import '../../core/constants/dismension_constants.dart';
import '../../core/constants/textstyle_constants.dart';

Widget customContainer(dynamic child) {
  return Container(
    padding: EdgeInsets.all(10),
    decoration: BoxDecoration(
      color: ColorPalette.primaryColor,
      borderRadius: BorderRadius.circular(kDefaultCircle14),
    ),
    child: Text(
      child,
      style: TextStyles.defaultStyle.whiteTextColor, // Sử dụng child tùy chỉnh
    ),
    // child: Center(
    //   child: child, // Sử dụng child tùy chỉnh
    // ),
  );
}
