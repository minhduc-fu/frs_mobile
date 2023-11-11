import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:frs_mobile/core/constants/color_constants.dart';
import 'package:frs_mobile/core/constants/dismension_constants.dart';
import 'package:frs_mobile/models/cart_item_model.dart';
import 'package:frs_mobile/representation/screens/cart/buy_cart_screen.dart';
import 'package:frs_mobile/representation/screens/customer/customer_main_screen.dart';
import 'package:frs_mobile/representation/widgets/button_widget.dart';
import 'package:frs_mobile/services/address_provider.dart';
import 'package:frs_mobile/services/authentication_service.dart';
import 'package:frs_mobile/services/authprovider.dart';
import 'package:frs_mobile/services/cart_provider.dart';
import 'package:frs_mobile/services/ghn_api_service.dart';
import 'package:frs_mobile/utils/asset_helper.dart';
import 'package:frs_mobile/utils/dialog_helper.dart';
import 'package:frs_mobile/utils/image_helper.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/textstyle_constants.dart';

class CheckoutForBuy extends StatefulWidget {
  const CheckoutForBuy({super.key});

  @override
  State<CheckoutForBuy> createState() => _CheckoutForBuyState();
}

class _CheckoutForBuyState extends State<CheckoutForBuy> {
  late AddressProvider _addressProvider;
  int customerID = AuthProvider.userModel!.customer!.customerID;

  String customerAddress = "";

  @override
  void initState() {
    super.initState();
    _addressProvider = Provider.of<AddressProvider>(context, listen: false);
    _loadAddresses();
  }

  void _loadAddresses() async {
    final addresses =
        await AuthenticationService.getAllAddressByCustomerID(customerID);

    if (addresses != null && addresses.isNotEmpty) {
      final addressProvider =
          Provider.of<AddressProvider>(context, listen: false);
      addressProvider.setAddresses(addresses);
      customerAddress = addresses.first.addressDescription;
      _addressProvider.notifyListeners();
      setState(() {});
    } else {
      customerAddress = '';
      setState(() {});
    }
  }

  Future<int> getProvinceID(String address) async {
    final provinces = await GHNApiService.getProvinces();

    // Giả sử địa chỉ có dạng "Tên đường, Phường/Xã, Quận/Huyện, Tỉnh/Thành phố"
    List<String> addressComponents = address.split(', ');
    String province = addressComponents.last.toLowerCase();
    for (final provinceData in provinces) {
      List<dynamic> nameExtensionsDynamic = provinceData['NameExtension'];
      List<String> nameExtensions =
          nameExtensionsDynamic.map((e) => e.toString().toLowerCase()).toList();

      if (nameExtensions.contains(province)) {
        return provinceData['ProvinceID'];
      }
    }
    throw Exception('Province not found for address: $address');
  }

  Future<int> getDistrictID(String address, int provinceID) async {
    try {
      final districts = await GHNApiService.getDistricts(provinceID);
      List<String> addressComponents = address.split(', ');
      String district =
          addressComponents[addressComponents.length - 2].toLowerCase();
      // print(district);
      for (final districtData in districts) {
        List<dynamic> nameExtensionsDynamic = districtData['NameExtension'];
        List<String> nameExtensions = nameExtensionsDynamic
            .map((e) => e.toString().toLowerCase())
            .toList();

        if (nameExtensions.contains(district)) {
          return districtData['DistrictID'];
        }
      }

      throw Exception('District not found for address: $address');
    } catch (e) {
      print('Lỗi: $e');
      throw Exception('Failed to get DistrictID');
    }
  }

