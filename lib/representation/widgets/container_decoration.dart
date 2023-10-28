import 'package:demo_frs_app/core/constants/color_constants.dart';
import 'package:demo_frs_app/core/constants/dismension_constants.dart';
import 'package:flutter/material.dart';

Widget customContainer(dynamic child) {
  return Container(
    padding: EdgeInsets.all(10),
    decoration: BoxDecoration(
      color: ColorPalette.primaryColor,
      borderRadius: BorderRadius.circular(kDefaultCircle14),
    ),
    child: Center(
      child: child, // Sử dụng child tùy chỉnh
    ),
  );
}
