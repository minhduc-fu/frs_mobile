import 'package:demo_frs_app/core/constants/color_constants.dart';
import 'package:demo_frs_app/core/helper/asset_helper.dart';
import 'package:demo_frs_app/core/helper/image_helper.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AppBarContainer extends StatelessWidget {
  const AppBarContainer({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          height: 56,
          child: AppBar(
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
                  left: 15,
                  child: ImageHelper.loadFromAsset(AssetHelper.imageFRS,
                      height: 56, width: 56),
                ),
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
                  child: Icon(
                    FontAwesomeIcons.cartShopping,
                    color: ColorPalette.primaryColor,
                  ),
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
