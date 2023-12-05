import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:frs_mobile/core/constants/color_constants.dart';
import 'package:frs_mobile/core/constants/dismension_constants.dart';
import 'package:frs_mobile/core/constants/textstyle_constants.dart';
import 'package:frs_mobile/models/productOwner_model.dart';
import 'package:frs_mobile/representation/screens/customer/account/orderHistoryCustomer/buy_order_history/model/order_buy_detail_model.dart';
import 'package:frs_mobile/representation/screens/productowner_screen/productOwner_shop_screen.dart';
import 'package:frs_mobile/services/authentication_service.dart';
import 'package:intl/intl.dart';

import '../model/order_buy_model.dart';
import '../services/api_buy_order_history.dart';

class InforMationOrderBuyScreen extends StatefulWidget {
  final OrderBuyModel order;
  const InforMationOrderBuyScreen({super.key, required this.order});

  @override
  State<InforMationOrderBuyScreen> createState() =>
      _InforMationOrderBuyScreenState();
}

class _InforMationOrderBuyScreenState extends State<InforMationOrderBuyScreen> {
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
          title: Center(child: Text('Thông tin đơn hàng')),
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
                      'Thông tin nhận hàng',
                      style: TextStyles.defaultStyle.setTextSize(20).bold,
                    ),
                    Text(
                      '${widget.order.orderBuyID}',
                      style: TextStyles.defaultStyle.setTextSize(20).bold,
                    ),
                    SizedBox(height: 10),
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
                            children: [
                              Icon(
                                FontAwesomeIcons.solidUser,
                                size: 14,
                              ),
                              SizedBox(width: 10),
                              Text(widget.order.customerName),
                            ],
                          ),
                          SizedBox(height: 10),
                          Row(
                            children: [
                              Icon(FontAwesomeIcons.locationDot, size: 14),
                              SizedBox(width: 10),
                              Container(
                                width: 250,
                                child: AutoSizeText(
                                  widget.order.customerAddress,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Ngày đặt hàng',
                      style: TextStyles.defaultStyle.setTextSize(20).bold,
                    ),
                    SizedBox(height: 10),
                    Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(kDefaultCircle14),
                      ),
                      child: Text(
                        '${DateFormat('dd/MM/yyyy').format(widget.order.dateOrder)}',
                      ),
                    ),
                    SizedBox(height: 20),
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
                              future: ApiBuyOderHistory
                                  .getAllOrderBuyDetailByOrderBuyID(
                                      widget.order.orderBuyID),
                              builder: ((context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return Center(
                                      child: CircularProgressIndicator());
                                } else if (snapshot.hasError) {
                                  return Text('Error: ${snapshot.error}');
                                } else {
                                  List<OrderBuyDetailModel>? orderDetails =
                                      snapshot.data;
                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: orderDetails!.map((detail) {
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
                                                    '${NumberFormat.currency(locale: 'vi_VN', symbol: 'vnđ').format(
                                                      detail.productDTOModel
                                                          .price,
                                                    )}',
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
                                Text('Tổng tiền hàng'),
                                Text(
                                  '${NumberFormat.currency(locale: 'vi_VN', symbol: 'vnđ').format(widget.order.totalBuyPriceProduct)}',
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
                                // AutoSizeText(
                                //   'aaaaa',
                                //   style: TextStyle(
                                //       decoration: TextDecoration.lineThrough),
                                // ),
                                Text(
                                  '${NumberFormat.currency(locale: 'vi_VN', symbol: 'vnđ').format(widget.order.total)}',
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ));
  }
}
