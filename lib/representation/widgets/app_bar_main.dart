import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../core/constants/color_constants.dart';
import '../../core/constants/dismension_constants.dart';
import '../../core/constants/textstyle_constants.dart';

class AppBarMain extends StatelessWidget {
  const AppBarMain({
    super.key,
    required this.child,
    this.titleAppbar,
    this.isCart = true,
    required this.leading,
    // this.onTap,
  });

  final Widget child;
  final String? titleAppbar;
  final bool isCart;
  final Widget leading;
  // final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          height: 56,
          child: AppBar(
            leading: leading,
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
                Positioned(
                  top: 18,
                  right: 60,
                  child: Icon(
                    FontAwesomeIcons.bell,
                    size: kDefaultIconSize18,
                    color: ColorPalette.primaryColor,
                  ),
                ),
                Positioned(
                  top: 18,
                  right: 20,
                  child: isCart
                      ? GestureDetector(
                          onTap: () {
                            // Navigator.of(context)
                            //     .pushNamed(CartFoodScreen.routeName);
                          },
                          child: Icon(
                            FontAwesomeIcons.cartShopping,
                            size: kDefaultIconSize18,
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
