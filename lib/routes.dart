import 'package:flutter/material.dart';
import 'package:frs_mobile/representation/screens/about_frs/about_us.dart';
import 'package:frs_mobile/representation/screens/about_frs/privacy_policy.dart';
import 'package:frs_mobile/representation/screens/about_frs/terms_of_service.dart';
import 'package:frs_mobile/representation/screens/cart/buy_cart_screen.dart';
import 'package:frs_mobile/representation/screens/customer/account/address/address_screen.dart';
import 'package:frs_mobile/representation/screens/customer/account/address/new_address_screen.dart';
import 'package:frs_mobile/representation/screens/customer/account/contact_support/contact_support_screen.dart';
import 'package:frs_mobile/representation/screens/customer/account/orderHistoryCustomer/rental_order_history/screens/confirm_order_rent_screen.dart';
import 'package:frs_mobile/representation/screens/notification_screen.dart';
import 'package:frs_mobile/representation/screens/wallet/wallet_screen.dart';
import 'representation/screens/guest/account_screen.dart';
import 'representation/screens/cart/main_cart_screen.dart';
import 'representation/screens/chat_screen.dart';
import 'representation/screens/customer/account/account_customer_screen.dart';
import 'representation/screens/customer/account/orderHistoryCustomer/main_order_history_screen.dart';
import 'representation/screens/customer/account/profile/customer_profile_screen.dart';
import 'representation/screens/customer/customer_main_screen.dart';
import 'representation/screens/favorite/favorite_screen.dart';
import 'representation/screens/home_screen_demo.dart';
import 'representation/screens/intro_screen.dart';
import 'representation/screens/login_or_register/auth_screen.dart';
import 'representation/screens/login_or_register/forgot_password_screen.dart';
import 'representation/screens/login_or_register/login_or_register_screen.dart';
import 'representation/screens/login_or_register/login_screen.dart';
import 'representation/screens/login_or_register/register_screen.dart';
import 'representation/screens/main_app.dart';
import 'representation/screens/productowner_screen/productowner_main_screen.dart';
import 'representation/screens/product_detail/select_date_screen.dart';
import 'representation/screens/splash_screen.dart';

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
  HomeScreenDemo.routeName: (context) => const HomeScreenDemo(),
  FavoriteScreen.routeName: (context) => const FavoriteScreen(),
  ChatScreen.routeName: (context) => const ChatScreen(),
  AccountScreen.routeName: (context) => const AccountScreen(),
  AccountCustomerScreen.routeName: (context) => const AccountCustomerScreen(),
  ForgotPasswordScreen.routeName: (context) => ForgotPasswordScreen(),
  CustomerMainScreen.routeName: (context) => const CustomerMainScreen(),
  ProductOwnerMainScreen.routeName: (context) => const ProductOwnerMainScreen(),
  MainCartScreen.routeName: (context) => const MainCartScreen(),
  MainOrderHistoryScreen.routeName: (context) => const MainOrderHistoryScreen(),
  CustomerProfileScreen.routeName: (context) => const CustomerProfileScreen(),
  SelectDateScreen.routeName: (context) => SelectDateScreen(),
  WalletScreen.routeName: (context) => WalletScreen(),
  AddressScreen.routeName: (context) => AddressScreen(),
  NewAddressScreen.routeName: (context) => NewAddressScreen(),
  BuyCartScreen.routeName: (context) => BuyCartScreen(),
  ConfirmOrderRentScreen.routeName: (context) => ConfirmOrderRentScreen(),
  PrivacyPolicy.routeName: (context) => PrivacyPolicy(),
  TermsOfService.routeName: (context) => TermsOfService(),
  AboutUs.routeName: (context) => AboutUs(),
  ContactSupportScreen.routeName: (context) => ContactSupportScreen(),
  NotificationScreen.routeName: (context) => NotificationScreen(),
};
