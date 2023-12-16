// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

import '../../../core/constants/color_constants.dart';
import '../../../core/constants/dismension_constants.dart';
import '../cart/main_cart_screen.dart';
import '../chat_screen.dart';
import '../favorite/favorite_screen.dart';
import '../home_screen_demo.dart';
import '../login_or_register/register_screen.dart';
import 'account/account_customer_screen.dart';

class CustomerMainScreen extends StatefulWidget {
  const CustomerMainScreen({super.key});

  static const String routeName = '/customer_main_screen';

  @override
  State<CustomerMainScreen> createState() => _CustomerMainScreen();
}

class _CustomerMainScreen extends State<CustomerMainScreen> {
  int _currentIndex = 0;
  // final user = FirebaseAuth.instance.currentUser!;
  // User? user;

  @override
  void initState() {
    super.initState();
    // user = FirebaseAuth.instance.currentUser;
  }

  // method logout
  void logout() {
    emailController.text = "";
    passwordController.text = "";
    confirmPasswordController.text = "";
    // FirebaseAuth.instance.signOut();
    // setState(() {
    //   user = null;
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: [
          HomeScreenDemo(),
          FavoriteScreen(),
          ChatScreen(),
          // MenuScreen(),
          MainCartScreen(),
          // CartFoodScreen(),
          AccountCustomerScreen(),
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

        // margin: EdgeInsets.symmetric(
        //     horizontal: kMediumPadding24, vertical: kDefaultPadding16),
        items: [
          SalomonBottomBarItem(
            title: Text('Trang chủ'),
            icon: Icon(
              FontAwesomeIcons.house,
              size: kDefaultIconSize18,
            ),
          ),
          SalomonBottomBarItem(
            title: Text('Yêu thích'),
            icon: Icon(
              FontAwesomeIcons.solidHeart,
              size: kDefaultIconSize18,
            ),
          ),
          SalomonBottomBarItem(
            title: Text('Tin nhắn'),
            icon: Icon(
              FontAwesomeIcons.solidMessage,
              size: kDefaultIconSize18,
            ),
          ),
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
