import 'package:demo_frs_app/representation/screens/login_or_register/login_screen.dart';
import 'package:demo_frs_app/representation/screens/login_or_register/register_screen.dart';
import 'package:flutter/material.dart';

class LoginOrRegisterScreen extends StatefulWidget {
  const LoginOrRegisterScreen({super.key});

  static const String routeName = '/login_or_register_screen';

  @override
  State<LoginOrRegisterScreen> createState() => _LoginOrRegisterScreenState();
}

class _LoginOrRegisterScreenState extends State<LoginOrRegisterScreen> {
// initially show login screen
  bool showLoginScreen = true;

// toggle between login and register screen
  void toggleScreen() {
    setState(
      () {
        showLoginScreen = !showLoginScreen;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (showLoginScreen) {
      return LoginScreen(
        onTap: toggleScreen,
      );
    } else {
      return RegisterScreen(
        onTap: toggleScreen,
      );
    }
  }
}
