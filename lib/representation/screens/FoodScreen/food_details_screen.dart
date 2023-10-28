import 'package:demo_frs_app/core/constants/color_constants.dart';
import 'package:demo_frs_app/core/constants/dismension_constants.dart';
import 'package:demo_frs_app/core/constants/textstyle_constants.dart';
import 'package:demo_frs_app/models/food.dart';
import 'package:demo_frs_app/representation/screens/FoodScreen/shop.dart';
import 'package:demo_frs_app/representation/widgets/app_bar_main.dart';
import 'package:demo_frs_app/representation/widgets/button_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';

class FoodDetailsScreen extends StatefulWidget {
  const FoodDetailsScreen({super.key, required this.food});
  final Food food;
  static const String routeName = '/food_details_screen';
  @override
  State<FoodDetailsScreen> createState() => _FoodDetailsScreenState();
}

class _FoodDetailsScreenState extends State<FoodDetailsScreen> {
  // quantity
  int quantityCount = 0;

  // decrementQuantity
  void decrementQuantity() {
    setState(() {
      if (quantityCount > 0) {
        quantityCount--;
      }
    });
  }

  // incrementQuantity
  void incrementQuantity() {
    setState(() {
      quantityCount++;
    });
  }

  void addToCart() {
    // chỉ thêm vào cart nếu có thứ gì đó trong cart
    if (quantityCount > 0) {
      // get access to shop
      final shop = context.read<Shop>();

      // add to cart
      shop.addToCart(widget.food, quantityCount);

      // let the user know it was successful

      // showDialog(
      //   barrierDismissible: false,
      //   context: context,
      //   builder: (context) => AlertDialog(
      //     backgroundColor: ColorPalette.secondColor,
      //     content: Text(
      //       'Successfully added to cart',
      //       style: TextStyles.defaultStyle.setTextSize(18),
      //       textAlign: TextAlign.center,
      //     ),
      //     actions: [
      //       // okay button
      //       Row(
      //         mainAxisAlignment: MainAxisAlignment.center,
      //         children: [
      //           ButtonWidget(
      //             onTap: () {
      //               // back về 1 lần thì về detail
      //               Navigator.pop(context);
      //               // back về lần nữa là về home
      //               Navigator.pop(context);
      //             },
      //             title: 'OK',
      //             size: 20,
      //             width: 100,
      //             height: 50,
      //           ),
      //         ],
      //       )
      //     ],
      //   ),
      // );

// let the user know it was successful

      Toast.show('Successfully added to cart',
          textStyle: TextStyles.defaultStyle,
          backgroundColor: ColorPalette.secondColor,
          backgroundRadius: 5);
    }
  }

  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
    return AppBarMain(
      leading: GestureDetector(
        onTap: () {
          Navigator.pop(context);
        },
        child: Icon(
          FontAwesomeIcons.angleLeft,
          size: kDefaultIconSize18,
        ),
      ),
      titleAppbar: 'Details',
      child: Scaffold(
        body: Column(
          children: [
            // listview of food details
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: ListView(
                  children: [
                    // image
                    Image.asset(
                      widget.food.imagePath,
                      height: 200,
                    ),
                    SizedBox(height: 25),

                    // food name
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          widget.food.name,
                          style: TextStyles.defaultStyle.setTextSize(28).bold,
                        ),
                        Row(
                          children: [
                            //start icon
                            Icon(
                              FontAwesomeIcons.solidStar,
                              color: Colors.yellow,
                              size: 18,
                            ),
                            SizedBox(width: 5),

                            //rating number
                            Text(
                              widget.food.rating,
                              style: TextStyles.defaultStyle
                                  .setColor(ColorPalette.textHide)
                                  .bold,
                            )
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 10),

                    // rating

                    SizedBox(height: 25),

                    // description
                    Text(
                      'Description',
                      style: TextStyles.defaultStyle.setTextSize(18).bold,
                    ),
                    SizedBox(height: 10),
                    Text(
                      "Delicate sliced, fresh salmon drapes elegantly over a pillow of perfectly seasoned sushi rice.",
                      style: TextStyle(
                          height: 1.5,
                          color: ColorPalette.primaryColor.withOpacity(0.8),
                          fontFamily: FontFamilyRoboto.roboto),
                    )
                  ],
                ),
              ),
            ),

            // price + quantity + add to cart button
            Container(
              padding: EdgeInsets.all(25),
              color: ColorPalette.secondColor,
              child: Column(
                children: [
                  // price + quantity
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // price
                      Text(
                        "\$  ${widget.food.price}",
                        style: TextStyles.defaultStyle.setTextSize(18).bold,
                      ),

                      // quantity
                      Row(
                        children: [
                          // minus button
                          Container(
                            decoration: BoxDecoration(
                                color:
                                    ColorPalette.primaryColor.withOpacity(0.4),
                                borderRadius: BorderRadius.circular(5)),
                            child: IconButton(
                              icon: Icon(
                                FontAwesomeIcons.minus,
                                color: ColorPalette.primaryColor,
                              ),
                              onPressed: decrementQuantity,
                            ),
                          ),

                          // quantity count
                          SizedBox(
                            width: 40,
                            child: Center(
                              child: Text(
                                quantityCount.toString(),
                                style: TextStyles.defaultStyle
                                    .setTextSize(18)
                                    .bold,
                              ),
                            ),
                          ),
                          // plus button
                          Container(
                            decoration: BoxDecoration(
                                color:
                                    ColorPalette.primaryColor.withOpacity(0.4),
                                borderRadius: BorderRadius.circular(5)),
                            child: IconButton(
                              icon: Icon(
                                FontAwesomeIcons.plus,
                                color: ColorPalette.primaryColor,
                              ),
                              onPressed: incrementQuantity,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  // add to cart button
                  ButtonWidget(
                    title: 'Add to cart',
                    onTap: addToCart,
                    height: 70,
                    size: 18,
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
