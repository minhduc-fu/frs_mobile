import 'package:flutter/material.dart';

import 'color_constants.dart';

class SquareTile extends StatelessWidget {
  final Widget child;
  final Function()? onTap;
  const SquareTile({super.key, required this.child, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
            border: Border.all(color: Colors.white),
            borderRadius: BorderRadius.circular(16),
            color: ColorPalette.backgroundScaffoldColor),
        child: child,
      ),
    );
  }
}