  Future<String> getWardCode(String address, int districtID) async {
    try {
      final wards = await GHNApiService.getWards(districtID);
      List<String> addressComponents = address.split(', ');
      String ward =
          addressComponents[addressComponents.length - 3].toLowerCase();
      for (final wardData in wards) {
        List<dynamic> nameExtensionsDynamic = wardData['NameExtension'];
        List<String> nameExtensions = nameExtensionsDynamic
            .map((e) => e.toString().toLowerCase())
            .toList();

        if (nameExtensions.contains(ward)) {
          return wardData['WardCode'];
        }
      }

      throw Exception('District not found for address: $address');
    } catch (e) {
      print('Lỗi: $e');
      throw Exception('Failed to get DistrictID');
    }
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final selectedCartItems = cartProvider.cartItems;
    final cartItemsToDisplay = selectedCartItems.where((cartItem) => cartItem
        .productDetailModel
        .any((product) => product.isChecked == true));

    double calculateTotalCartPrice() {
      return cartItemsToDisplay.fold<double>(
          0, (total, cartItem) => total + cartItem.calculateTotalPrice());
    }

    int calculateTotalServiceFee() {
      return cartItemsToDisplay.fold<int>(
          0, (total, cartItem) => total + cartItem.serviceFee);
    }

    double calculateTotalPayment() {
      return cartItemsToDisplay.fold<double>(
        0,
        (total, cartItem) =>
            total +
            cartItem.calculateTotalPrice() + // Tổng tiền của từng sản phẩm
            cartItem.serviceFee + // Phí vận chuyển
            10000, // Phí hệ thống
      );
    }

    Future<void> fetchProvincesID() async {
      try {
        // provinces = await GHNApiService.getProvinces();
        if (customerAddress != '') {
          for (final cartItem in cartItemsToDisplay) {
            final productOwnerID = cartItem.productOwnerID;
            final productOwner =
                await AuthenticationService.getProductOwnerByID(productOwnerID);
            final productOwnerAddress = productOwner!.address;
            print('${productOwnerAddress}');
            final provinceIDProductOwner =
                await getProvinceID(productOwnerAddress);
            final provinceIDCustomer = await getProvinceID(customerAddress);
            final districtIDProductOwner = await getDistrictID(
                productOwnerAddress, provinceIDProductOwner);
            print('${districtIDProductOwner}');
            final districtIDCustomer =
                await getDistrictID(customerAddress, provinceIDCustomer);
            print('${districtIDCustomer}');
            final wardCodeCustomer =
                await getWardCode(customerAddress, districtIDCustomer);
            print('${wardCodeCustomer}');
            final service_fee = await GHNApiService.calculateShippingFee(
                fromDistrictId: districtIDProductOwner,
                toDistrictId: districtIDCustomer,
                toWardCode: wardCodeCustomer);
            if (service_fee != null) {
              cartItem.serviceFee = service_fee;
            }
          }
          // setState(() {});
        } else {
          for (final cartItem in cartItemsToDisplay) {
            cartItem.serviceFee = 0;
          }

          print('customerArress');
        }
        // setState(() {});
      } catch (e) {
        print('Lỗi: $e');
      }
    }

    return Scaffold(
        appBar: AppBar(
          backgroundColor: ColorPalette.backgroundScaffoldColor,
          leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(
              FontAwesomeIcons.angleLeft,
              size: kDefaultIconSize18,
            ),
          ),
          title: Center(
            child: Text('Thanh toán'),
          ),
        ),
        body: FutureBuilder(
            future: fetchProvincesID(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                return Column(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: ListView(
                          children: [
                            // //address
                            Row(
                              children: [
                                Icon(FontAwesomeIcons.locationDot),
                                SizedBox(width: 10),
                                Text(
                                  'Địa chỉ nhận hàng',
                                  style: TextStyles.defaultStyle
                                      .setTextSize(20)
                                      .bold,
                                ),
                              ],
                            ),
                            SizedBox(height: 10),
                            Container(
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    BorderRadius.circular(kDefaultCircle14),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(AuthProvider
                                          .userModel!.customer!.fullName),
                                      SizedBox(width: 10),
                                      Text(AuthProvider
                                          .userModel!.customer!.phone),
                                    ],
                                  ),
                                  SizedBox(height: 10),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        width: 250,
                                        child: customerAddress.isEmpty
                                            ? Text('Bạn chưa có địa chỉ')
                                            : AutoSizeText(
                                                customerAddress,
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                      ),
                                      GestureDetector(
                                        onTap: () {},
                                        child: Text(
                                          'Thay đổi',
                                          style: TextStyles.defaultStyle
                                              .setColor(Colors.blue)
                                              .bold,
                                        ),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 20),
                            Text(
                              'Sản phẩm',
                              style:
                                  TextStyles.defaultStyle.setTextSize(20).bold,
                            ),
                            SizedBox(height: 10),
                            //item
                            ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: cartItemsToDisplay.length,
                              itemBuilder: (context, index) {
                                final cartItem =
                                    cartItemsToDisplay.elementAt(index);
                                return Container(
                                  padding: EdgeInsets.all(5),
                                  margin: EdgeInsets.only(bottom: 20),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius:
                                        BorderRadius.circular(kDefaultCircle14),
                                  ),
                                  child: Column(
                                    children: [
                                      //productOwnerName
                                      Row(
                                        children: [
                                          SizedBox(width: 10),
                                          Text(
                                            cartItem.productOwnerName,
                                            style: TextStyles.h5.bold,
                                          ),
                                        ],
                                      ),
                                      Divider(
                                        thickness: 0.5,
                                        color: ColorPalette.textHide,
                                      ),
                                      Column(
                                        children: cartItem.productDetailModel
                                            .where((product) =>
                                                product.isChecked ==
                                                true) // Lọc sản phẩm có isChecked là true
                                            .map((product) {
                                          return Container(
                                            margin: EdgeInsets.only(top: 10),
                                            height: 110,
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: ColorPalette.textHide),
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      kDefaultCircle14),
                                            ),
                                            child: Row(
                                              children: [
                                                SizedBox(width: 10),
                                                ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(
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
                                                        CrossAxisAlignment
                                                            .start,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text(
                                                        product.productName,
                                                        style:
                                                            TextStyles.h5.bold,
                                                      ),
                                                      Text(
                                                        '${NumberFormat.currency(locale: 'vi_VN', symbol: 'vnđ').format(product.price)}',
                                                        style: TextStyles
                                                            .defaultStyle.bold,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        }).toList(),
                                      ),
                                      SizedBox(height: 10),
                                      Divider(
                                        thickness: 0.5,
                                        color: ColorPalette.textHide,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                ImageHelper.loadFromAsset(
                                                    AssetHelper.imageCoupon),
                                                SizedBox(width: 10),
                                                Text('Voucher của Chủ sản phẩm')
                                              ],
                                            ),
                                            GestureDetector(
                                              onTap: () {},
                                              child: Text(
                                                'Chọn Voucher',
                                                style: TextStyles.defaultStyle
                                                    .setColor(Colors.blue)
                                                    .bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Divider(
                                        thickness: 0.5,
                                        color: ColorPalette.textHide,
                                      ),
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 10),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text('Phí vận chuyển'),
                                            // Spacer(),
                                            Text(
                                              '${NumberFormat.currency(locale: 'vi_VN', symbol: 'vnđ').format(cartItem.serviceFee)}',
                                            )
                                          ],
                                        ),
                                      ),
                                      Divider(
                                        thickness: 0.5,
                                        color: ColorPalette.textHide,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              'Phí hệ thống',
                                            ),
                                            Text('10.000 vnđ'),
                                          ],
                                        ),
                                      ),
                                      Divider(
                                        thickness: 0.5,
                                        color: ColorPalette.textHide,
                                      ),
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 10),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                Text('Tổng số tiền'),
                                                Text(
                                                    ' (${cartItem.selectedProductCount} sản phẩm)')
                                              ],
                                            ),
                                            Text(
                                              '${NumberFormat.currency(locale: 'vi_VN', symbol: 'vnđ').format(cartItem.calculateTotalPrice() + cartItem.serviceFee + 10000)}',
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    // thanh toán
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Tổng tiền hàng',
                                    style: TextStyles.h5.bold,
                                  ),
                                  Text(
                                    '${NumberFormat.currency(locale: 'vi_VN', symbol: 'vnđ').format(calculateTotalCartPrice())}',
                                  ),
                                ],
                              ),
                              SizedBox(height: 10),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Tổng phí vận chuyển',
                                    style: TextStyles.h5.bold,
                                  ),
                                  Text(
                                    '${NumberFormat.currency(locale: 'vi_VN', symbol: 'vnđ').format(calculateTotalServiceFee())}',
                                  ),
                                ],
                              ),
                              Divider(
                                color: ColorPalette.primaryColor,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Tổng thanh toán',
                                    style:
                                        TextStyles.h5.bold.setColor(Colors.red),
                                  ),
                                  Text(
                                    '${NumberFormat.currency(locale: 'vi_VN', symbol: 'vnđ').format(calculateTotalPayment())}',
                                  )
                                ],
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          ButtonWidget(
                            title: 'Thanh toán',
                            size: 22,
                            height: 70,
                            onTap: () async {
                              if (customerAddress != '') {
                                final orderData = <Map<String, dynamic>>[];
                                for (final cartItem in cartItemsToDisplay) {
                                  final productOwnerID =
                                      cartItem.productOwnerID;
                                  final customerID = AuthProvider
                                      .userModel!.customer!.customerID;
                                  final shippingFee = cartItem.serviceFee;
                                  final orderDetail = <Map<String, dynamic>>[];

                                  // Duyệt qua các sản phẩm trong cartItem
                                  for (final product
                                      in cartItem.productDetailModel) {
                                    if (product.isChecked == true) {
                                      orderDetail.add({
                                        'price': product.price,
                                        'productID': product.productID,
                                      });
                                    }
                                  }

                                  if (orderDetail.isNotEmpty) {
                                    final totalBuyPriceProduct =
                                        orderDetail.fold<double>(
                                            0,
                                            (previous, element) =>
                                                previous + element['price'] ??
                                                0);
                                    final total =
                                        totalBuyPriceProduct + shippingFee;
                                    final order = {
                                      'customerAddress': customerAddress,
                                      'customerID': customerID,
                                      'orderDetail': orderDetail,
                                      'productownerID': productOwnerID,
                                      'shippingFee': shippingFee,
                                      'total': total,
                                      'totalBuyPriceProduct':
                                          totalBuyPriceProduct
                                    };
                                    orderData.add(order);
                                  }
                                }

                                final response = await AuthenticationService
                                    .createOrderBuyAndOrderBuyDetail(orderData);
                                if (response != null) {
                                  showCustomDialog(context, 'Thành công',
                                      "Bạn đã thanh toán thành công!");
                                  await Future.delayed(Duration(seconds: 5));
                                  Provider.of<CartProvider>(context,
                                          listen: false)
                                      .removeFromCartAndCheckOut();
                                  Navigator.popUntil(
                                      context,
                                      ModalRoute.withName(
                                          CustomerMainScreen.routeName));
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                          'Thanh toán thất bại, vui lòng thử lại.'),
                                    ),
                                  );
                                }
                              } else {
                                showCustomDialog(context, "Làm ơn thêm địa chỉ",
                                    'Bạn chưa có địa chỉ');
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              }
            })
        // body: Column(
        //   children: [
        //     Expanded(
        //       child: Padding(
        //         padding: const EdgeInsets.all(20),
        //         child: ListView(
        //           children: [
        //             // //address
        //             Row(
        //               children: [
        //                 Icon(FontAwesomeIcons.locationDot),
        //                 SizedBox(width: 10),
        //                 Text(
        //                   'Địa chỉ nhận hàng',
        //                   style: TextStyles.defaultStyle.setTextSize(20).bold,
        //                 ),
        //               ],
        //             ),
        //             SizedBox(height: 10),
        //             Container(
        //               padding: EdgeInsets.all(10),
        //               decoration: BoxDecoration(
        //                 color: Colors.white,
        //                 borderRadius: BorderRadius.circular(kDefaultCircle14),
        //               ),
        //               child: Column(
        //                 crossAxisAlignment: CrossAxisAlignment.start,
        //                 children: [
        //                   Row(
        //                     children: [
        //                       Text(AuthProvider.userModel!.customer!.fullName),
        //                       SizedBox(width: 10),
        //                       Text(AuthProvider.userModel!.customer!.phone),
        //                     ],
        //                   ),
        //                   SizedBox(height: 10),
        //                   Row(
        //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //                     children: [
        //                       Container(
        //                         width: 250,
        //                         child: customerAddress.isEmpty
        //                             ? Text('Bạn chưa có địa chỉ')
        //                             : AutoSizeText(
        //                                 customerAddress,
        //                                 maxLines: 2,
        //                                 overflow: TextOverflow.ellipsis,
        //                               ),
        //                       ),
        //                       GestureDetector(
        //                         onTap: () {},
        //                         child: Text(
        //                           'Thay đổi',
        //                           style: TextStyles.defaultStyle
        //                               .setColor(Colors.blue)
        //                               .bold,
        //                         ),
        //                       )
        //                     ],
        //                   ),
        //                 ],
        //               ),
        //             ),
        //             SizedBox(height: 20),
        //             Text(
        //               'Sản phẩm',
        //               style: TextStyles.defaultStyle.setTextSize(20).bold,
        //             ),
        //             SizedBox(height: 10),
        //             //item
        //             ListView.builder(
        //               shrinkWrap: true,
        //               physics: NeverScrollableScrollPhysics(),
        //               itemCount: cartItemsToDisplay.length,
        //               itemBuilder: (context, index) {
        //                 final cartItem = cartItemsToDisplay.elementAt(index);
        //                 return Container(
        //                   padding: EdgeInsets.all(5),
        //                   margin: EdgeInsets.only(bottom: 20),
        //                   decoration: BoxDecoration(
        //                     color: Colors.white,
        //                     borderRadius: BorderRadius.circular(kDefaultCircle14),
        //                   ),
        //                   child: Column(
        //                     children: [
        //                       //productOwnerName
        //                       Row(
        //                         children: [
        //                           SizedBox(width: 10),
        //                           Text(
        //                             cartItem.productOwnerName,
        //                             style: TextStyles.h5.bold,
        //                           ),
        //                         ],
        //                       ),
        //                       Divider(
        //                         thickness: 0.5,
        //                         color: ColorPalette.textHide,
        //                       ),
        //                       Column(
        //                         children: cartItem.productDetailModel
        //                             .where((product) =>
        //                                 product.isChecked ==
        //                                 true) // Lọc sản phẩm có isChecked là true
        //                             .map((product) {
        //                           return Container(
        //                             margin: EdgeInsets.only(top: 10),
        //                             height: 110,
        //                             decoration: BoxDecoration(
        //                               border: Border.all(
        //                                   color: ColorPalette.textHide),
        //                               borderRadius:
        //                                   BorderRadius.circular(kDefaultCircle14),
        //                             ),
        //                             child: Row(
        //                               children: [
        //                                 SizedBox(width: 10),
        //                                 ClipRRect(
        //                                   borderRadius: BorderRadius.circular(
        //                                       kDefaultCircle14),
        //                                   child: Image.network(
        //                                     cacheHeight: 80,
        //                                     cacheWidth: 80,
        //                                     product.productAvt!,
        //                                     fit: BoxFit.cover,
        //                                   ),
        //                                 ),
        //                                 SizedBox(width: 10),
        //                                 // productName, price
        //                                 Padding(
        //                                   padding:
        //                                       EdgeInsets.symmetric(vertical: 20),
        //                                   child: Column(
        //                                     crossAxisAlignment:
        //                                         CrossAxisAlignment.start,
        //                                     mainAxisAlignment:
        //                                         MainAxisAlignment.spaceBetween,
        //                                     children: [
        //                                       Text(
        //                                         product.productName,
        //                                         style: TextStyles.h5.bold,
        //                                       ),
        //                                       Text(
        //                                         '${NumberFormat.currency(locale: 'vi_VN', symbol: 'vnđ').format(product.price)}',
        //                                         style:
        //                                             TextStyles.defaultStyle.bold,
        //                                       ),
        //                                     ],
        //                                   ),
        //                                 ),
        //                               ],
        //                             ),
        //                           );
        //                         }).toList(),
        //                       ),
        //                       SizedBox(height: 10),
        //                       Divider(
        //                         thickness: 0.5,
        //                         color: ColorPalette.textHide,
        //                       ),
        //                       Padding(
        //                         padding:
        //                             const EdgeInsets.symmetric(horizontal: 10),
        //                         child: Row(
        //                           mainAxisAlignment:
        //                               MainAxisAlignment.spaceBetween,
        //                           children: [
        //                             Row(
        //                               children: [
        //                                 ImageHelper.loadFromAsset(
        //                                     AssetHelper.imageCoupon),
        //                                 SizedBox(width: 10),
        //                                 Text('Voucher của Chủ sản phẩm')
        //                               ],
        //                             ),
        //                             GestureDetector(
        //                               onTap: () {},
        //                               child: Text(
        //                                 'Chọn Voucher',
        //                                 style: TextStyles.defaultStyle
        //                                     .setColor(Colors.blue)
        //                                     .bold,
        //                               ),
        //                             ),
        //                           ],
        //                         ),
        //                       ),
        //                       Divider(
        //                         thickness: 0.5,
        //                         color: ColorPalette.textHide,
        //                       ),
        //                       Padding(
        //                         padding: EdgeInsets.symmetric(horizontal: 10),
        //                         child: Row(
        //                           mainAxisAlignment:
        //                               MainAxisAlignment.spaceBetween,
        //                           children: [
        //                             Text('Phí vận chuyển'),
        //                             // Spacer(),
        //                             Container(
        //                               width: 70,
        //                               child: FutureBuilder(
        //                                 future: fetchProvincesID(),
        //                                 builder: (context, snapshot) {
        //                                   if (snapshot.connectionState ==
        //                                       ConnectionState.waiting) {
        //                                     return CircularProgressIndicator();
        //                                   } else if (snapshot.hasError) {
        //                                     return Text(
        //                                         'Error: ${snapshot.error}');
        //                                   } else {
        //                                     return Text(
        //                                       '${cartItem.serviceFee} vnđ',
        //                                     );
        //                                   }
        //                                 },
        //                               ),
        //                             )
        //                           ],
        //                         ),
        //                       ),
        //                       Divider(
        //                         thickness: 0.5,
        //                         color: ColorPalette.textHide,
        //                       ),
        //                       Padding(
        //                         padding: EdgeInsets.symmetric(horizontal: 10),
        //                         child: Row(
        //                           mainAxisAlignment:
        //                               MainAxisAlignment.spaceBetween,
        //                           children: [
        //                             Row(
        //                               children: [
        //                                 Text('Tổng số tiền'),
        //                                 Text(
        //                                     ' (${cartItem.selectedProductCount} sản phẩm)')
        //                               ],
        //                             ),
        //                             Text(
        //                               '${NumberFormat.currency(locale: 'vi_VN', symbol: 'vnđ').format(cartItem.calculateTotalPrice() + cartItem.serviceFee)}',
        //                             ),
        //                           ],
        //                         ),
        //                       )
        //                     ],
        //                   ),
        //                 );
        //               },
        //             ),
        //           ],
        //         ),
        //       ),
        //     ),
        //     SizedBox(height: 20),
        //     // thanh toán
        //     Container(
        //       padding: EdgeInsets.all(10),
        //       decoration: BoxDecoration(
        //           borderRadius: BorderRadius.circular(kDefaultCircle14),
        //           color: Colors.white),
        //       child: Column(
        //         children: [
        //           Column(
        //             children: [
        //               Row(
        //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //                 children: [
        //                   Text(
        //                     'Tổng tiền hàng',
        //                     style: TextStyles.h5.bold,
        //                   ),
        //                   Text(
        //                     '${NumberFormat.currency(locale: 'vi_VN', symbol: 'vnđ').format(calculateTotalCartPrice())}',
        //                   ),
        //                 ],
        //               ),
        //               SizedBox(height: 10),
        //               Row(
        //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //                 children: [
        //                   Text(
        //                     'Tổng phí vận chuyển',
        //                     style: TextStyles.h5.bold,
        //                   ),
        //                   Text('Tổng phí vận chuyển 0vnd'),
        //                 ],
        //               ),
        //               SizedBox(height: 10),
        //               Row(
        //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //                 children: [
        //                   Text(
        //                     'Phí hệ thống',
        //                     style: TextStyles.h5.bold,
        //                   ),
        //                   Text('10.000 vnđ'),
        //                 ],
        //               ),
        //               Divider(
        //                 color: ColorPalette.primaryColor,
        //               ),
        //               Row(
        //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //                 children: [
        //                   Text(
        //                     'Tổng thanh toán',
        //                     // '${NumberFormat.currency(locale: 'vi_VN', symbol: 'vnđ').format(totalAmount)}',
        //                     style: TextStyles.h5.bold.setColor(Colors.red),
        //                   ),
        //                   Text('Tổng thanh toán 0vnd')
        //                 ],
        //               ),
        //             ],
        //           ),
        //           SizedBox(height: 10),
        //           ButtonWidget(
        //             title: 'Thanh toán',
        //             size: 22,
        //             height: 70,
        //             onTap: () async {
        //               final orderData = <Map<String, dynamic>>[];
        //               for (final cartItem in cartItemsToDisplay) {
        //                 final productOwnerID = cartItem.productOwnerID;
        //                 final customerID =
        //                     AuthProvider.userModel!.customer!.customerID;
        //                 final shippingFee = cartItem.serviceFee;
        //                 final orderDetail = <Map<String, dynamic>>[];
        //                 // Duyệt qua các sản phẩm trong cartItem
        //                 for (final product in cartItem.productDetailModel) {
        //                   if (product.isChecked == true) {
        //                     orderDetail.add({
        //                       'price': product.price,
        //                       'productID': product.productID,
        //                     });
        //                   }
        //                 }
        //                 if (orderDetail.isNotEmpty) {
        //                   final totalBuyPriceProduct = orderDetail.fold<double>(
        //                       0,
        //                       (previous, element) =>
        //                           previous + element['price'] ?? 0);
        //                   final total = totalBuyPriceProduct + shippingFee;
        //                   final order = {
        //                     'customerAddress': customerAddress,
        //                     'customerID': customerID,
        //                     'orderDetail': orderDetail,
        //                     'productownerID': productOwnerID,
        //                     'shippingFee': shippingFee,
        //                     'total': total,
        //                     'totalBuyPriceProduct': totalBuyPriceProduct
        //                   };
        //                   orderData.add(order);
        //                 }
        //               }
        //               final response = await AuthenticationService
        //                   .createOrderBuyAndOrderBuyDetail(orderData);
        //               if (response != null) {
        //                 showCustomDialog(context, 'Thành công',
        //                     "Bạn đã thanh toán thành công!");
        //                 await Future.delayed(Duration(seconds: 5));
        //                 Provider.of<CartProvider>(context, listen: false)
        //                     .removeFromCartAndCheckOut();
        //                 Navigator.popUntil(context,
        //                     ModalRoute.withName(CustomerMainScreen.routeName));
        //               } else {
        //                 ScaffoldMessenger.of(context).showSnackBar(
        //                   SnackBar(
        //                     content:
        //                         Text('Thanh toán thất bại, vui lòng thử lại.'),
        //                   ),
        //                 );
        //               }
        //             },
        //           ),
        //         ],
        //       ),
        //     ),
        //   ],
        // ),
        );
  }
}
