import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/color_constants.dart';
import '../../../core/constants/dismension_constants.dart';
import '../../../core/constants/textstyle_constants.dart';
import '../../../services/cart_provider.dart';
import '../../widgets/button_widget.dart';

class BuyCartScreen extends StatefulWidget {
  const BuyCartScreen({super.key});

  @override
  State<BuyCartScreen> createState() => _BuyCartScreenState();
}

class _BuyCartScreenState extends State<BuyCartScreen> {
  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final cartItems = cartProvider.cartItems;
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: 20),
          // tất cả sản phẩm
          Container(
            padding: EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(kDefaultCircle14),
            ),
            child: Row(
              children: [
                Checkbox(
                  value: true,
                  onChanged: (value) {},
                ),
                SizedBox(width: 10),
                Text(
                  'Tất cả sản phẩm',
                  style: TextStyles.h5.bold,
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: cartItems.length,
            itemBuilder: (context, index) {
              final cartItem = cartItems[index];
              return Container(
                padding: EdgeInsets.all(5),
                margin: EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(kDefaultCircle14),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ProductOwner
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Checkbox(
                              value: true,
                              onChanged: (value) {},
                            ),
                            SizedBox(width: 10),
                            Text(
                              '${cartItem.productOwnerName}',
                              style: TextStyles.h5.bold,
                            ),
                          ],
                        ),
                        Icon(FontAwesomeIcons.angleRight)
                      ],
                    ),
                    Divider(
                      thickness: 0.5,
                      color: ColorPalette.textHide,
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: cartItem.productDetailModel.length,
                      itemBuilder: (context, subIndex) {
                        final productDetail =
                            cartItem.productDetailModel[subIndex];
                        // Hiển thị thông tin sản phẩm ở đây
                        return Container(
                          margin: EdgeInsets.only(top: 10),
                          // padding: EdgeInsets.all(5),
                          height: 110,
                          // margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                          // padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            border: Border.all(color: ColorPalette.textHide),
                            borderRadius:
                                BorderRadius.circular(kDefaultCircle14),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Checkbox(
                                    // materialTapTargetSize:
                                    //     MaterialTapTargetSize.shrinkWrap,
                                    activeColor: ColorPalette.primaryColor,
                                    value: true,
                                    onChanged: (value) {},
                                  ),
                                  SizedBox(width: 10),
                                  // productAvt
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(
                                          kDefaultCircle14),
                                    ),
                                    child: Image.network(
                                      cacheHeight: 80,
                                      cacheWidth: 80,
                                      productDetail.productAvt!,
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  // productName, price
                                  Padding(
                                    padding: EdgeInsets.symmetric(vertical: 20),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          productDetail.productName,
                                          style: TextStyles.h5.bold,
                                        ),
                                        Text(
                                          '${NumberFormat.currency(locale: 'vi_VN', symbol: 'vnđ').format(productDetail.price)}',
                                          style: TextStyles.defaultStyle.bold,
                                        ),
                                      ],
                                    ),
                                  ),

                                  SizedBox(width: 10),
                                ],
                              ),
                              // iconDelete
                              // Row(
                              //   children: [
                              //     Icon(FontAwesomeIcons.trashCan),
                              //     SizedBox(width: 10)
                              //   ],
                              // ),
                              Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Column(
                                  // mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(FontAwesomeIcons.trashCan),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
              );
            },
          ),
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
        ],
      ),
    );
  }
}
