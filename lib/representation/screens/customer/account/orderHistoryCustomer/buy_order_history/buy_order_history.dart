import 'package:flutter/material.dart';
import 'package:frs_mobile/representation/screens/customer/account/orderHistoryCustomer/buy_order_history/screens/completed_order_buy_screen.dart';
import 'package:frs_mobile/representation/screens/customer/account/orderHistoryCustomer/buy_order_history/screens/pending_order_buy_screen.dart';
import 'package:frs_mobile/representation/screens/customer/account/orderHistoryCustomer/buy_order_history/screens/prepare_order_buy_screen.dart';
import 'package:frs_mobile/representation/screens/customer/account/orderHistoryCustomer/buy_order_history/screens/ready_pickup_order_buy_screen.dart';
import 'package:frs_mobile/representation/screens/customer/account/orderHistoryCustomer/buy_order_history/screens/reject_completed_order_buy_screen.dart';
import 'package:frs_mobile/representation/screens/customer/account/orderHistoryCustomer/buy_order_history/screens/rejecting_order_buy_screen.dart';
import '../../../../../../core/constants/color_constants.dart';
import '../../../../../../core/constants/dismension_constants.dart';
import 'screens/canceled_order_buy_screen.dart';
import 'screens/confirming_order_buy_history.dart';

class BuyOrderHistory extends StatefulWidget {
  const BuyOrderHistory({super.key});

  @override
  State<BuyOrderHistory> createState() => _BuyOrderHistoryState();
}

class _BuyOrderHistoryState extends State<BuyOrderHistory>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 8, vsync: this);
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
                PendingOrderBuyScreen(),
                PrepareOrderBuyScreen(),
                ReadyPickupOrderBuyScreen(),
                ConfirmingOrderBuyScreen(),
                CompletedOrderBuyScreen(),
                RejectingOrderBuyScreen(),
                CanceledOrderBuyScreen(),
                RejectCompletedOrderBuyScreen(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
