import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:frs_mobile/representation/screens/productowner_screen/productowner_main_screen.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

import '../../core/constants/color_constants.dart';
import '../../models/user_model.dart';
import '../../services/authprovider.dart';
import '../../utils/asset_helper.dart';
import '../../utils/image_helper.dart';
import '../../utils/local_storage_helper.dart';
import 'customer/customer_main_screen.dart';
import 'intro_screen.dart';
import 'main_app.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  static const String routeName = '/splash_screen';
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  // Khi vào SplashScreen thì nó sẽ vào initState của SplashScreen đầu tiên
  // render ra giao diện trong 3s và sau đó Navigator.of.pushNamed sang màn LoginScreen
  @override
  void initState() {
    super.initState();
    // redirectIntroScreen();
    checkUserStatus();
  }

  void checkUserStatus() async {
    final ignoreIntroScreen =
        LocalStorageHelper.getValue('ignoreIntroScreen') as bool?;

    await Future.delayed(const Duration(seconds: 3));
    if (ignoreIntroScreen != null && ignoreIntroScreen) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      var box = Hive.box('userBox');
      if (box.containsKey('user')) {
        final userMap = box.get('user');

        final userModel = UserModel.fromJson(json.decode(userMap));
        authProvider.setUser(userModel);
        if (userModel.role.roleName == 'Customer') {
          Navigator.of(context).pushNamed(CustomerMainScreen.routeName);
        } else if (userModel.role.roleName == 'ProductOwner') {
          Navigator.of(context).pushNamed(ProductOwnerMainScreen.routeName);
        }
      } else {
        // Chuyển đến màn hình MainApp nếu không có thông tin người dùng
        Navigator.of(context).pushNamed(MainApp.routeName);
      }
    } else {
      LocalStorageHelper.setValue('ignoreIntroScreen', true);
      LocalStorageHelper.closeBox();
      Navigator.of(context).pushNamed(IntroScreen.routeName);
    }
  }

  // void checkUserStatus() async {
  //   final ignoreIntroScreen =
  //       LocalStorageHelper.getValue('ignoreIntroScreen') as bool?;

  //   await Future.delayed(const Duration(seconds: 3));
  //   if (ignoreIntroScreen != null && ignoreIntroScreen) {
  //     final authProvider = Provider.of<AuthProvider>(context, listen: false);
  //     bool isLoggedIn = LocalStorageHelper.getValue('isLoggedIn') ?? false;
  //     if (isLoggedIn) {
  //       // UserModel? user = await LocalStorageHelper.getValue('userModel');
  //       // final  UserModel? user = UserModel.fromJson(LocalStorageHelper.getValue('userModel'));
  //       final userJson = LocalStorageHelper.getValue('userModel');
  //       if (userJson != null) {
  //         final userModel =
  //             UserModel.fromJson(json.decode(userJson.cast<String, dynamic>()));
  //         authProvider.setUser(userModel);
  //         if (userModel.role.roleName == 'Customer') {
  //           Navigator.of(context).pushNamed(CustomerMainScreen.routeName);
  //         } else if (userModel.role.roleName == 'ProductOwner') {
  //           Navigator.of(context).pushNamed(ProductOwnerMainScreen.routeName);
  //         }
  //       }
  //       // final UserModel user = UserModel.fromJson(userJson);
  //     } else {
  //       Navigator.of(context).pushNamed(MainApp.routeName);
  //     }
  //   } else {
  //     LocalStorageHelper.setValue('ignoreIntroScreen', true);
  //     LocalStorageHelper.closeBox();
  //     Navigator.of(context).pushNamed(IntroScreen.routeName);
  //   }
  // }

  void redirectIntroScreen() async {
    final ignoreIntroScreen =
        LocalStorageHelper.getValue('ignoreIntroScreen') as bool?;

    await Future.delayed(const Duration(seconds: 3));

    // Navigator.pushReplacementNamed(context, LoginScreen.routeName);
    // Navigator.of(context).pushNamed(LoginScreen.routeName);
    // sang màn AuthScreen
    // User chưa Login thì return LoginScreen()
    // User đã Login thì return HomePage()
    // Navigator.of(context).pushNamed(AuthScreen.routeName);

    // nếu ignoreIntroScreen != null và bằng true thì
    if (ignoreIntroScreen != null && ignoreIntroScreen) {
      Navigator.of(context).pushNamed(MainApp.routeName);
    } else {
      // khi nó nhảy vào IntroScreen thì sẽ setValue cho ignoreIntroScreen này = true
      // vì khi User lần đầu dùng app thì ignoreIntroScreen = false
      LocalStorageHelper.setValue('ignoreIntroScreen', true);
      LocalStorageHelper.closeBox();

      Navigator.of(context).pushNamed(IntroScreen.routeName);
    }
  }

  // @override
  // void dispose() {
  //   super.dispose();
  //   SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
  //       overlays: SystemUiOverlay.values);
  // }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
              // gradient: LinearGradient(colors: [
              //   Colors.black.withOpacity(0.4),
              //   Colors.white.withOpacity(0.5)
              // ], begin: Alignment.topLeft, end: Alignment.bottomRight),
              color: ColorPalette.primaryColor),
          // child: ImageHelper.loadFromAsset(AssetHelper.imageBackGroundSplash,
          //     fit: BoxFit.fitWidth),
        ),
        // ImageHelper.loadFromAsset(AssetHelper.imageCircleSplash),
        ImageHelper.loadFromAsset(AssetHelper.imageSplash, fit: BoxFit.cover),
        // CircularProgressIndicator(color: Colors.white),
        SpinKitPulse(
          color: Colors.black,
          size: 400,
        ),
      ],
    );
  }
}
