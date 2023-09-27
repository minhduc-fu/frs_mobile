import 'package:demo_frs_app/core/constants/textstyle_constants.dart';
import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  final Function()? onTap;
  final String action;
  const MyButton({super.key, required this.onTap, required this.action});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(25),
        margin: EdgeInsets.symmetric(horizontal: 25),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8), color: Colors.black),
        child: Center(
          child: Text(
            action,
            style: TextStyles.h5
                .copyWith(fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
