import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../core/constants/color_constants.dart';
import '../../../core/constants/dismension_constants.dart';
import '../../../core/constants/textstyle_constants.dart';
import '../../../utils/asset_helper.dart';
import '../../../utils/image_helper.dart';
import '../../widgets/app_bar_main.dart';
import '../login_or_register/login_screen.dart';
import '../login_or_register/register_account.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  static const String routeName = '/account_screen';
  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

// int currentTabIndex = 0; // mặc định hiển thị loginScreen()

class _AccountScreenState extends State<AccountScreen>
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
      leading: FractionallySizedBox(
        widthFactor: 0.8,
        heightFactor: 0.8,
        child: ImageHelper.loadFromAsset(
          AssetHelper.imageLogoFRS,
        ),
      ),
      child: Scaffold(
        body: Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
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
                        borderRadius: BorderRadius.circular(kDefaultCircle14),
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
                physics: NeverScrollableScrollPhysics(),
                controller: _tabController,
                children: [
                  LoginScreen(
                    onTap: () {
                      _tabController.index = 1;
                    },
                  ),
                  // RegisterScreen(
                  //   onTap: () {
                  //     _tabController.index = 0;
                  //   },
                  // ),
                  // RegisterDemo(
                  //   onTap: () {
                  //     _tabController.index = 0;
                  //   },
                  // ),
                  //
                  RegisterAccount(
                    onTap: () {
                      _tabController.index = 0;
                    },
                  ),
                  // RegisterStepperScreen(
                  //   onTap: () {
                  //     _tabController.index = 0;
                  //   },
                  // ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
