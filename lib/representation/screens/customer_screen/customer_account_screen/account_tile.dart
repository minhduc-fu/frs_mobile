import 'package:flutter/material.dart';

import '../../../../core/constants/color_constants.dart';
import '../../../../core/constants/textstyle_constants.dart';

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
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 6),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: ColorPalette.hideColor,
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
      ),
    );
  }
}
