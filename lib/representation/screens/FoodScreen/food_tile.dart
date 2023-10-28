import 'package:demo_frs_app/core/constants/color_constants.dart';
import 'package:demo_frs_app/core/constants/textstyle_constants.dart';
import 'package:demo_frs_app/models/food.dart';
import 'package:demo_frs_app/utils/image_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class FoodTile extends StatelessWidget {
  final Food food;
  final Function()? onTap;
  const FoodTile({super.key, required this.food, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(25),
        margin: EdgeInsets.only(left: 25),
        decoration: BoxDecoration(
          color: ColorPalette.secondColor,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // image
            ImageHelper.loadFromAsset(food.imagePath, height: 140),
            SizedBox(height: 5),
            // text
            Text(
              food.name,
              style: TextStyles.defaultStyle.setTextSize(20),
            ),
            SizedBox(height: 5),

            // price and rating
            SizedBox(
              width: 160,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // price
                  Text(
                    '\$' + food.price,
                    style: TextStyles.defaultStyle.bold,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  // rating
                  Row(
                    children: [
                      Icon(
                        FontAwesomeIcons.solidStar,
                        color: Colors.yellow,
                        size: 18,
                      ),
                      SizedBox(width: 5),
                      Text(
                        food.rating,
                        style: TextStyles.defaultStyle.setColor(
                            ColorPalette.primaryColor.withOpacity(0.4)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
