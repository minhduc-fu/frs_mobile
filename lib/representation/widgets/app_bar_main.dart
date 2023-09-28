import 'package:demo_frs_app/core/constants/color_constants.dart';
import 'package:demo_frs_app/core/constants/textstyle_constants.dart';
import 'package:demo_frs_app/core/helper/asset_helper.dart';
import 'package:demo_frs_app/core/helper/image_helper.dart';
import 'package:demo_frs_app/representation/screens/FoodScreen/cart_food_screen.dart';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AppBarMain extends StatelessWidget {
  const AppBarMain({
    super.key,
    required this.child,
    this.titleAppbar,
    this.isBack = true,
    this.isCart = true,
  });

  final Widget child;
  final String? titleAppbar;
  final bool isBack;
  final bool isCart;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          height: 56,
          child: AppBar(
            title: Text(
              titleAppbar ?? '',
              style: TextStyles.h5.setTextSize(25),
            ),
            backgroundColor: ColorPalette.backgroundScaffoldColor,
            centerTitle: true,
            automaticallyImplyLeading: false,
            elevation: 0,
            // toolbarHeight: 90,

            flexibleSpace: Stack(
              children: [
                Container(
                    // decoration: BoxDecoration(color: ColorPalette.appBarColor),
                    ),
                Positioned(
                    top: 14,
                    left: 15,
                    child: isBack
                        ? GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Icon(
                              FontAwesomeIcons.angleLeft,
                              color: ColorPalette.primaryColor,
                            ),
                          )
                        : ImageHelper.loadFromAsset(AssetHelper.imageLogoFRS,
                            height: 35, width: 35)),
                // Positioned(
                //   left: 15,
                //   child: ImageHelper.loadFromAsset(AssetHelper.imageFRS,
                //       height: 56, width: 56),
                // ),
                // Positioned(
                //   left: 0,
                //   child: ImageHelper.loadFromAsset(AssetHelper.imageOvalLeft),
                // ),
                // Positioned(
                //   right: 0,
                //   child: ImageHelper.loadFromAsset(AssetHelper.imageOvalRight),
                // ),
                // Positioned(
                //   right: 131,
                //   left: 131,
                //   bottom: 0,
                //   child: Container(
                //     height: 56,
                //     decoration: BoxDecoration(
                //       color: ColorPalette.primaryColor,
                //     ),
                //   ),
                // ),
                Positioned(
                  top: 14,
                  right: 60,
                  child: Icon(
                    FontAwesomeIcons.bell,
                    color: ColorPalette.primaryColor,
                  ),
                ),
                Positioned(
                  top: 14,
                  right: 15,
                  child: isCart
                      ? GestureDetector(
                          onTap: () {
                            Navigator.of(context)
                                .pushNamed(CartFoodScreen.routeName);
                          },
                          child: Icon(
                            FontAwesomeIcons.cartShopping,
                            color: ColorPalette.primaryColor,
                          ),
                        )
                      : SizedBox(),
                ),
              ],
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 56),
          child: child,
        ),
      ],
    );
  }
}
