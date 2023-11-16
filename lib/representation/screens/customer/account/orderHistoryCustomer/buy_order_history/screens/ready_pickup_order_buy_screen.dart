import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frs_mobile/core/constants/color_constants.dart';
import 'package:frs_mobile/core/constants/dismension_constants.dart';
import 'package:frs_mobile/core/constants/textstyle_constants.dart';
import 'package:frs_mobile/representation/screens/customer/account/orderHistoryCustomer/buy_order_history/model/order_buy_detail_model.dart';
import 'package:frs_mobile/representation/screens/customer/account/orderHistoryCustomer/buy_order_history/model/order_buy_model.dart';
import 'package:frs_mobile/services/authprovider.dart';
import 'package:intl/intl.dart';

import '../services/api_buy_order_history.dart';
import 'information_order_buy_screen.dart';

class ReadyPickupOrderBuyScreen extends StatefulWidget {
  const ReadyPickupOrderBuyScreen({super.key});

  @override
  State<ReadyPickupOrderBuyScreen> createState() =>
      _ReadyPickupOrderBuyScreenState();
}

class _ReadyPickupOrderBuyScreenState extends State<ReadyPickupOrderBuyScreen> {
  int customerID = AuthProvider.userModel!.customer!.customerID;

  void _navigateToInformationScreen(OrderBuyModel order) {
    Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (context) => InforMationOrderBuyScreen(order: order),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: FutureBuilder(
          future: ApiBuyOderHistory.getAllReadyPickUpOrderBuyByCustomerID(
              customerID),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              List<OrderBuyModel>? orders = snapshot.data;
              if (orders == null) {
                return Center(
                    child: Text('Không có đơn hàng nào.',
                        style: TextStyles.h5.bold));
              } else if (orders.isEmpty) {
                return Center(
                    child: Text('Không có đơn hàng nào.',
                        style: TextStyles.h5.bold));
              } else {
                return ListView.builder(
                    itemCount: orders.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          _navigateToInformationScreen(orders[index]);
                        },
                        child: Container(
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
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      orders[index].productOwnerName,
                                      style: TextStyles.h5.bold,
                                    ),
                                    Text(
                                      orders[index].status == 'READY_PICKUP'
                                          ? "Chờ giao hàng"
                                          : "",
                                      style: TextStyles.h5.bold,
                                    ),
                                  ],
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
                                          orders[index].orderBuyID),
                                  builder: ((context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return CircularProgressIndicator();
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
                                                    detail.productDTOModel
                                                        .productAvt,
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
                                                        detail.productDTOModel
                                                            .productName,
                                                        style:
                                                            TextStyles.h5.bold,
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Thành tiền'),
                                    Text(
                                      '${NumberFormat.currency(locale: 'vi_VN', symbol: 'vnđ').format(orders[index].total + 10000)}',
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    });
              }
            }
          },
        ),
      ),
    );
  }
}