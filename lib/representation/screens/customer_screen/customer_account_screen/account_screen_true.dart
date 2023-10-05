import 'package:demo_frs_app/core/constants/color_constants.dart';
import 'package:demo_frs_app/core/constants/textstyle_constants.dart';
import 'package:demo_frs_app/core/helper/asset_helper.dart';
import 'package:demo_frs_app/core/helper/image_helper.dart';
import 'package:demo_frs_app/representation/screens/customer_screen/customer_account_screen/account_tile.dart';
import 'package:demo_frs_app/representation/widgets/app_bar_container.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AccountScreenTrue extends StatefulWidget {
  const AccountScreenTrue({super.key});
  static const String routeName = '/account_screen_true';
  @override
  State<AccountScreenTrue> createState() => _AccountScreenTrueState();
}

class _AccountScreenTrueState extends State<AccountScreenTrue> {
  final List _title = [
    'Order History',
    'Profile',
    'Wallet',
    'Contact Support',
    'About FRS',
    'Change Password',
    'Logout',
  ];

  final List<IconData> _iconData = [
    FontAwesomeIcons.solidFileLines,
    FontAwesomeIcons.solidUser,
    FontAwesomeIcons.wallet,
    FontAwesomeIcons.headset,
    FontAwesomeIcons.users,
    FontAwesomeIcons.key,
    FontAwesomeIcons.rightToBracket,
  ];
  @override
  Widget build(BuildContext context) {
    return AppBarContainer(
      child: Scaffold(
        body: Column(
          children: [
            //Tên, Avt
            Container(
              height: 120,
              width: 150,
              decoration: BoxDecoration(
                  color: ColorPalette.primaryColor,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(90),
                    bottomRight: Radius.circular(90),
                  )),
              child: Center(
                child: ClipOval(
                  child: ImageHelper.loadFromAsset(AssetHelper.imageBanner1,
                      fit: BoxFit.cover, height: 100, width: 100),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),

            // tên, gmail
            Column(
              children: [
                // tên
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Minh Duc',
                      style: TextStyles.h5.setTextSize(20).bold,
                    ),
                  ],
                ),

                //gmail
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'bdmduc2000@gmail.com',
                      style: TextStyles.h5,
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),

            // Quản lý đơn hàng thuê
            Expanded(
                child: ListView.builder(
              itemCount:
                  _title.length, // Đổi yourData thành danh sách dữ liệu của bạn
              itemBuilder: (context, index) {
                return AccountTile(
                  onTap: () {},
                  icons: _iconData[index],
                  title: _title[index],
                  trailing: index > 5 ? null : FontAwesomeIcons.angleRight,
                );
              },
            )
                // ListView(
                //   padding: const EdgeInsets.symmetric(horizontal: 15),
                //   children: [
                //     ListTitle(
                //       icons: FontAwesomeIcons.solidFileLines,
                //       title: 'Order History',
                //       trailing: FontAwesomeIcons.angleRight,
                //     ),
                //     ListTitle(
                //       icons: FontAwesomeIcons.solidUser,
                //       title: 'Profile',
                //       trailing: FontAwesomeIcons.angleRight,
                //     ),
                //     ListTitle(
                //       icons: FontAwesomeIcons.wallet,
                //       title: 'Wallet',
                //       trailing: FontAwesomeIcons.angleRight,
                //     ),
                //     ListTitle(
                //       icons: FontAwesomeIcons.headset,
                //       title: 'Contact Support',
                //       trailing: FontAwesomeIcons.angleRight,
                //     ),
                //     ListTitle(
                //       icons: FontAwesomeIcons.users,
                //       title: 'About FRS',
                //       trailing: FontAwesomeIcons.angleRight,
                //     ),
                //     ListTitle(
                //       icons: FontAwesomeIcons.key,
                //       title: 'Change Password',
                //       trailing: FontAwesomeIcons.angleRight,
                //     ),
                //     ListTitle(
                //       icons: FontAwesomeIcons.rightToBracket,
                //       title: 'Logout',
                //     ),
                //   ],
                // ),
                ),
          ],
        ),
      ),
    );
  }
}
