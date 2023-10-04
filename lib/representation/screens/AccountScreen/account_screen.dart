import 'package:demo_frs_app/core/constants/color_constants.dart';
import 'package:demo_frs_app/core/constants/textstyle_constants.dart';
import 'package:demo_frs_app/representation/screens/login_or_register/login_screen.dart';
import 'package:demo_frs_app/representation/screens/login_or_register/register_demo.dart';
import 'package:demo_frs_app/representation/screens/login_or_register/register_screen.dart';
import 'package:demo_frs_app/representation/widgets/app_bar_container.dart';
import 'package:flutter/material.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  static const String routeName = '/account_screen';
  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppBarContainer(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            child: Column(
              children: [
                Container(
                  width: MediaQuery.of(context).size.height,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: ColorPalette.primaryColor,
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(5),
                        child: TabBar(
                          // physics: ClampingScrollPhysics(),
                          physics: BouncingScrollPhysics(),
                          dividerColor:
                              ColorPalette.primaryColor, // reload mới thay đổi
                          indicator: BoxDecoration(
                            color: ColorPalette.backgroundScaffoldColor,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          unselectedLabelColor: Colors.white,
                          indicatorSize: TabBarIndicatorSize.tab,
                          labelColor: ColorPalette.textColor,
                          labelStyle: TextStyles.defaultStyle,
                          controller: _tabController,
                          tabs: [
                            Tab(text: 'Đăng nhập'),
                            Tab(text: 'Đăng ký'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      // RegisterScreen(onTap: () {}),
                      LoginScreen(onTap: () {}),
                      // RegisterScreen(onTap: () {}),
                      RegisterDemo(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
