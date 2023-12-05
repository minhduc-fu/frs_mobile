import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frs_mobile/core/constants/color_constants.dart';
import 'package:frs_mobile/core/constants/dismension_constants.dart';
import 'package:frs_mobile/core/constants/textstyle_constants.dart';
import 'package:frs_mobile/representation/screens/customer/account/orderHistoryCustomer/rental_order_history/models/order_rent_detail_model.dart';
import 'package:frs_mobile/representation/screens/customer/account/orderHistoryCustomer/rental_order_history/models/order_rent_model.dart';
import 'package:frs_mobile/representation/screens/customer/account/orderHistoryCustomer/rental_order_history/screens/feeback_screen.dart';
import 'package:frs_mobile/representation/screens/customer/account/orderHistoryCustomer/rental_order_history/screens/information_order_rent_screen.dart';
import 'package:frs_mobile/representation/screens/customer/account/orderHistoryCustomer/rental_order_history/services/api_order_rent_history.dart';
import 'package:frs_mobile/representation/widgets/button_widget.dart';
import 'package:frs_mobile/services/authprovider.dart';
import 'package:intl/intl.dart';

class CompletedOrderRentScreen extends StatefulWidget {
  const CompletedOrderRentScreen({super.key});

  @override
  State<CompletedOrderRentScreen> createState() =>
      _CompletedOrderRentScreenState();
}

class _CompletedOrderRentScreenState extends State<CompletedOrderRentScreen> {
  void _navigateToInformationScreen(OrderRentModel order) {
    Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (context) => InforMationOrderRentScreen(order: order),
      ),
    );
  }

  void _feedbackOrder(OrderRentModel order) async {
    Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (context) => FeedbackScreen(order: order),
      ),
    );
  }

  // void _navigateToTraHangHoanTienScreen(OrderRentModel order) {
  //   Navigator.push(
  //     context,
  //     CupertinoPageRoute(
  //       builder: (context) => TraHangHoanTienOrderRentScreen(order: order),
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: AuthProvider.userModel!.status == "NOT_VERIFIED"
            ? Text('Làm ơn Cập nhật thông tin cá nhân')
            : FutureBuilder(
                future: ApiOderRentHistory.getAllCompletedOrderRentByCustomerID(
                    AuthProvider.userModel!.customer!.customerID),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    List<OrderRentModel>? orders = snapshot.data;
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
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            orders[index].productOwnerName,
                                            style: TextStyles.h5.bold,
                                          ),
                                          if (orders[index].status ==
                                              'COMPLETED')
                                            Text(
                                              "Hoàn thành",
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
                                        future: ApiOderRentHistory
                                            .getAllOrderRentDetailByOrderRentID(
                                                orders[index].orderRentID),
                                        builder: ((context, snapshot) {
                                          if (snapshot.connectionState ==
                                              ConnectionState.waiting) {
                                            return Center(
                                                child:
                                                    CircularProgressIndicator());
                                          } else if (snapshot.hasError) {
                                            return Text(
                                                'Error: ${snapshot.error}');
                                          } else {
                                            List<OrderRentDetailModel>?
                                                orderDetails = snapshot.data;
                                            return Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children:
                                                  orderDetails!.map((detail) {
                                                return Container(
                                                  margin:
                                                      EdgeInsets.only(top: 10),
                                                  height: 140,
                                                  decoration: BoxDecoration(
                                                    border: Border.all(
                                                        color: ColorPalette
                                                            .textHide),
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
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                vertical: 20),
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Container(
                                                              width: 230,
                                                              child:
                                                                  AutoSizeText(
                                                                detail
                                                                    .productDTOModel
                                                                    .productName,
                                                                minFontSize: 16,
                                                                style:
                                                                    TextStyles
                                                                        .h5
                                                                        .bold,
                                                                maxLines: 1,
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                              ),
                                                            ),
                                                            Text(
                                                              '${DateFormat('dd/MM/yyyy').format(detail.startDate)} - ${DateFormat('dd/MM/yyyy').format(detail.endDate)}',
                                                            ),
                                                            AutoSizeText.rich(
                                                              minFontSize: 14,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              maxLines: 1,
                                                              TextSpan(
                                                                children: [
                                                                  TextSpan(
                                                                    text:
                                                                        'Cọc: ',
                                                                  ),
                                                                  TextSpan(
                                                                    text:
                                                                        '${NumberFormat.currency(locale: 'vi_VN', symbol: 'vnđ').format(detail.cocMoney)}',
                                                                    style: TextStyles
                                                                        .defaultStyle
                                                                        .bold
                                                                        .setColor(
                                                                            Colors.red),
                                                                  )
                                                                ],
                                                              ),
                                                            ),
                                                            AutoSizeText.rich(
                                                              minFontSize: 14,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              maxLines: 1,
                                                              TextSpan(
                                                                children: [
                                                                  TextSpan(
                                                                    text:
                                                                        'Thuê: ',
                                                                  ),
                                                                  TextSpan(
                                                                    text:
                                                                        '${NumberFormat.currency(locale: 'vi_VN', symbol: 'vnđ').format(detail.rentPrice)}',
                                                                    style: TextStyles
                                                                        .defaultStyle
                                                                        .bold
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
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 10),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text('Thành tiền'),
                                          Text(
                                            '${NumberFormat.currency(locale: 'vi_VN', symbol: 'vnđ').format(orders[index].total)}',
                                          ),
                                        ],
                                      ),
                                    ),
                                    Divider(
                                      thickness: 0.5,
                                      color: ColorPalette.textHide,
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        ButtonWidget(
                                          onTap: () {
                                            _feedbackOrder(orders[index]);
                                          },
                                          title: 'Đánh giá',
                                          size: 18,
                                          width: 150,
                                        ),
                                      ],
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
