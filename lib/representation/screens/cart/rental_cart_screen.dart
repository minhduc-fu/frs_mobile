import 'package:flutter/material.dart';

import '../../widgets/cart_item_buy.dart';

class RentalCartScreen extends StatefulWidget {
  const RentalCartScreen({super.key});

  @override
  State<RentalCartScreen> createState() => _RentalCartScreenState();
}

class _RentalCartScreenState extends State<RentalCartScreen> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            child: Column(
              children: [
                SizedBox(height: 10),
                CartItemBuy(),
                SizedBox(height: 50),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Select All'),
                      Checkbox(
                        value: true,
                        onChanged: (value) {},
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 15),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Delivery Cost'),
                      Text('Tổng giá tiền'),
                    ],
                  ),
                ),
                SizedBox(height: 15),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Total payment'),
                      Text('\$50.00'),
                    ],
                  ),
                ),
                SizedBox(height: 30),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
