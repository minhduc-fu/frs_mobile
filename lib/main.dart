import 'package:demo_frs_app/core/helper/local_storage_helper.dart';
import 'package:demo_frs_app/representation/screens/FoodScreen/shop.dart';
import 'package:demo_frs_app/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

import 'core/constants/color_constants.dart';
import 'representation/screens/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // khởi tạo Hive
  await Hive.initFlutter();
  // khởi tạo LoalStorageHelper
  await LocalStorageHelper.initLocalStorageHelper();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // ẩn status bar
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

  runApp(
    ChangeNotifierProvider(
      create: (context) => Shop(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: routes,
      debugShowCheckedModeBanner: false,
      title: 'FRS app',
      theme: ThemeData(
        iconTheme: IconThemeData(color: ColorPalette.primaryColor),
        scaffoldBackgroundColor: ColorPalette.backgroundScaffoldColor,
        // backgroundColor: ColorPalette.backgroundScaffoldColor,
        colorScheme: ColorScheme.fromSeed(
            seedColor: ColorPalette.backgroundScaffoldColor),
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}
