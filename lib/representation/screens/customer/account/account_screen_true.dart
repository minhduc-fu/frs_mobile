import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:frs_mobile/core/constants/dismension_constants.dart';
import 'package:frs_mobile/representation/screens/wallet/wallet_screen.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/color_constants.dart';
import '../../../../core/constants/textstyle_constants.dart';
import '../../../../services/authprovider.dart';
import '../../../../utils/asset_helper.dart';
import '../../../../utils/image_helper.dart';
import '../../../widgets/app_bar_main.dart';
import '../../main_app.dart';
import 'account_tile.dart';
import 'orderHistoryCustomer/main_order_history_screen.dart';
import 'profile/customer_profile_screen.dart';

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
    'Ví của bạn',
    'Thay đổi mật khẩu',
    'Đăng xuất',
  ];
  final List _tienIch = [
    'Liên hệ hỗ trợ',
    'Về chúng tôi',
  ];

  final List<IconData> _iconData = [
    FontAwesomeIcons.solidFileLines,
    FontAwesomeIcons.solidUser,
    FontAwesomeIcons.wallet,
    FontAwesomeIcons.key,
    FontAwesomeIcons.rightToBracket,
  ];
  final List<IconData> _iconTienIch = [
    FontAwesomeIcons.headset,
    FontAwesomeIcons.users,
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
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
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
                                AuthProvider.userModel?.customer?.fullName ??
                                    '',
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
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(kDefaultCircle14),
                      color: ColorPalette.hideColor),
                  child: ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: _title
                        .length, // Đổi yourData thành danh sách dữ liệu của bạn
                    itemBuilder: (context, index) {
                      return AccountTile(
                        onTap: () {
                          if (index == 0) {
                            Navigator.of(context)
                                .pushNamed(MainOrderHistoryScreen.routeName);
                          } else if (index == 2) {
                            Navigator.of(context)
                                .pushNamed(WalletScreen.routeName);
                          } else if (index == 4) {
                            _handleLogout(context);
                          } else if (index == 1) {
                            Navigator.of(context)
                                .pushNamed(CustomerProfileScreen.routeName);
                          }
                        },
                        icons: _iconData[index],
                        title: _title[index],
                        trailing:
                            index == 4 ? null : FontAwesomeIcons.angleRight,
                      );
                    },
                  ),
                ),
                SizedBox(height: 20),
                Container(
                  // height: double.maxFinite,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(kDefaultCircle14),
                      color: ColorPalette.hideColor),
                  child: ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: _tienIch
                        .length, // Đổi yourData thành danh sách dữ liệu của bạn
                    itemBuilder: (context, index) {
                      return AccountTile(
                        onTap: () {},
                        icons: _iconTienIch[index],
                        title: _tienIch[index],
                        trailing: FontAwesomeIcons.angleRight,
                      );
                    },
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