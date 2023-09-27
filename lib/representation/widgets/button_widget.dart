import 'package:demo_frs_app/core/constants/color_constants.dart';
import 'package:demo_frs_app/core/constants/textstyle_constants.dart';
import 'package:flutter/material.dart';

class ButtonWidget extends StatefulWidget {
  const ButtonWidget(
      {super.key,
      required this.title,
      this.onTap,
      this.height,
      this.width,
      this.size});

  final String title;
  final Function()? onTap;
  final double? height;
  final double? width;
  final double? size;

  @override
  State<ButtonWidget> createState() => _ButtonWidgetState();
}

class _ButtonWidgetState extends State<ButtonWidget> {
  var glowing = false;
  var scale = 1.0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapUp: (val) {
        setState(() {
          glowing = false;
          scale = 1.0;
        });
      },
      onTapDown: (val) {
        setState(() {
          glowing = true;
          scale = 1.1;
        });
      },
      onTap: widget.onTap,
      child: AnimatedContainer(
        transform: Matrix4.identity()..scale(scale),
        duration: Duration(milliseconds: 100),
        height: widget.height,
        width: widget.width,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: ColorPalette.primaryColor,
            boxShadow: glowing
                ? [
                    BoxShadow(
                      color: Colors.black38,
                      spreadRadius: 1,
                      blurRadius: 4,
                      offset: Offset(8, 0),
                    ),
                  ]
                : []),
        child: Center(
          child: Text(
            widget.title,
            style: TextStyles.defaultStyle.bold.whiteTextColor
                .setTextSize(widget.size!),
          ),
        ),
      ),
    );
  }
}
