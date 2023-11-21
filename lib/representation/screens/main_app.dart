import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

import '../../core/constants/color_constants.dart';
import '../../core/constants/dismension_constants.dart';
import 'guest/account_screen.dart';
import 'cart/main_cart_screen.dart';
import 'home_screen_demo.dart';

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  static const String routeName = '/main_app';

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  int _currentIndex = 0;
  // final user = FirebaseAuth.instance.currentUser!;
  // User? user;

  @override
  void initState() {
    super.initState();
    // user = FirebaseAuth.instance.currentUser;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: [
          // HomeScreen(),
          HomeScreenDemo(),
          // FavoriteScreen(),
          // ChatScreen(),
          // MenuScreen(),
          // CartFoodScreen(),
          // Register(),
          MainCartScreen(),
          AccountScreen(),
          // AccountScreenTrue(),
        ],
        // child: user != null ? Text('${user!.email}') : Text("Chưa đăng nhập"),
      ),
      bottomNavigationBar: SalomonBottomBar(
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        currentIndex: _currentIndex,
        selectedItemColor: ColorPalette.primaryColor,
        unselectedItemColor: ColorPalette.textHide,
        margin: EdgeInsets.symmetric(
            horizontal: kMediumPadding24, vertical: kDefaultPadding16),
        items: [
          SalomonBottomBarItem(
            title: Text('Trang chủ'),
            icon: Icon(
              FontAwesomeIcons.house,
              size: kDefaultIconSize18,
            ),
          ),
          // SalomonBottomBarItem(
          //   title: Text('Yêu thích'),
          //   icon: Icon(
          //     FontAwesomeIcons.solidHeart,
          //     size: kDefaultIconSize,
          //   ),
          // ),
          // SalomonBottomBarItem(
          //   title: Text('Tin nhắn'),
          //   icon: Icon(
          //     FontAwesomeIcons.solidMessage,
          //     size: kDefaultIconSize,
          //   ),
          // ),
          SalomonBottomBarItem(
            title: Text('Giỏ hàng'),
            icon: Icon(
              FontAwesomeIcons.cartShopping,
              size: kDefaultIconSize18,
            ),
          ),
          SalomonBottomBarItem(
            title: Text('Tài khoản'),
            icon: Icon(
              FontAwesomeIcons.solidUser,
              size: kDefaultIconSize18,
            ),
          ),
        ],
      ),
    );
  }
}
