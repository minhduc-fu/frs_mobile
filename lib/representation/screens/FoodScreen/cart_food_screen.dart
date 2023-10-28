import 'package:demo_frs_app/core/constants/color_constants.dart';
import 'package:demo_frs_app/core/constants/dismension_constants.dart';
import 'package:demo_frs_app/core/constants/textstyle_constants.dart';
import 'package:demo_frs_app/models/food.dart';
import 'package:demo_frs_app/representation/screens/FoodScreen/shop.dart';
import 'package:demo_frs_app/representation/widgets/app_bar_main.dart';
import 'package:demo_frs_app/representation/widgets/button_widget.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class CartFoodScreen extends StatelessWidget {
  const CartFoodScreen({super.key});
  static const String routeName = '/cart_food_screen';
  void removeFromCart(Food food, BuildContext context) {
    // final shop = context.read<Shop>();
    // get access to shop
    final shop = context.read<Shop>();

    // remove form cart
    shop.removeFormCart(food);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<Shop>(
      builder: (context, shop, child) => AppBarMain(
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            FontAwesomeIcons.angleLeft,
            size: kDefaultIconSize18,
          ),
        ),
        isCart: false,
        titleAppbar: 'My Cart',
        child: Scaffold(
          body: Column(
            children: [
              // Customer Cart
              Expanded(
                child: ListView.builder(
                  itemCount: shop.cart.length,
                  itemBuilder: (context, index) {
                    // get food form cart
                    final Food foodItem = shop.cart[index];

                    // get food name
                    final String foodName = foodItem.name;

                    // get food pirce
                    final String foodPrice = foodItem.price;

                    // return list tile
                    return Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: ColorPalette.secondColor,
                      ),
                      margin: EdgeInsets.only(left: 25, right: 25, top: 20),
                      child: ListTile(
                        title: Text(
                          "${foodName}",
                          style: TextStyles.defaultStyle.bold,
                        ),
                        subtitle: Text(
                          "$foodPrice",
                          style: TextStyles.defaultStyle.bold,
                        ),
                        trailing: IconButton(
                          onPressed: () => removeFromCart(foodItem, context),
                          icon: Icon(
                            FontAwesomeIcons.trash,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              // Pay button
              Padding(
                padding: const EdgeInsets.all(25.0),
                child: ButtonWidget(
                  title: 'Pay Now',
                  size: 22,
                  height: 70,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
