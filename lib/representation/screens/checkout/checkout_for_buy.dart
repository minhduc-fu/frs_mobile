import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:frs_mobile/core/constants/color_constants.dart';
import 'package:frs_mobile/core/constants/dismension_constants.dart';
import 'package:frs_mobile/models/cart_item_model.dart';
import 'package:frs_mobile/models/voucher_model.dart';
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
import 'selectAdress.dart';

class CheckoutForBuy extends StatefulWidget {
  const CheckoutForBuy({super.key});

  @override
  State<CheckoutForBuy> createState() => _CheckoutForBuyState();
}

class _CheckoutForBuyState extends State<CheckoutForBuy> {
  late AddressProvider _addressProvider;
  int customerID = AuthProvider.userModel!.customer!.customerID;
  VoucherModel? selectedVoucher;
  String customerAddress = "";
  bool isVoucher = false;

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
      if (addressProvider.selectedAddress != null) {
        customerAddress = addressProvider.selectedAddress!.addressDescription;
      } else {
        customerAddress = addresses.first.addressDescription;
      }
      _addressProvider.notifyListeners();
      setState(() {});
    } else {
      customerAddress = '';
      setState(() {});
    }
  }

  void _openSelectAddressScreen() async {
    await Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (context) => SelectAddressScreen(),
      ),
    );
    if (_addressProvider.selectedAddress!.addressDescription.isNotEmpty) {
      setState(() {
        customerAddress = _addressProvider.selectedAddress!.addressDescription;
      });
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
      final districtsTrue = districts
          .where((district) =>
              district['NameExtension'] != null &&
              district['NameExtension'].isNotEmpty)
          .toList();
      List<String> addressComponents = address.split(', ');
      String district =
          addressComponents[addressComponents.length - 2].toLowerCase();
      for (final districtData in districtsTrue) {
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
      final wardsTrue = wards
          .where((ward) =>
              ward['NameExtension'] != null && ward['NameExtension'].isNotEmpty)
          .toList();
      List<String> addressComponents = address.split(', ');
      String ward =
          addressComponents[addressComponents.length - 3].toLowerCase();
      for (final wardData in wardsTrue) {
        List<dynamic> nameExtensionsDynamic = wardData['NameExtension'];
        List<String> nameExtensions = nameExtensionsDynamic
            .map((e) => e.toString().toLowerCase())
            .toList();

        if (nameExtensions.contains(ward)) {
          return wardData['WardCode'];
        }
      }

      throw Exception('WardCode not found for address: $address');
    } catch (e) {
      print('Lỗi: $e');
      throw Exception('Failed to get DistrictID');
    }
  }

  Future<void> _openSelectVoucherScreen(
      int productOwnerID, CartItemModel cartItemModel) async {
    final vouchers =
        await AuthenticationService.getVoucherByProrductOwnerIDNotExpired(
            productOwnerID);
    bool isVoucherAvailable(VoucherModel voucher) {
      DateTime currentDate = DateTime.now();
      DateTime startDate = voucher.startDate;
      return currentDate.isAfter(startDate) ||
          currentDate.isAtSameMomentAs(startDate);
    }

    final buyVouchers =
        vouchers.where((voucher) => voucher.voucherTypeID == 1).toList();
    if (buyVouchers.isNotEmpty) {
      await showModalBottomSheet(
        isScrollControlled: true, // Đặt thành true để bottom sheet có thể cuộn
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(kDefaultCircle14)),
        backgroundColor: ColorPalette.backgroundScaffoldColor,
        context: context,
        builder: (BuildContext context) {
          return Container(
            height: 350,
            child: StatefulBuilder(
              builder: (context, setState) {
                return Column(
                  children: [
                    SizedBox(height: 20),
                    Center(
                      child: Container(
                        decoration: BoxDecoration(
                            color: ColorPalette.primaryColor,
                            borderRadius:
                                BorderRadius.circular(kDefaultCircle14)),
                        height: 7,
                        width: 50,
                      ),
                    ),
                    SizedBox(height: 10),
                    Expanded(
                      child: ListView.builder(
                        itemCount: buyVouchers.length,
                        shrinkWrap: true,
                        itemBuilder: (BuildContext context, int index) {
                          var voucher = buyVouchers[index];
                          return Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Container(
                              padding: EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                color: isVoucherAvailable(voucher) == true
                                    ? Colors.white
                                    : ColorPalette.backgroundScaffoldColor,
                                borderRadius: BorderRadius.circular(18),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Radio<VoucherModel>(
                                        materialTapTargetSize:
                                            MaterialTapTargetSize.shrinkWrap,
                                        toggleable: true,
                                        value: voucher,
                                        groupValue: selectedVoucher,
                                        onChanged: (VoucherModel? value) {
                                          if (isVoucherAvailable(voucher))
                                            setState(() {
                                              selectedVoucher = value;
                                            });
                                        },
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            voucher.voucherCode,
                                            style: TextStyles.h5.bold,
                                          ),
                                          Container(
                                            width: 230,
                                            child: AutoSizeText(
                                              minFontSize: 14,
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              'Giảm tối đa ${NumberFormat.currency(locale: 'vi_VN', symbol: 'vnđ').format(voucher.maxDiscount)} trên đơn',
                                            ),
                                          ),
                                          Text(
                                            'Số lượng: ${voucher.quantity}',
                                          ),
                                          Text(
                                            'HSD: ${DateFormat('dd/MM/yyyy').format(voucher.startDate)} - ${DateFormat('dd/MM/yyyy').format(voucher.endDate)}',
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                  Container(
                                    height: 100,
                                    decoration: BoxDecoration(
                                      border: Border(
                                          left: BorderSide(
                                              color: ColorPalette.textHide
                                                  .withOpacity(0.2),
                                              width: 1)),
                                    ),
                                    child: Center(
                                      child: Text(
                                        ' Giảm ${voucher.discountAmount}%',
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        if (selectedVoucher != null) {
                          final discountAmount =
                              selectedVoucher!.discountAmount / 100;
                          double voucherDiscount =
                              cartItemModel.calculateTotalPrice() *
                                  discountAmount;
                          final maxDiscount =
                              selectedVoucher!.maxDiscount.toDouble();
                          if (voucherDiscount > maxDiscount) {
                            voucherDiscount = maxDiscount;
                          }
                          setState(() {
                            cartItemModel.voucherDiscount = voucherDiscount;
                            cartItemModel.slectedDiscountText =
                                'Giảm ${selectedVoucher!.discountAmount}%';
                            cartItemModel.voucherCode =
                                selectedVoucher!.voucherCode;
                            cartItemModel.voucherID =
                                selectedVoucher!.voucherID;
                          });
                        }
                        Navigator.pop(context);
                      },
                      child: Container(
                        color: ColorPalette.primaryColor,
                        height: 70,
                        child: Center(
                          child: Text(
                            'Đồng ý',
                            style: TextStyles.h5.bold.whiteTextColor,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          );
        },
      );
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Thông báo'),
            content: Text('Không có voucher.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('OK'),
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
    final selectedCartItems = cartProvider.cartItems;
    final cartItemsToDisplay = selectedCartItems.where((cartItem) => cartItem
        .productDetailModel
        .any((product) => product.isChecked == true));

    for (var cartItem in cartItemsToDisplay) {
      if (cartItem.voucherDiscount != 0) {
        setState(() {
          isVoucher = true;
        });
      }
    }

    double calculateTotalCartPrice() {
      return cartItemsToDisplay.fold<double>(
          0, (total, cartItem) => total + cartItem.calculateTotalPrice());
    }

    int calculateTotalServiceFee() {
      return cartItemsToDisplay.fold<int>(
          0, (total, cartItem) => total + cartItem.serviceFee);
    }

    double calculateTotalVoucher() {
      return cartItemsToDisplay.fold<double>(
          0, (total, cartItem) => total + cartItem.voucherDiscount);
    }

    double calculateTotalPayment() {
      return cartItemsToDisplay.fold<double>(
        0,
        (total, cartItem) =>
            total +
            (cartItem.calculateTotalPrice() -
                cartItem.voucherDiscount) + // Tổng tiền của từng sản phẩm
            cartItem.serviceFee + // Phí vận chuyển
            10000, // Phí hệ thống
      );
    }

    Future<void> fetchServiceFee() async {
      try {
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
              Provider.of<AddressProvider>(context, listen: false)
                  .clearSelectedAddress();
              setState(() {
                for (final cartItem in cartItemsToDisplay) {
                  cartItem.serviceFee = 0;
                  cartItem.voucherDiscount = 0;
                  cartItem.slectedDiscountText = 'Chọn voucher';
                }
              });
              Navigator.pop(context);
            },
            child: Icon(
              FontAwesomeIcons.angleLeft,
            ),
          ),
          centerTitle: true,
          title: Text(
            'Thanh toán',
            style: TextStyles.defaultStyle.bold.setTextSize(19),
          ),
        ),
        body: FutureBuilder(
          future: fetchServiceFee(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              return Column(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: ListView(
                        children: [
                          // //address
                          Text(
                            'Thông tin nhận hàng',
                            style: TextStyles.defaultStyle.setTextSize(20).bold,
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
                                    Icon(
                                      FontAwesomeIcons.solidUser,
                                      size: 14,
                                    ),
                                    SizedBox(width: 10),
                                    Text(AuthProvider
                                        .userModel!.customer!.fullName),
                                  ],
                                ),
                                SizedBox(height: 10),
                                Row(
                                  children: [
                                    Icon(
                                      FontAwesomeIcons.phone,
                                      size: 14,
                                    ),
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
                                    Row(
                                      children: [
                                        Icon(
                                          FontAwesomeIcons.locationDot,
                                          size: 14,
                                        ),
                                        SizedBox(width: 10),
                                        Container(
                                          width: 250,
                                          child: customerAddress.isEmpty
                                              ? Text('Bạn chưa có địa chỉ')
                                              : AutoSizeText(
                                                  customerAddress,
                                                  maxLines: 2,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                        ),
                                      ],
                                    ),
                                    GestureDetector(
                                      onTap: _openSelectAddressScreen,
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
                            style: TextStyles.defaultStyle.setTextSize(20).bold,
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
                                    SizedBox(height: 10),
                                    Row(
                                      children: [
                                        SizedBox(width: 10),
                                        Icon(
                                          FontAwesomeIcons.locationDot,
                                          size: 14,
                                        ),
                                        SizedBox(width: 10),
                                        Container(
                                          width: 320,
                                          child: AutoSizeText(
                                            cartItem.productOwnerAddress,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
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
                                            borderRadius: BorderRadius.circular(
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
                                                      width: 230,
                                                      child: AutoSizeText(
                                                        product.productName,
                                                        minFontSize: 16,
                                                        style:
                                                            TextStyles.h5.bold,
                                                        maxLines: 1,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                    ),
                                                    Container(
                                                      width: 230,
                                                      child: AutoSizeText.rich(
                                                        minFontSize: 14,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        maxLines: 2,
                                                        TextSpan(
                                                          children: [
                                                            TextSpan(
                                                              text: 'Mua: ',
                                                            ),
                                                            TextSpan(
                                                                text:
                                                                    '${NumberFormat.currency(locale: 'vi_VN', symbol: 'vnđ').format(product.price)}',
                                                                style: TextStyles
                                                                    .defaultStyle
                                                                    .bold
                                                                    .setColor(
                                                                        Colors
                                                                            .red)),
                                                            // if (cartItem
                                                            //         .voucherDiscount !=
                                                            //     0)
                                                            //   TextSpan(
                                                            //     text:
                                                            //         '\n${NumberFormat.currency(locale: 'vi_VN', symbol: 'vnđ').format(product.price - cartItem.voucherDiscount)}',
                                                            //     style: TextStyles
                                                            //         .defaultStyle
                                                            //         .bold
                                                            //         .setColor(
                                                            //             Colors
                                                            //                 .red),
                                                            //   ),
                                                          ],
                                                        ),
                                                      ),
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
                                            onTap: () async {
                                              await _openSelectVoucherScreen(
                                                  cartItem.productOwnerID,
                                                  cartItem);
                                              setState(() {});
                                            },
                                            child: Text(
                                              cartItem.slectedDiscountText,
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
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 10),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text('Tiền mua'),
                                          Column(
                                            children: [
                                              cartItem.voucherDiscount == 0
                                                  ? Text(
                                                      '${NumberFormat.currency(locale: 'vi_VN', symbol: 'vnđ').format(cartItem.calculateTotalPrice())}',
                                                    )
                                                  : Column(
                                                      children: [
                                                        Text(
                                                          '${NumberFormat.currency(locale: 'vi_VN', symbol: 'vnđ').format(cartItem.calculateTotalPrice())}',
                                                          style: TextStyle(
                                                            decoration:
                                                                TextDecoration
                                                                    .lineThrough,
                                                          ),
                                                        ),
                                                        Text(
                                                          '${NumberFormat.currency(locale: 'vi_VN', symbol: 'vnđ').format(cartItem.calculateTotalPrice() - cartItem.voucherDiscount)}',
                                                        ),
                                                      ],
                                                    ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    Divider(
                                      thickness: 0.5,
                                      color: ColorPalette.textHide,
                                    ),
                                    Padding(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 10),
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
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 10),
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
                                            '${NumberFormat.currency(locale: 'vi_VN', symbol: 'vnđ').format(cartItem.calculateTotalPrice() - cartItem.voucherDiscount + cartItem.serviceFee + 10000)}',
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                            if (isVoucher == true)
                              Column(
                                children: [
                                  SizedBox(height: 10),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Tổng Voucher giảm giá',
                                        style: TextStyles.h5.bold,
                                      ),
                                      Text(
                                        '- ${NumberFormat.currency(locale: 'vi_VN', symbol: 'vnđ').format(calculateTotalVoucher())}',
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            Divider(
                              color: ColorPalette.primaryColor,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Tổng thanh toán',
                                  style:
                                      TextStyles.h5.bold.setColor(Colors.red),
                                ),
                                Text(
                                  '${NumberFormat.currency(locale: 'vi_VN', symbol: 'vnđ').format(calculateTotalPayment())}',
                                  style:
                                      TextStyles.h5.bold.setColor(Colors.red),
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
                                final productOwnerID = cartItem.productOwnerID;
                                final customerID = AuthProvider
                                    .userModel!.customer!.customerID;
                                final shippingFee = cartItem.serviceFee;
                                final orderDetail = <Map<String, dynamic>>[];
                                final voucherDiscount =
                                    cartItem.voucherDiscount;
                                final voucherID = cartItem.voucherID;
                                if (cartItem.voucherCode != '') {
                                  await AuthenticationService.useVoucher(
                                      cartItem.voucherCode);
                                }

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
                                                  0) -
                                          voucherDiscount;
                                  final total = totalBuyPriceProduct +
                                      shippingFee +
                                      10000;
                                  if (voucherID == 0) {
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
                                  } else {
                                    final order = {
                                      'customerAddress': customerAddress,
                                      'customerID': customerID,
                                      'orderDetail': orderDetail,
                                      'productownerID': productOwnerID,
                                      'shippingFee': shippingFee,
                                      'total': total,
                                      'totalBuyPriceProduct':
                                          totalBuyPriceProduct,
                                      'voucherID': voucherID
                                    };
                                    orderData.add(order);
                                  }
                                }
                              }
                              final response = await AuthenticationService
                                  .createOrderBuyAndOrderBuyDetail(orderData);
                              if (response != null) {
                                for (final cartItem in selectedCartItems) {
                                  cartItem.serviceFee = 0;
                                  cartItem.voucherDiscount = 0;
                                  cartItem.slectedDiscountText = 'Chọn voucher';
                                }
                                showCustomDialog(context, 'Thành công',
                                    "Bạn đã thanh toán thành công!", false);
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
                                  'Bạn chưa có địa chỉ', true);
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }
          },
        ));
  }
}
