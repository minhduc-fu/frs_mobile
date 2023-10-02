import 'package:demo_frs_app/core/constants/color_constants.dart';
import 'package:demo_frs_app/core/constants/dismension_constants.dart';
import 'package:demo_frs_app/representation/screens/AccountScreen/account_screen.dart';
import 'package:demo_frs_app/representation/screens/AccountScreen/account_screen_true.dart';
import 'package:demo_frs_app/representation/screens/FoodScreen/cart_food_screen.dart';
import 'package:demo_frs_app/representation/screens/FoodScreen/menu_screen.dart';

import 'package:demo_frs_app/representation/screens/chat_screen.dart';
import 'package:demo_frs_app/representation/screens/favorite_screen.dart';
import 'package:demo_frs_app/representation/screens/home_screen_food.dart';
import 'package:demo_frs_app/representation/screens/login_or_register/register_screen.dart';
// import 'package:demo_frs_app/representation/screens/login_screen.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  static const String routeName = '/main_app';

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  int _currentIndex = 0;
  // final user = FirebaseAuth.instance.currentUser!;
  User? user;

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser;
  }

  // method logout
  void logout() {
    emailController.text = "";
    passwordController.text = "";
    confirmPasswordController.text = "";
    FirebaseAuth.instance.signOut();
    setState(() {
      user = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: [
          FavoriteScreen(),
          ChatScreen(),
          // HomeScreen(),
          // MenuScreen(),
          HomeScreen(),
          CartFoodScreen(),
          // AccountScreen(),
          AccountScreen(),
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
        unselectedItemColor: ColorPalette.hideColor,
        margin: EdgeInsets.symmetric(
            horizontal: kMediumPadding, vertical: kDefaultPadding),
        items: [
          SalomonBottomBarItem(
            title: Text('Yêu thích'),
            icon: Icon(
              FontAwesomeIcons.solidHeart,
              size: kDefaultIconSize,
            ),
          ),
          SalomonBottomBarItem(
            title: Text('Tin nhắn'),
            icon: Icon(
              FontAwesomeIcons.solidMessage,
              size: kDefaultIconSize,
            ),
          ),
          SalomonBottomBarItem(
            title: Text('Trang chủ'),
            icon: Icon(
              FontAwesomeIcons.house,
              size: kDefaultIconSize,
            ),
          ),
          SalomonBottomBarItem(
            title: Text('Giỏ hàng'),
            icon: Icon(
              FontAwesomeIcons.cartShopping,
              size: kDefaultIconSize,
            ),
          ),
          SalomonBottomBarItem(
            title: Text('Tài khoản'),
            icon: Icon(
              FontAwesomeIcons.solidUser,
              size: kDefaultIconSize,
            ),
          ),
        ],
      ),
    );
  }
}
