import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:frs_mobile/core/constants/dismension_constants.dart';
import 'package:frs_mobile/representation/screens/about_frs/about_us.dart';
import 'package:frs_mobile/representation/screens/customer/account/address/address_screen.dart';
import 'package:frs_mobile/representation/screens/customer/account/contact_support/contact_support_screen.dart';
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

class AccountCustomerScreen extends StatefulWidget {
  const AccountCustomerScreen({super.key});
  static const String routeName = '/account_customer_screen';
  @override
  State<AccountCustomerScreen> createState() => _AccountCustomerScreenState();
}

class _AccountCustomerScreenState extends State<AccountCustomerScreen> {
  late AuthProvider authProvider;

  final List _title = [
    'Quản lý đơn hàng',
    'Thông tin cá nhân',
    'Ví của bạn',
    'Địa chỉ',
    'Đổi mật khẩu',
    'Đăng xuất',
  ];
  final List _tienIch = [
    'Liên hệ hỗ trợ',
  ];

  final List<IconData> _iconData = [
    FontAwesomeIcons.solidFileLines,
    FontAwesomeIcons.solidUser,
    FontAwesomeIcons.wallet,
    FontAwesomeIcons.locationDot,
    FontAwesomeIcons.key,
    FontAwesomeIcons.rightToBracket,
  ];
  final List<IconData> _iconTienIch = [
    FontAwesomeIcons.headset,
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
                        child: Stack(
                          children: [
                            CircleAvatar(
                              radius: 50,
                              backgroundColor: ColorPalette.primaryColor,
                            ),
                            Positioned(
                              top: 5,
                              left: 5,
                              bottom: 5,
                              right: 5,
                              child: CircleAvatar(
                                radius: 45,
                                backgroundImage: NetworkImage(
                                  AuthProvider.userModel?.customer?.avatarUrl ??
                                      '',
                                ),
                              ),
                            ),
                          ],
                        ),
                        // child: ClipOval(
                        //   //avt
                        //   child: Image.network(
                        //       AuthProvider.userModel?.customer?.avatarUrl ?? '',
                        //       fit: BoxFit.cover,
                        //       height: 100,
                        //       width: 100),
                        // ),
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
                          } else if (index == 1) {
                            Navigator.of(context)
                                .pushNamed(CustomerProfileScreen.routeName);
                          } else if (index == 2) {
                            Navigator.of(context)
                                .pushNamed(WalletScreen.routeName);
                          } else if (index == 3) {
                            Navigator.of(context)
                                .pushNamed(AddressScreen.routeName);
                          } else if (index == 5) {
                            _handleLogout(context);
                          }
                        },
                        icons: _iconData[index],
                        title: _title[index],
                        trailing:
                            index == 5 ? null : FontAwesomeIcons.angleRight,
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
                        onTap: () {
                          if (index == 0) {
                            Navigator.of(context)
                                .pushNamed(ContactSupportScreen.routeName);
                          }
                        },
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
