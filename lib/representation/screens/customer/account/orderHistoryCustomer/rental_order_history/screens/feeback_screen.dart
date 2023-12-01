import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:frs_mobile/core/constants/color_constants.dart';
import 'package:frs_mobile/core/constants/textstyle_constants.dart';

class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({super.key});

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Container(
              color: ColorPalette.backgroundScaffoldColor,
              child: Icon(FontAwesomeIcons.angleLeft)),
        ),
        centerTitle: true,
        title: Text(
          'Đánh giá sản phẩm',
          style: TextStyles.defaultStyle.bold.setTextSize(19),
        ),
        backgroundColor: ColorPalette.backgroundScaffoldColor,
      ),
    );
  }
}
