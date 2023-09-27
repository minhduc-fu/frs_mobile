import 'package:demo_frs_app/representation/screens/AccountScreen/account_screen.dart';
import 'package:demo_frs_app/representation/screens/AccountScreen/account_screen_true.dart';
import 'package:demo_frs_app/representation/screens/FoodScreen/cart_food_screen.dart';

import 'package:demo_frs_app/representation/screens/FoodScreen/menu_screen.dart';

import 'package:demo_frs_app/representation/screens/chat_screen.dart';
import 'package:demo_frs_app/representation/screens/favorite_screen.dart';
import 'package:demo_frs_app/representation/screens/login_or_register/auth_screen.dart';
import 'package:demo_frs_app/representation/screens/home_screen.dart';
import 'package:demo_frs_app/representation/screens/login_or_register/forgot_password_screen.dart';
import 'package:demo_frs_app/representation/screens/login_or_register/login_or_register_screen.dart';
import 'package:demo_frs_app/representation/screens/login_or_register/login_screen.dart';
import 'package:demo_frs_app/representation/screens/login_or_register/register_screen.dart';
import 'package:demo_frs_app/representation/screens/main_app.dart';
import 'package:demo_frs_app/representation/screens/intro_screen.dart';
import 'package:demo_frs_app/representation/screens/splash_screen.dart';
import 'package:flutter/material.dart';

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
  FavoriteScreen.routeName: (context) => const FavoriteScreen(),
  ChatScreen.routeName: (context) => const ChatScreen(),

  AccountScreen.routeName: (context) => const AccountScreen(),
  AccountScreenTrue.routeName: (context) => const AccountScreenTrue(),
  ForgotPasswordScreen.routeName: (context) => ForgotPasswordScreen(),
  //
  MenuScreen.routeName: (context) => const MenuScreen(),
  CartFoodScreen.routeName: (context) => const CartFoodScreen(),
  // FoodDetailsScreen.routeName: (context) => const FoodDetailsScreen( food: ),
};
