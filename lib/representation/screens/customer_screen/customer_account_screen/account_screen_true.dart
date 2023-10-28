import 'package:demo_frs_app/core/constants/textstyle_constants.dart';
import 'package:demo_frs_app/representation/screens/customer_screen/customer_account_screen/account_tile.dart';
import 'package:demo_frs_app/representation/screens/customer_screen/customer_account_screen/profile_customer/customer_profile_screen.dart';
import 'package:demo_frs_app/representation/screens/main_app.dart';
import 'package:demo_frs_app/representation/screens/customer_screen/customer_account_screen/orderHistoryCustomer/main_order_history_screen.dart';
import 'package:demo_frs_app/representation/widgets/app_bar_main.dart';
import 'package:demo_frs_app/services/authprovider.dart';
import 'package:demo_frs_app/utils/asset_helper.dart';
import 'package:demo_frs_app/utils/image_helper.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';

class AccountScreenTrue extends StatefulWidget {
  const AccountScreenTrue({super.key});
  static const String routeName = '/account_screen_true';
  @override
  State<AccountScreenTrue> createState() => _AccountScreenTrueState();
}

class _AccountScreenTrueState extends State<AccountScreenTrue> {
  late AuthProvider authProvider;

  final List _title = [
    'Quản lý đơn hàng',
    'Thông tin cá nhân',
    'Ví',
    'Liên hệ hỗ trợ',
    'Về chúng tôi',
    'Thay đổi mật khẩu',
    'Đăng xuất',
  ];
  Future<void> clearHiveData() async {
    await Hive.deleteBoxFromDisk('userBox');
  }

  final List<IconData> _iconData = [
    FontAwesomeIcons.solidFileLines,
    FontAwesomeIcons.solidUser,
    FontAwesomeIcons.wallet,
    FontAwesomeIcons.headset,
    FontAwesomeIcons.users,
    FontAwesomeIcons.key,
    FontAwesomeIcons.rightToBracket,
  ];
  void _handleLogout(BuildContext context) {
    var box = Hive.box('userBox');
    authProvider.clearUser();
    box.clear();
    Navigator.of(context).pushReplacementNamed(MainApp.routeName);
  }

  @override
  Widget build(BuildContext context) {
    authProvider = Provider.of<AuthProvider>(context);
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
            if (AuthProvider.userModel?.status == "NOT_VERIFIED")
              Column(
                children: [
                  Center(
                    child: ClipOval(
                      //avt
                      child: ImageHelper.loadFromAsset(
                          AssetHelper.imageCircleAvtMain,
                          fit: BoxFit.cover,
                          height: 100,
                          width: 100),
                    ),
                  ),
                  SizedBox(height: 10),
                  Column(
                    children: [
                      // tên
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Tên của bạn',
                            style: TextStyles.h5.setTextSize(20).bold,
                          ),
                        ],
                      ),
                      //gmail
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            AuthProvider.userModel?.email ?? '',
                            style: TextStyles.h5,
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            if (AuthProvider.userModel?.status == "VERIFIED")
              Column(
                children: [
                  Center(
                    child: ClipOval(
                      //avt
                      child: Image.network(
                          AuthProvider.userModel?.customer?.avatarUrl ?? '',
                          fit: BoxFit.cover,
                          height: 100,
                          width: 100),
                    ),
                  ),
                  SizedBox(height: 10),
                  // tên, gmail
                  Column(
                    children: [
                      // tên
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            AuthProvider.userModel?.customer?.fullName ?? '',
                            // 'Tên Customer',
                            style: TextStyles.h5.setTextSize(20).bold,
                          ),
                        ],
                      ),
                      //gmail
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            AuthProvider.userModel?.email ?? '',
                            style: TextStyles.h5,
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),

            SizedBox(height: 10),
            // Quản lý đơn hàng thuê
            Expanded(
              child: ListView.builder(
                itemCount: _title
                    .length, // Đổi yourData thành danh sách dữ liệu của bạn
                itemBuilder: (context, index) {
                  return AccountTile(
                    onTap: () {
                      if (index == 0) {
                        Navigator.of(context)
                            .pushNamed(MainOrderHistoryScreen.routeName);
                      } else if (index > 5) {
                        _handleLogout(context);
                      } else if (index == 1) {
                        Navigator.of(context)
                            .pushNamed(CustomerProfileScreen.routeName);
                      }
                    },
                    // onTap: () {},
                    icons: _iconData[index],
                    title: _title[index],
                    trailing: index > 5 ? null : FontAwesomeIcons.angleRight,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
