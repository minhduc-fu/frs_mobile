import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../../core/constants/color_constants.dart';
import '../../../../../core/constants/dismension_constants.dart';
import '../../../../widgets/app_bar_main.dart';
import 'buy_order_history/buy_order_history.dart';
import 'rental_order_history/rental_order_history.dart';

class MainOrderHistoryScreen extends StatefulWidget {
  const MainOrderHistoryScreen({super.key});
  static const String routeName = '/main_order_history_screen';
  @override
  State<MainOrderHistoryScreen> createState() => _MainOrderHistoryScreen();
}

class _MainOrderHistoryScreen extends State<MainOrderHistoryScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.index = 0;
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppBarMain(
      leading: GestureDetector(
        onTap: () {
          Navigator.of(context).pop();
        },
        child: Container(
            color: ColorPalette.backgroundScaffoldColor,
            child: Icon(FontAwesomeIcons.angleLeft)),
      ),
      child: Scaffold(
        body: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                // borderRadius: BorderRadius.circular(kDefaultCircle14),
                color: ColorPalette.backgroundScaffoldColor,
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(5),
                    child: TabBar(
                      physics: ScrollPhysics(),
                      // physics: NeverScrollableScrollPhysics(),
                      // physics: BouncingScrollPhysics(),
                      dividerColor: ColorPalette.backgroundScaffoldColor,
                      indicator: BoxDecoration(
                        color: ColorPalette.primaryColor,
                        borderRadius: BorderRadius.circular(kDefaultCircle14),
                      ),
                      unselectedLabelColor: ColorPalette.textColor,
                      indicatorSize: TabBarIndicatorSize.tab,
                      labelColor: ColorPalette.white1,
                      controller: _tabController,
                      tabs: [
                        Tab(
                          text: 'Quản lý đơn hàng Thuê',
                        ),
                        Tab(
                          text: 'Quản lý đơn hàng Mua',
                        )
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
                  RentalOrderHistory(),
                  BuyOrderHistory(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
