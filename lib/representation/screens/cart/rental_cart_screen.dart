import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:frs_mobile/core/constants/color_constants.dart';
import 'package:frs_mobile/core/constants/dismension_constants.dart';
import 'package:frs_mobile/core/constants/textstyle_constants.dart';
import 'package:frs_mobile/models/productOwner_model.dart';
import 'package:frs_mobile/models/rental_cart_item_model.dart';
import 'package:frs_mobile/representation/screens/checkout/checkout_for_rent.dart';
import 'package:frs_mobile/representation/screens/productowner_screen/productOwner_shop_screen.dart';
import 'package:frs_mobile/representation/screens/wallet/wallet_screen.dart';
import 'package:frs_mobile/representation/widgets/button_widget.dart';
import 'package:frs_mobile/services/authentication_service.dart';
import 'package:frs_mobile/services/authprovider.dart';
import 'package:frs_mobile/services/rental_cart_provider.dart';
import 'package:frs_mobile/utils/dialog_helper.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class RentalCartScreen extends StatefulWidget {
  const RentalCartScreen({super.key});

  @override
  State<RentalCartScreen> createState() => _RentalCartScreenState();
}

class _RentalCartScreenState extends State<RentalCartScreen> {
  List<RentalCartItemModel> rentalCartItems = [];
  int totalSelectedProducts = 0;
  double totalAmount = 0.0;

  void placeOrder() async {
    final rentalCartProvider =
        Provider.of<RentalCartProvider>(context, listen: false);
    final accountID = AuthProvider.userModel!.accountID;
    final wallet = await AuthenticationService.getWalletByAccountID(accountID);
    if (rentalCartProvider.areSelectedProductsSameDate()) {
      if (wallet != null && wallet.balance >= totalAmount) {
        Navigator.of(context).push(
            CupertinoPageRoute(builder: ((context) => CheckoutForRent())));
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
                    Navigator.pop(context);
                    Navigator.of(context).pushNamed(WalletScreen.routeName);
                  },
                ),
              ],
            );
          },
        );
      }
    } else {
      showCustomDialog(
          context,
          'Lỗi',
          "Vui lòng chọn những sản phẩm có cùng Ngày bắt đầu và Ngày kết thúc",
          true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final rentalCartProvider = Provider.of<RentalCartProvider>(context);
    rentalCartItems = rentalCartProvider.rentalCartItems;

    totalSelectedProducts = 0;
    totalAmount = 0.0;
    for (var rentalCartItem in rentalCartItems) {
      for (var product in rentalCartItem.productDetailModel) {
        if (product.isChecked == true) {
          totalSelectedProducts++;
          totalAmount += product.price + product.selectedRentPrice!;
        }
      }
    }

    return rentalCartItems.isEmpty
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
                  "Giỏ hàng Thuê của bạn chưa có sản phẩm!",
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
                            value: rentalCartItems.every((rentalCartItemAll) =>
                                rentalCartItemAll.productDetailModel.every(
                                    (product) =>
                                        product.isChecked != null &&
                                        product.isChecked)),
                            onChanged: (value) {
                              rentalCartItems.forEach((rentalCartItemAll) {
                                rentalCartItemAll.productDetailModel
                                    .forEach((product) {
                                  product.isChecked = value!;
                                });
                              });
                              rentalCartProvider.notifyListeners();
                            },
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            rentalCartProvider.clearCart();
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
                    itemCount: rentalCartItems.length,
                    itemBuilder: (context, index) {
                      final rentalCartItem = rentalCartItems[index];
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
                                      value: rentalCartItem.productDetailModel
                                          .every((product) =>
                                              product.isChecked != null &&
                                              product.isChecked),
                                      onChanged: (value) {
                                        rentalCartItem.productDetailModel
                                            .forEach((product) {
                                          product.isChecked = value!;
                                        });
                                        rentalCartProvider.notifyListeners();
                                      },
                                    ),
                                    SizedBox(width: 10),
                                    Text(
                                      rentalCartItem.productOwnerName,
                                      style: TextStyles.h5.bold,
                                    ),
                                  ],
                                ),
                                InkWell(
                                  onTap: () async {
                                    ProductOwnerModel? productOwnerModel =
                                        await AuthenticationService
                                            .getProductOwnerByID(
                                                rentalCartItem.productOwnerID);
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
                              children: rentalCartItem.productDetailModel
                                  .map((product) {
                                return Container(
                                  margin: EdgeInsets.only(top: 10),
                                  height: 140,
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
                                              rentalCartProvider
                                                  .notifyListeners();
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
                                                  MainAxisAlignment.spaceAround,
                                              children: [
                                                Container(
                                                  width: 165,
                                                  child: AutoSizeText(
                                                    product.productName,
                                                    minFontSize: 16,
                                                    style: TextStyles.h5.bold,
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                                Text(
                                                  (product.startDate != null &&
                                                          product.endDate !=
                                                              null)
                                                      ? '${DateFormat('dd/MM/yyyy').format(product.startDate!)} - ${DateFormat('dd/MM/yyyy').format(product.endDate!)}'
                                                      : 'N/A',
                                                ),
                                                AutoSizeText.rich(
                                                  minFontSize: 14,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  maxLines: 1,
                                                  TextSpan(
                                                    children: [
                                                      TextSpan(
                                                        text: 'Cọc: ',
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
                                                AutoSizeText.rich(
                                                  minFontSize: 14,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  maxLines: 1,
                                                  TextSpan(
                                                    children: [
                                                      TextSpan(
                                                        text: 'Thuê: ',
                                                      ),
                                                      TextSpan(
                                                        text:
                                                            '${NumberFormat.currency(locale: 'vi_VN', symbol: 'vnđ').format(product.selectedRentPrice)}',
                                                        style: TextStyles
                                                            .defaultStyle.bold
                                                            .setColor(
                                                                Colors.red),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(right: 10),
                                        child: GestureDetector(
                                          onTap: () {
                                            rentalCartProvider
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
                                  "Vui lòng chọn sản phẩm!", true);
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
