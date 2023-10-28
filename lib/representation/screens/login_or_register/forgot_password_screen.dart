import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../core/constants/my_textfield.dart';
import '../../../core/constants/textstyle_constants.dart';
import '../../widgets/app_bar_main.dart';
import '../../widgets/button_widget.dart';

class ForgotPasswordScreen extends StatelessWidget {
  ForgotPasswordScreen({super.key});
  static const String routeName = '/forgot_password_screen';

  final TextEditingController emailForgot = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return AppBarMain(
      leading: GestureDetector(),
      titleAppbar: 'Forgot Password',
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                alignment: AlignmentDirectional.centerEnd,
                children: [
                  MyTextField(
                    controller: emailForgot,
                    hintText: 'Email',
                    obscureText: false,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 35),
                    child: Icon(
                      FontAwesomeIcons.solidEnvelope,
                      size: 18,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 25,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Text(
                  textAlign: TextAlign.center,
                  'Enter your email and we will send you a link to reset your password',
                  style: TextStyles.h5,
                ),
              ),
              SizedBox(
                height: 25,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: ButtonWidget(
                  title: 'Confirm',
                  size: 22,
                  height: 70,
                  onTap: () {},
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
