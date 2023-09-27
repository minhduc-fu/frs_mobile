import 'package:demo_frs_app/core/constants/color_constants.dart';
import 'package:demo_frs_app/core/helper/asset_helper.dart';
import 'package:demo_frs_app/core/helper/image_helper.dart';
import 'package:demo_frs_app/core/helper/local_storage_helper.dart';
import 'package:demo_frs_app/representation/screens/login_or_register/auth_screen.dart';
import 'package:demo_frs_app/representation/screens/main_app.dart';
import 'package:demo_frs_app/representation/screens/intro_screen.dart';
// import 'package:demo_frs_app/representation/screens/login_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

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
    // ẩn thanh ngày giờ
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    redirectIntroScreen();
  }

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
          size: 500,
        ),
      ],
    );
  }
}
