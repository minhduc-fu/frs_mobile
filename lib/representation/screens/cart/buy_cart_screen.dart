import 'package:flutter/material.dart';

import '../../../core/constants/color_constants.dart';
import '../../../core/constants/dismension_constants.dart';
import '../../../core/constants/textstyle_constants.dart';
import '../../widgets/button_widget.dart';
import '../../widgets/cart_item_buy.dart';

class BuyCartScreen extends StatefulWidget {
  const BuyCartScreen({super.key});

  @override
  State<BuyCartScreen> createState() => _BuyCartScreenState();
}

class _BuyCartScreenState extends State<BuyCartScreen> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Select All'),
                    Checkbox(
                      value: true,
                      onChanged: (value) {},
                    ),
                  ],
                ),
                // SizedBox(height: 10),
                CartItemBuy(),
                SizedBox(height: 20),
                Text(
                  'Thông tin đơn hàng',
                  style: TextStyles.h5.bold,
                ),
                SizedBox(height: 20),
                Container(
                  // padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(kDefaultCircle14),
                      color: ColorPalette.hideColor),
                  child: Column(
                    children: [
                      SizedBox(height: 15),
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Delivery Cost'),
                                Text('Tổng giá tiền'),
                              ],
                            ),
                            SizedBox(height: 15),
                            Divider(
                              color: ColorPalette.primaryColor,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Total payment'),
                                Text('\$50.00'),
                              ],
                            ),
                          ],
                        ),
                      ),
                      ButtonWidget(
                        title: 'Đặt hàng',
                        size: 22,
                        height: 70,
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
