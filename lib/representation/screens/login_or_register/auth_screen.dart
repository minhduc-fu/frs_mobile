import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../main_app.dart';
import 'login_or_register_screen.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  static const String routeName = '/auth_screen';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // StreamBuilder<User?>() cho phép theo dõi và xử lý dữ liệu từ stream: FirebaseAuth.instance.authStateChanges()
      // User là kiểu dữ liệu được import từ Firebase Authentication
      // User? thì ? nghĩa là User có thể null, null là User chưa đăng nhập
      // stream: FirebaseAuth.instance.authStateChanges() theo dõi sự thay đổi trạng thái xác thực của người  dùng
      // FirebaseAuth.instance là tạo 1 instance của FirebaseAuth
      // authStateChanges() là  1 method của FirebaseAuth.instance và nó trả về 1 Stream<User?>
      // builder: (context, snapshot). Hàm này sẽ được gọi mỗi khi dữ liệu trong stream thay  đổi. Nó nhận vào context và snapshot.
      // Nó kiểm tra xem User đăng nhập hay chưa
      // Nếu snapshot hasData là true, tức là có dữ liệu, nghĩa là user đã đăng nhập thì builder sẽ trả về HomeScreen
      // Nếu snapshot hasData là false, tức là chưa có dữ liệu, nghĩa là user chưa đăng nhập
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          // user is logged in
          if (snapshot.hasData) {
            return MainApp();
          }
          // user isn't logged in
          else {
            return LoginOrRegisterScreen();
          }
        },
      ),
    );
  }
}
