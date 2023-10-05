import 'package:demo_frs_app/core/constants/color_constants.dart';
import 'package:demo_frs_app/core/constants/textstyle_constants.dart';
import 'package:flutter/material.dart';

class AccountTile extends StatelessWidget {
  AccountTile(
      {super.key,
      this.icons,
      required this.title,
      this.trailing,
      required this.onTap});
  final void Function()? onTap;
  final IconData? icons;
  final IconData? trailing;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 15, vertical: 6),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5), // Màu bóng
            spreadRadius: 2,
            blurRadius: 4,
            offset: Offset(0, 2), // Vị trí của bóng
          ),
        ],
        borderRadius: BorderRadius.circular(5),
        color: ColorPalette.secondColor,
      ),
      height: 100,
      child: ListTile(
        horizontalTitleGap: 40, // khoảng cách title với leadding
        leading: Icon(
          icons,
        ),
        title: Text(
          title,
          style: TextStyles.h5.setTextSize(18),
        ),
        trailing: Icon(trailing),
        iconColor: ColorPalette.primaryColor,
      ),
    );
  }
}
