import 'dart:typed_data';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:frs_mobile/core/constants/color_constants.dart';
import 'package:frs_mobile/core/constants/dismension_constants.dart';
import 'package:frs_mobile/core/constants/textstyle_constants.dart';
import 'package:frs_mobile/models/productOwner_model.dart';
import 'package:frs_mobile/representation/screens/customer/account/orderHistoryCustomer/main_order_history_screen.dart';
import 'package:frs_mobile/representation/screens/customer/account/orderHistoryCustomer/rental_order_history/models/order_rent_detail_model.dart';
import 'package:frs_mobile/representation/screens/customer/account/orderHistoryCustomer/rental_order_history/models/order_rent_model.dart';
import 'package:frs_mobile/representation/screens/customer/account/orderHistoryCustomer/rental_order_history/services/api_order_rent_history.dart';
import 'package:frs_mobile/representation/screens/productowner_screen/productOwner_shop_screen.dart';
import 'package:frs_mobile/representation/widgets/button_widget.dart';
import 'package:frs_mobile/services/add_image_cloud.dart';
import 'package:frs_mobile/services/authentication_service.dart';
import 'package:frs_mobile/services/authprovider.dart';
import 'package:frs_mobile/utils/dialog_helper.dart';
import 'package:frs_mobile/utils/image_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class DangthueChotraScreen extends StatefulWidget {
  final OrderRentModel order;
  const DangthueChotraScreen({super.key, required this.order});

  @override
  State<DangthueChotraScreen> createState() => _DangthueChotraScreenState();
}

class _DangthueChotraScreenState extends State<DangthueChotraScreen> {
  int? accountID = AuthProvider.userModel?.accountID;
  List<Uint8List> _images = [];
  void selectImage() async {
    if (_images.length < 9) {
      Uint8List img = await pickAImage(ImageSource.camera);
      setState(() {
        _images.add(img);
      });
    }
  }

  Future<void> received() async {
    if (_images.isEmpty) {
      showCustomDialog(context, 'Lỗi', 'Bạn chưa chọn "Thêm hình ảnh".', true);
    } else {
      showDialog(
        context: context,
        builder: (context) {
          return Center(
            child: CircularProgressIndicator(
              color: ColorPalette.primaryColor,
            ),
          );
        },
      );
      try {
        List<String> imageUrls = await AddImageCloud().uploadListImageToStorage(
            'imagesReceived', _images, widget.order.orderRentID);
        await ApiOderRentHistory.createNewPic(
            accountID!, imageUrls, widget.order.orderRentID, 'CUS_RECEIVED');
        await ApiOderRentHistory.updateStatusOrderRent(
            widget.order.orderRentID, "RENTING");
        Navigator.pop(context);
        Navigator.pop(context);
        Navigator.of(context).pushReplacement(CupertinoPageRoute(
          builder: (context) => MainOrderHistoryScreen(),
        ));
      } catch (e) {}
    }
  }

  Future<void> returning() async {
    if (_images.isEmpty) {
      showCustomDialog(context, 'Lỗi', 'Bạn chưa chọn "Thêm hình ảnh".', true);
    } else {
      showDialog(
        context: context,
        builder: (context) {
          return Center(
            child: CircularProgressIndicator(
              color: ColorPalette.primaryColor,
            ),
          );
        },
      );
      try {
        List<String> imageUrls = await AddImageCloud().uploadListImageToStorage(
            'imagesReturn', _images, widget.order.orderRentID);
        await ApiOderRentHistory.createNewPic(
            accountID!, imageUrls, widget.order.orderRentID, "CUS_SEND");
        await ApiOderRentHistory.updateStatusOrderRent(
            widget.order.orderRentID, "RETURNING");
        Navigator.pop(context);
        Navigator.pop(context);
        Navigator.of(context).pushReplacement(CupertinoPageRoute(
          builder: (context) => MainOrderHistoryScreen(),
        ));
      } catch (e) {}
    }
  }

