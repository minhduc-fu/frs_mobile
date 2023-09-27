import 'package:demo_frs_app/core/constants/color_constants.dart';
import 'package:demo_frs_app/core/constants/textstyle_constants.dart';
import 'package:demo_frs_app/core/helper/asset_helper.dart';
import 'package:demo_frs_app/core/helper/image_helper.dart';

import 'package:demo_frs_app/representation/screens/FoodScreen/food_details_screen.dart';
import 'package:demo_frs_app/representation/screens/FoodScreen/food_tile.dart';
import 'package:demo_frs_app/representation/screens/FoodScreen/shop.dart';

import 'package:demo_frs_app/representation/widgets/app_bar_main.dart';
import 'package:demo_frs_app/representation/widgets/button_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});
  static const String routeName = '/menu_screen';
  @override
  State<MenuScreen> createState() => __MenuScreenState();
}

class __MenuScreenState extends State<MenuScreen> {
  // food menu
  // List foodMenu = [
  //   Food(
  //       name: 'Salmon Sushi',
  //       price: '21.00',
  //       imagePath: AssetHelper.imageSushi2,
  //       rating: '4.9'),
  //   Food(
  //       name: 'Tuna Sushi',
  //       price: '23.00',
  //       imagePath: AssetHelper.imageSushi3,
  //       rating: '4.5'),
  // ];

  // navigate to food item details screen
  void navigateToFoodDetails(int index) {
    // get the shop and it is menu
    final shop = context.read<Shop>();
    final foodMenu = shop.foodMenu;

    // Navigator.of(context).pushNamed(FoodDetailsScreen.routeName);
    Navigator.push(
      context,
      CupertinoPageRoute(
        builder: ((context) => FoodDetailsScreen(food: foodMenu[index])),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final shop = context.read<Shop>();
    final foodMenu = shop.foodMenu;
    return AppBarMain(
      isBack: false,
      titleAppbar: 'Home',
      child: Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // promo banner
            Container(
              decoration: BoxDecoration(
                  color: ColorPalette.secondColor,
                  borderRadius: BorderRadius.circular(5)),
              margin: EdgeInsets.symmetric(horizontal: 25),
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 25),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // promo message
                      Text(
                        'Get 32% Promo',
                        style: TextStyles.defaultStyle.setTextSize(20).bold,
                      ),
                      SizedBox(height: 20),

                      // redeem button
                      ButtonWidget(
                        title: 'Redeem',
                        onTap: () {},
                        size: 15,
                        height: 50,
                        width: 100,
                      ),
                    ],
                  ),

                  //image
                  ImageHelper.loadFromAsset(AssetHelper.imageSushi,
                      height: 100),
                ],
              ),
            ),
            SizedBox(height: 25),
            // search bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search here...',
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                    borderSide: BorderSide(color: ColorPalette.primaryColor),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                    borderSide: BorderSide(color: ColorPalette.secondColor),
                  ),
                ),
              ),
            ),
            SizedBox(height: 25),

            // menu list
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Text(
                'Food Menu',
                style: TextStyles.defaultStyle.setTextSize(18).bold,
              ),
            ),
            SizedBox(height: 10),

            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: foodMenu.length,
                itemBuilder: (context, index) => FoodTile(
                  food: foodMenu[index],
                  onTap: () => navigateToFoodDetails(index),
                ),
              ),
            ),
            SizedBox(height: 25),

            // popular food
            Container(
              padding: EdgeInsets.all(20),
              margin: EdgeInsets.only(left: 25, bottom: 25, right: 25),
              decoration: BoxDecoration(
                  color: ColorPalette.secondColor,
                  borderRadius: BorderRadius.circular(5)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // image
                  Row(
                    children: [
                      ImageHelper.loadFromAsset(AssetHelper.imageSushi,
                          height: 60),
                      SizedBox(width: 20),

                      // name and price
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // name
                          Text(
                            'Salmon Eggs',
                            style: TextStyles.defaultStyle.setTextSize(18),
                          ),
                          SizedBox(height: 10),
                          //price
                          Text(
                            '\$21.00',
                            style: TextStyles.defaultStyle,
                          )
                        ],
                      ),
                    ],
                  ),

                  // heart
                  Icon(FontAwesomeIcons.heart)
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
