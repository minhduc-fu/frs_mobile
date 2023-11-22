import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:frs_mobile/models/cart_item_model.dart';
import 'package:frs_mobile/models/productOwner_model.dart';
import 'package:frs_mobile/representation/screens/checkout/checkout_for_buy.dart';
import 'package:frs_mobile/representation/screens/productowner_screen/productOwner_shop_screen.dart';
import 'package:frs_mobile/representation/screens/wallet/wallet_screen.dart';
import 'package:frs_mobile/utils/dialog_helper.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:auto_size_text/auto_size_text.dart';
import '../../../core/constants/color_constants.dart';
import '../../../core/constants/dismension_constants.dart';
import '../../../core/constants/textstyle_constants.dart';
import '../../../services/authentication_service.dart';
import '../../../services/authprovider.dart';
import '../../../services/cart_provider.dart';
import '../../widgets/button_widget.dart';

class BuyCartScreen extends StatefulWidget {
  const BuyCartScreen({super.key});
  static const String routeName = '/buy_cart_screen';

  @override
  State<BuyCartScreen> createState() => _BuyCartScreenState();
}

class _BuyCartScreenState extends State<BuyCartScreen> {
  double totalAmount = 0.0;
  int totalSelectedProducts = 0;
  List<CartItemModel> cartItems = [];