  void retakeImage(int index) async {
    Uint8List img = await pickAImage(ImageSource.camera);
    setState(() {
      _images[index] = img;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
                color: ColorPalette.backgroundScaffoldColor,
                child: Icon(FontAwesomeIcons.angleLeft)),
          ),
          title: Center(
            child: Text(
                widget.order.status == "CONFIRMING" ? 'Đã nhận' : "Trả đồ"),
          ),
          backgroundColor: ColorPalette.backgroundScaffoldColor,
        ),
        body: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    Text(
                      'Sản phẩm',
                      style: TextStyles.defaultStyle.setTextSize(20).bold,
                    ),
                    SizedBox(height: 10),
                    Container(
                      padding: EdgeInsets.all(5),
                      margin: EdgeInsets.only(bottom: 20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(kDefaultCircle14),
                      ),
                      child: Column(
                        children: [
                          //productOwnerName
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: GestureDetector(
                              onTap: () async {
                                ProductOwnerModel? productOwnerModel =
                                    await AuthenticationService
                                        .getProductOwnerByID(
                                            widget.order.productownerID);
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
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    widget.order.productOwnerName,
                                    style: TextStyles.h5.bold,
                                  ),
                                  Row(
                                    children: [
                                      Text('Xem Chủ sản phẩm'),
                                      Icon(FontAwesomeIcons.angleRight)
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Divider(
                            thickness: 0.5,
                            color: ColorPalette.textHide,
                          ),
                          Container(
                            child: FutureBuilder(
                              future: ApiOderRentHistory
                                  .getAllOrderRentDetailByOrderRentID(
                                      widget.order.orderRentID),
                              builder: ((context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return Center(
                                      child: CircularProgressIndicator());
                                } else if (snapshot.hasError) {
                                  return Text('Error: ${snapshot.error}');
                                } else {
                                  List<OrderRentDetailModel>? orderDetails =
                                      snapshot.data;
                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: orderDetails!.map((detail) {
                                      return Container(
                                        margin: EdgeInsets.only(top: 10),
                                        height: 140,
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
                                                detail
                                                    .productDTOModel.productAvt,
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
                                                    width: 230,
                                                    child: AutoSizeText(
                                                      detail.productDTOModel
                                                          .productName,
                                                      minFontSize: 16,
                                                      style: TextStyles.h5.bold,
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                  Text(
                                                    '${DateFormat('dd/MM/yyyy').format(detail.startDate)} - ${DateFormat('dd/MM/yyyy').format(detail.endDate)}',
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
                                                              '${NumberFormat.currency(locale: 'vi_VN', symbol: 'vnđ').format(detail.cocMoney)}',
                                                          style: TextStyles
                                                              .defaultStyle.bold
                                                              .setColor(
                                                                  const Color
                                                                      .fromARGB(
                                                                      255,
                                                                      235,
                                                                      99,
                                                                      89)),
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
                                                              '${NumberFormat.currency(locale: 'vi_VN', symbol: 'vnđ').format(detail.rentPrice)}',
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
                                      );
                                    }).toList(),
                                  );
                                }
                              }),
                            ),
                          ),
                          SizedBox(height: 10),
                          Divider(
                            thickness: 0.5,
                            color: ColorPalette.textHide,
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Tổng tiền cọc'),
                                Text(
                                  '${NumberFormat.currency(locale: 'vi_VN', symbol: 'vnđ').format(widget.order.cocMoneyTotal)}',
                                ),
                              ],
                            ),
                          ),
                          Divider(
                            thickness: 0.5,
                            color: ColorPalette.textHide,
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Tổng tiền thuê'),
                                Text(
                                  '${NumberFormat.currency(locale: 'vi_VN', symbol: 'vnđ').format(widget.order.totalRentPriceProduct)}',
                                ),
                              ],
                            ),
                          ),
                          Divider(
                            thickness: 0.5,
                            color: ColorPalette.textHide,
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Phí vận chuyển'),
                                Text(
                                  '${NumberFormat.currency(locale: 'vi_VN', symbol: 'vnđ').format(widget.order.shippingFee)}',
                                ),
                              ],
                            ),
                          ),
                          Divider(
                            thickness: 0.5,
                            color: ColorPalette.textHide,
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Phí hệ thống'),
                                Text(
                                  '10.000 vnđ',
                                ),
                              ],
                            ),
                          ),
                          Divider(
                            thickness: 0.5,
                            color: ColorPalette.textHide,
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Thành tiền'),
                                Text(
                                  '${NumberFormat.currency(locale: 'vi_VN', symbol: 'vnđ').format(widget.order.total)}',
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(kDefaultCircle14),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Hình ảnh sản phẩm',
                                style: TextStyles.h5.bold,
                              ),
                              Text(
                                'Tối đa 9 ảnh',
                                style: TextStyles.h5.bold,
                              ),
                            ],
                          ),
                          Divider(
                            thickness: 0.5,
                            color: ColorPalette.textHide,
                          ),
                          _images.isNotEmpty
                              ? Container(
                                  height: 100,
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: _images.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return GestureDetector(
                                        onTap: () {
                                          retakeImage(index);
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(
                                                kDefaultCircle14),
                                            child: Image.memory(
                                              _images[index]!,
                                              cacheHeight: 80,
                                              cacheWidth: 80,
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                )
                              : Container(),
                          GestureDetector(
                            onTap: selectImage,
                            child: Container(
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(14),
                              ),
                              height: 80,
                              width: double.infinity,
                              //
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(FontAwesomeIcons.camera, size: 20),
                                  SizedBox(height: 10),
                                  Text('Thêm Hình ảnh'),
                                ],
                              ),
                            ),
                            // Container(
                            //   height: 80,
                            //   width: 80,
                            //   child: Padding(
                            //     padding: const EdgeInsets.all(10.0),
                            //     child: Column(
                            //       children: [
                            //         Icon(FontAwesomeIcons.camera),
                            //         Text(
                            //           'Thêm',
                            //           style: TextStyles.defaultStyle,
                            //         ),
                            //         Text(
                            //           'hình ảnh',
                            //           style: TextStyles.defaultStyle,
                            //         )
                            //       ],
                            //     ),
                            //   ),
                            //   decoration: BoxDecoration(
                            //     border:
                            //         Border.all(color: ColorPalette.textHide),
                            //     borderRadius:
                            //         BorderRadius.circular(kDefaultCircle14),
                            //   ),
                            // ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            ButtonWidget(
              title: widget.order.status == "CONFIRMING" ? "Đã nhận" : "Trả đồ",
              size: 18,
              height: 70,
              onTap: widget.order.status == "CONFIRMING" ? received : returning,
            ),
          ],
        ));
  }
}
