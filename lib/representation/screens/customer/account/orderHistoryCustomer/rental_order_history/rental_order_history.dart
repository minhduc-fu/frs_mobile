import 'package:flutter/material.dart';

import '../../../../../../core/constants/color_constants.dart';
import '../../../../../../core/constants/dismension_constants.dart';
import '../buy_order_history/confirm_buy_order.dart';

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
    _tabController = TabController(length: 5, vsync: this);
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
                        text: 'Chờ xác nhận',
                      ),
                      Tab(
                        text: 'Đang giao',
                      ),
                      Tab(
                        text: 'Đang thuê',
                      ),
                      Tab(
                        text: 'Hoàn tất',
                      ),
                      Tab(
                        text: 'Đã hủy',
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
                ConfirmBuyOrder(),
                ConfirmBuyOrder(),
                ConfirmBuyOrder(),
                ConfirmBuyOrder(),
                ConfirmBuyOrder(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
