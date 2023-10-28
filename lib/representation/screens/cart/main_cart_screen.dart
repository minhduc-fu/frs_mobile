import 'package:demo_frs_app/core/constants/color_constants.dart';
import 'package:demo_frs_app/core/constants/dismension_constants.dart';
import 'package:demo_frs_app/representation/screens/cart/buy_cart_screen.dart';
import 'package:demo_frs_app/representation/screens/cart/rental_cart_screen.dart';
import 'package:demo_frs_app/representation/widgets/app_bar_main.dart';
import 'package:demo_frs_app/utils/asset_helper.dart';
import 'package:demo_frs_app/utils/image_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MainCartScreen extends StatefulWidget {
  const MainCartScreen({super.key});
  static const String routeName = '/main_cart_screen';
  @override
  State<MainCartScreen> createState() => _MainCartScreenState();
}

class _MainCartScreenState extends State<MainCartScreen>
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
      isCart: false,
      leading: FractionallySizedBox(
        widthFactor: 0.8,
        heightFactor: 0.8,
        child: ImageHelper.loadFromAsset(
          AssetHelper.imageLogoFRS,
        ),
      ),
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(kDefaultCircle14),
                  color: ColorPalette.primaryColor,
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(5),
                      child: TabBar(
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
                            text: 'Giỏ hàng Thuê',
                          ),
                          Tab(
                            text: 'Giỏ hàng Mua',
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
                    RentalCartScreen(),
                    BuyCartScreen(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}