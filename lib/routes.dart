import 'package:flutter/material.dart';
import 'package:frs_mobile/representation/screens/wallet/wallet_screen.dart';
import 'representation/screens/FoodScreen/cart_food_screen.dart';
import 'representation/screens/FoodScreen/menu_screen.dart';
import 'representation/screens/guest/account_screen.dart';
import 'representation/screens/cart/main_cart_screen.dart';
import 'representation/screens/chat_screen.dart';
import 'representation/screens/customer/account/account_screen_true.dart';
import 'representation/screens/customer/account/orderHistoryCustomer/main_order_history_screen.dart';
import 'representation/screens/customer/account/profile/customer_profile_screen.dart';
import 'representation/screens/customer/customer_main_screen.dart';
import 'representation/screens/favorite_screen.dart';
import 'representation/screens/home_screen.dart';
import 'representation/screens/home_screen_demo.dart';
import 'representation/screens/intro_screen.dart';
import 'representation/screens/login_or_register/auth_screen.dart';
import 'representation/screens/login_or_register/forgot_password_screen.dart';
import 'representation/screens/login_or_register/login_or_register_screen.dart';
import 'representation/screens/login_or_register/login_screen.dart';
import 'representation/screens/login_or_register/register_screen.dart';
import 'representation/screens/main_app.dart';
import 'representation/screens/productowner_screen/productowner_main_screen.dart';
import 'representation/screens/select_date_screen.dart';
import 'representation/screens/splash_screen.dart';

// Map key:value
// final Map<String, WidgetBuilder> routes = {
//   SplashScreen.routeName: (context) => const SplashScreen(),
//   IntroScreen.routeName: (context) => const IntroScreen(),
//   LoginScreen.routeName: (context) => LoginScreen(
//         onTap: () {},
//       ),
//   AuthScreen.routeName: (context) => const AuthScreen(),
//   HomeScreen.routeName: (context) => HomeScreen(),
//   LoginOrRegisterScreen.routeName: (context) => LoginOrRegisterScreen(),
//   RegisterScreen.routeName: (context) => RegisterScreen(
//         onTap: () {},
//       ),
// };
final Map<String, WidgetBuilder> routes = {
  SplashScreen.routeName: (context) => const SplashScreen(),
  IntroScreen.routeName: (context) => const IntroScreen(),
  MainApp.routeName: (context) => const MainApp(),
  LoginScreen.routeName: (context) => LoginScreen(
        onTap: () {},
      ),
  AuthScreen.routeName: (context) => const AuthScreen(),
  LoginOrRegisterScreen.routeName: (context) => const LoginOrRegisterScreen(),
  RegisterScreen.routeName: (context) => RegisterScreen(
        onTap: () {},
      ),
  HomeScreen.routeName: (context) => const HomeScreen(),
  HomeScreenDemo.routeName: (context) => const HomeScreenDemo(),
  FavoriteScreen.routeName: (context) => const FavoriteScreen(),
  ChatScreen.routeName: (context) => const ChatScreen(),

  AccountScreen.routeName: (context) => const AccountScreen(),
  AccountScreenTrue.routeName: (context) => const AccountScreenTrue(),
  ForgotPasswordScreen.routeName: (context) => ForgotPasswordScreen(),
  //
  MenuScreen.routeName: (context) => const MenuScreen(),
  CartFoodScreen.routeName: (context) => const CartFoodScreen(),
  CustomerMainScreen.routeName: (context) => const CustomerMainScreen(),
  ProductOwnerMainScreen.routeName: (context) => const ProductOwnerMainScreen(),
  MainCartScreen.routeName: (context) => const MainCartScreen(),
  MainOrderHistoryScreen.routeName: (context) => const MainOrderHistoryScreen(),
  CustomerProfileScreen.routeName: (context) => const CustomerProfileScreen(),

  SelectDateScreen.routeName: (context) => SelectDateScreen(),
  WalletScreen.routeName: (context) => WalletScreen(),
  // FoodDetailsScreen.routeName: (context) => const FoodDetailsScreen( food: ),
};
