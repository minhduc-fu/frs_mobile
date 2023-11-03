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
  bool isAllChecked = false;
  List<bool> productOwnerCheckStates = [];
  @override
  void initState() {
    super.initState();
    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    productOwnerCheckStates =
        List.generate(cartProvider.cartItems.length, (index) => false);
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final cartItems = cartProvider.cartItems;

    return cartItems.isEmpty
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(kDefaultCircle14),
                    color: Colors.white),
                child: Text(
                  "Giỏ hàng Mua của bạn chưa có sản phẩm!",
                  style: TextStyles.h5.bold,
                ),
              ),
            ],
          )
        : Column(
            children: [
              SizedBox(height: 20),
              // tất cả sản phẩm
              Expanded(
                  child: ListView(
                children: [
                  Container(
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(kDefaultCircle14),
                    ),
                    child: Row(
                      children: [
                        Checkbox(
                          value: isAllChecked,
                          onChanged: (value) {
                            setState(() {
                              isAllChecked = value!;
                            });
                            for (int i = 0; i < cartItems.length; i++) {
                              if (i < productOwnerCheckStates.length) {
                                productOwnerCheckStates[i] = value!;
                                // Thay đổi trạng thái của tất cả sản phẩm thuộc chủ sở hữu đó
                                for (var productDetail
                                    in cartItems[i].productDetailModel) {
                                  productDetail.isChecked = value!;
                                }
                              }
                            }
                            // for (int i = 0; i < cartItems.length; i++) {
                            //   if (i < productOwnerCheckStates.length) {
                            //     productOwnerCheckStates[i] = value!;
                            //   }
                            // }
                          },
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
                                      value: productOwnerCheckStates[index],
                                      onChanged: (value) {
                                        setState(() {
                                          if (index <
                                              productOwnerCheckStates.length) {
                                            productOwnerCheckStates[index] =
                                                value!;
                                          }
                                        });
                                        // Thay đổi trạng thái của tất cả sản phẩm thuộc chủ sở hữu đó
                                        for (var productDetail
                                            in cartItem.productDetailModel) {
                                          productDetail.isChecked = value!;
                                        }
                                      },
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
                                    border: Border.all(
                                        color: ColorPalette.textHide),
                                    borderRadius:
                                        BorderRadius.circular(kDefaultCircle14),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Checkbox(
                                            // materialTapTargetSize:
                                            //     MaterialTapTargetSize.shrinkWrap,
                                            activeColor:
                                                ColorPalette.primaryColor,
                                            value: productDetail.isChecked,
                                            onChanged: (value) {
                                              setState(() {
                                                productDetail.isChecked =
                                                    value!;
                                              });
                                              // Kiểm tra xem tất cả các sản phẩm của chủ sở hữu đã được chọn hay chưa
                                              if (cartItem.productDetailModel
                                                  .every((detail) =>
                                                      detail.isChecked)) {
                                                productOwnerCheckStates[index] =
                                                    true;
                                              } else {
                                                productOwnerCheckStates[index] =
                                                    false;
                                              }
                                            },
                                          ),
                                          SizedBox(width: 10),
                                          // productAvt
                                          Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(
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
                                            padding: EdgeInsets.symmetric(
                                                vertical: 20),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  productDetail.productName,
                                                  style: TextStyles.h5.bold,
                                                ),
                                                Text(
                                                  '${NumberFormat.currency(locale: 'vi_VN', symbol: 'vnđ').format(productDetail.price)}',
                                                  style: TextStyles
                                                      .defaultStyle.bold,
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
                ],
              )),

              SizedBox(height: 20),
              Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(kDefaultCircle14),
                    color: Colors.white),
                child: Column(
                  children: [
                    Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Tổng thanh toán'),
                            Text('0 sản phẩm'),
                          ],
                        ),
                        SizedBox(height: 15),
                        Divider(
                          color: ColorPalette.primaryColor,
                        ),
                        Row(
                          children: [
                            Text('\$50.00'),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    ButtonWidget(
                      title: 'Đặt hàng',
                      size: 22,
                      height: 70,
                    ),
                  ],
                ),
              ),
            ],
          );
  }
}
