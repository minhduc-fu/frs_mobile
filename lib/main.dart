import 'package:demo_frs_app/core/constants/dismension_constants.dart';
import 'package:demo_frs_app/core/constants/textstyle_constants.dart';
import 'package:demo_frs_app/routes.dart';
import 'package:demo_frs_app/services/authprovider.dart';
import 'package:demo_frs_app/utils/local_storage_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'core/constants/color_constants.dart';
import 'representation/screens/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // khởi tạo Hive
  await Hive.initFlutter();
  // khởi tạo LoalStorageHelper
  await LocalStorageHelper.initLocalStorageHelper();
  await LocalStorageHelper.initSearchBox();
  await Hive.openBox('userBox');
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
// Khởi tạo định dạng ngôn ngữ "vi_VN"
  await initializeDateFormatting('vi_VN', null);

  // ẩn status bar
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

  runApp(
    // cung cấp 1 provider cho toàn bộ ứng dụng hoặc 1 phần của ứng dụng
    ChangeNotifierProvider(
      create: (context) =>
          AuthProvider(), // tạo một phiên bản mới của AuthProvider
      // child là MyApp nghĩa là có thể truy cập AuthProvider từ bất kỳ widget nào bên trong MyApp
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: routes,
      debugShowCheckedModeBanner: false,
      title: 'FRS app',
      theme: ThemeData(
        textTheme: TextTheme(bodyLarge: TextStyles.defaultStyle),
        iconTheme: IconThemeData(
            color: ColorPalette.primaryColor, size: kDefaultIconSize18),
        scaffoldBackgroundColor: ColorPalette.backgroundScaffoldColor,
        // backgroundColor: ColorPalette.backgroundScaffoldColor,
        colorScheme: ColorScheme.fromSeed(
            primary: ColorPalette.primaryColor,
            seedColor: ColorPalette.backgroundScaffoldColor),
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}
