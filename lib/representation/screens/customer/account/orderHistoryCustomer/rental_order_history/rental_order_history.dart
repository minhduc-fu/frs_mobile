import 'package:flutter/material.dart';

import 'package:frs_mobile/representation/screens/customer/account/orderHistoryCustomer/rental_order_history/screens/canceled_order_rent_screen.dart';
import 'package:frs_mobile/representation/screens/customer/account/orderHistoryCustomer/rental_order_history/screens/completed_order_rent_screen.dart';
import 'package:frs_mobile/representation/screens/customer/account/orderHistoryCustomer/rental_order_history/screens/confirm_order_rent_screen.dart';
import 'package:frs_mobile/representation/screens/customer/account/orderHistoryCustomer/rental_order_history/screens/delivery_order_rent_screen.dart';
import 'package:frs_mobile/representation/screens/customer/account/orderHistoryCustomer/rental_order_history/screens/pending_order_rent_screen.dart';
import 'package:frs_mobile/representation/screens/customer/account/orderHistoryCustomer/rental_order_history/screens/prepare_order_rent_screen.dart';
import 'package:frs_mobile/representation/screens/customer/account/orderHistoryCustomer/rental_order_history/screens/reject_completed_order_rent_screen.dart';
import 'package:frs_mobile/representation/screens/customer/account/orderHistoryCustomer/rental_order_history/screens/reject_order_rent_screen.dart';
import 'package:frs_mobile/representation/screens/customer/account/orderHistoryCustomer/rental_order_history/screens/renting_order_rent_screen.dart';
import 'package:frs_mobile/representation/screens/customer/account/orderHistoryCustomer/rental_order_history/screens/return_order_rent_screen.dart';

import '../../../../../../core/constants/color_constants.dart';
import '../../../../../../core/constants/dismension_constants.dart';

class RentalOrderHistory extends StatefulWidget {
  const RentalOrderHistory({super.key});

  @override
  State<RentalOrderHistory> createState() => _RentalOrderHistoryState();
}

class _RentalOrderHistoryState extends State<RentalOrderHistory>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 10, vsync: this);
    _tabController.index = 0;
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              // borderRadius: BorderRadius.circular(kDefaultCircle14),
              color: ColorPalette.primaryColor,
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(5),
                  child: TabBar(
                    isScrollable: true,
                    physics: ScrollPhysics(),
                    // physics: NeverScrollableScrollPhysics(),
                    // physics: BouncingScrollPhysics(),
                    dividerColor: ColorPalette.primaryColor,
                    indicator: BoxDecoration(
                      color: ColorPalette.backgroundScaffoldColor,
                      borderRadius: BorderRadius.circular(kDefaultCircle14),
                    ),
                    unselectedLabelColor: Colors.white,
                    indicatorSize: TabBarIndicatorSize.tab,
                    labelColor: ColorPalette.textColor,
                    controller: _tabController,
                    tabs: [
                      Tab(
                        text: 'Chờ phê duyệt',
                      ),
                      Tab(
                        text: 'Chuẩn bị hàng',
                      ),
                      Tab(
                        text: 'Đang giao',
                      ),
                      Tab(
                        text: 'Chờ xác nhận',
                      ),
                      Tab(
                        text: 'Đang thuê',
                      ),
                      Tab(
                        text: 'Chờ trả',
                      ),
                      Tab(
                        text: 'Hoàn thành',
                      ),
                      Tab(
                        text: 'Từ chối',
                      ),
                      Tab(
                        text: 'Đã hủy',
                      ),
                      Tab(
                        text: 'Trả hàng/Hoàn tiền',
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              // physics: ScrollPhysics(),
              physics: NeverScrollableScrollPhysics(),
              // physics: BouncingScrollPhysics(),
              controller: _tabController,
              children: [
                PendingOrderRentScreen(),
                PrepareOrderRentScreen(),
                DeliveryOrderRentScreen(),
                ConfirmOrderRentScreen(),
                RentingOrderRentScreen(),
                ReturnOrderRentScreen(),
                CompletedOrderRentScreen(),
                RejectOrderRentScreen(),
                CanceledOrderRentScreen(),
                RejectCompletedOrderRentScreen()
              ],
            ),
          ),
        ],
      ),
    );
  }
}