  void placeOrder() async {
    final accountID = AuthProvider.userModel!.accountID;
    final wallet = await AuthenticationService.getWalletByAccountID(accountID);

    if (wallet != null && wallet.balance >= totalAmount) {
      Navigator.of(context)
          .push(CupertinoPageRoute(builder: ((context) => CheckoutForBuy())));
    } else {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              'Số dư của ví không đủ',
              style: TextStyles.h4.bold,
            ),
            content: Container(
              height: 50,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Số dư hiện tại của ví: ${NumberFormat.currency(locale: 'vi_VN', symbol: 'vnđ').format(wallet!.balance)}',
                    style: TextStyles.h5,
                  ),
                  Text(
                    'Bạn cần nạp thêm: ${NumberFormat.currency(locale: 'vi_VN', symbol: 'vnđ').format(totalAmount - wallet.balance)}',
                    style: TextStyles.h5,
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  'Hủy',
                  style: TextStyles.defaultStyle.bold
                      .setColor(Colors.red)
                      .setTextSize(18),
                ),
              ),
              ButtonWidget(
                title: "Nạp tiền vào ví",
                size: 18,
                height: 40,
                width: 160,
                onTap: () {
                  // Navigator.of(context).push(CupertinoPageRoute(
                  //     builder: ((context) => WalletScreen())));
                  Navigator.pop(context);
                  Navigator.of(context).pushNamed(WalletScreen.routeName);
                },
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    cartItems = cartProvider.cartItems;

    totalSelectedProducts = 0;
    totalAmount = 0.0;
    for (var cartItem in cartItems) {
      for (var product in cartItem.productDetailModel) {
        if (product.isChecked == true) {
          totalSelectedProducts++;
          totalAmount += product.price;
        }
      }
    }

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
              Expanded(
                  child: ListView(
                children: [
                  // allProduct
                  Container(
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(kDefaultCircle14),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: 250,
                          child: CheckboxListTile(
                            controlAffinity: ListTileControlAffinity.leading,
                            title: Text(
                              'Tất cả sản phẩm',
                              style: TextStyles.h5.bold,
                            ),
                            value: cartItems.every((cartItem) =>
                                cartItem.productDetailModel.every((product) =>
                                    product.isChecked != null &&
                                    product.isChecked)),
                            onChanged: (value) {
                              cartItems.forEach((cartItem) {
                                cartItem.productDetailModel.forEach((product) {
                                  product.isChecked = value!;
                                });
                              });
                              cartProvider.notifyListeners();
                            },
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            cartProvider.clearCart();
                          },
                          child: Container(
                              margin: EdgeInsets.only(right: 5),
                              child: Icon(FontAwesomeIcons.trashCan)),
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
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
                          children: [
                            //productOwner
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Checkbox(
                                      value: cartItem.productDetailModel.every(
                                          (product) =>
                                              product.isChecked != null &&
                                              product.isChecked),
                                      onChanged: (value) {
                                        cartItem.productDetailModel
                                            .forEach((product) {
                                          product.isChecked = value!;
                                        });
                                        cartProvider.notifyListeners();
                                      },
                                    ),
                                    SizedBox(width: 10),
                                    Text(
                                      cartItem.productOwnerName,
                                      style: TextStyles.h5.bold,
                                    ),
                                  ],
                                ),
                                InkWell(
                                  onTap: () async {
                                    ProductOwnerModel? productOwnerModel =
                                        await AuthenticationService
                                            .getProductOwnerByID(
                                                cartItem.productOwnerID);
                                    Navigator.push(
                                      context,
                                      CupertinoPageRoute(
                                        builder: (context) =>
                                            ProductOwnerShopScreen(
                                          productOwnerModel: productOwnerModel,
                                        ),
                                      ),
                                    );
                                  },
                                  child: Icon(FontAwesomeIcons.angleRight),
                                ),
                              ],
                            ),
                            Divider(
                              thickness: 0.5,
                              color: ColorPalette.textHide,
                            ),
                            Column(
                              children:
                                  cartItem.productDetailModel.map((product) {
                                return Container(
                                  margin: EdgeInsets.only(top: 10),
                                  height: 110,
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
                                      //checkbox, info product
                                      Row(
                                        children: [
                                          Checkbox(
                                            value: product.isChecked ?? false,
                                            onChanged: (value) {
                                              product.isChecked = value!;
                                              cartProvider.notifyListeners();
                                            },
                                          ),
                                          ClipRRect(
                                            borderRadius: BorderRadius.circular(
                                                kDefaultCircle14),
                                            child: Image.network(
                                              cacheHeight: 80,
                                              cacheWidth: 80,
                                              product.productAvt!,
                                              fit: BoxFit.cover,
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
                                                Container(
                                                  width: 180,
                                                  child: AutoSizeText(
                                                    product.productName,
                                                    style: TextStyles.h5.bold,
                                                    minFontSize: 16,
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                                AutoSizeText.rich(
                                                  minFontSize: 14,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  maxLines: 1,
                                                  TextSpan(
                                                    children: [
                                                      TextSpan(
                                                        text: 'Mua: ',
                                                      ),
                                                      TextSpan(
                                                        text:
                                                            '${NumberFormat.currency(locale: 'vi_VN', symbol: 'vnđ').format(product.price)}',
                                                        style: TextStyles
                                                            .defaultStyle.bold
                                                            .setColor(
                                                                Colors.red),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          // SizedBox(width: 10),
                                        ],
                                      ),
                                      // xóa nè
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(right: 10),
                                        child: GestureDetector(
                                          onTap: () {
                                            cartProvider
                                                .removeProductFromCart(product);
                                          },
                                          child:
                                              Icon(FontAwesomeIcons.trashCan),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),
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
                            Text(
                              'Tổng thanh toán',
                              style: TextStyles.h5.bold,
                            ),
                            Text(
                              '$totalSelectedProducts sản phẩm',
                              style: TextStyles.h5.bold,
                            ),
                          ],
                        ),
                        SizedBox(height: 15),
                        Divider(
                          color: ColorPalette.primaryColor,
                        ),
                        Row(
                          children: [
                            // tổng số tiền của các product mà Customer chọn
                            Text(
                              '${NumberFormat.currency(locale: 'vi_VN', symbol: 'vnđ').format(totalAmount)}',
                              style: TextStyles.h5.bold.setColor(Colors.red),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    ButtonWidget(
                      title: 'Đặt hàng',
                      size: 22,
                      height: 70,
                      onTap: () {
                        final userModel = AuthProvider.userModel;
                        if (userModel != null) {
                          if (AuthProvider.userModel!.status == "VERIFIED") {
                            if (totalSelectedProducts > 0) {
                              placeOrder();
                            } else {
                              showCustomDialog(context, "Lỗi",
                                  "Làm ơn hãy chọn sản phẩm!", true);
                            }
                          } else {
                            showCustomDialog(context, "Lỗi",
                                "Hãy cập nhật thông tin cá nhân", true);
                          }
                        } else {
                          showCustomDialog(
                              context,
                              "Lỗi",
                              "Hãy 'Đăng nhập' vào hệ thống để 'Đặt hàng'",
                              true);
                        }
                      },
                    ),
                  ],
                ),
              ),
            ],
          );
  }
}
