import 'package:demo_frs_app/core/constants/color_constants.dart';
import 'package:demo_frs_app/core/constants/dismension_constants.dart';
import 'package:demo_frs_app/core/constants/my_textfield.dart';
import 'package:demo_frs_app/core/constants/square_tile.dart';
import 'package:demo_frs_app/core/constants/textstyle_constants.dart';
import 'package:demo_frs_app/core/helper/asset_helper.dart';
import 'package:demo_frs_app/core/helper/image_helper.dart';
import 'package:demo_frs_app/representation/screens/login_or_register/forgot_password_screen.dart';
import 'package:demo_frs_app/representation/widgets/button_widget.dart';
import 'package:demo_frs_app/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class LoginScreen extends StatefulWidget {
  final Function()? onTap;
  const LoginScreen({super.key, required this.onTap});
  // text editing controllers
  // final passwordController = TextEditingController();
  // final userNameController = TextEditingController();
  static const String routeName = '/login_screen';

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

// text editing controllers
// final passwordController = TextEditingController();
// final emailController = TextEditingController();
final TextEditingController passwordController = new TextEditingController();
final TextEditingController emailController = new TextEditingController();

bool _showPass = false;

class _LoginScreenState extends State<LoginScreen> {
  User? user;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      emailController.text = "";
      passwordController.text = "";
    }
  }
  // sign user in method
// void signInClicked() {
//   if(emailController.text.length < 6  || !emailController.text.contains("@gmail.com")){
//     emailInvalid = true;
//   }else{
//     emailInvalid = false;
//   }
//   if(passwordController.text.length < 6 ){
//     passwordInvalid = true;
//   }else{
//     passwordInvalid = false;
//   }

  // if(!emailInvalid && !passwordInvalid){
  //   Navigator.of(context).pushNamed(routeName);
  // }
// }

  //Sign in
  void signInClicked() async {
    //show loading circle
    showDialog(
      context: context,
      builder: (context) {
        return Center(
          child: CircularProgressIndicator(
            color: ColorPalette.primaryColor,
          ),
        );
      },
    );
    // try sign in
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text, password: passwordController.text);
      // login thành công
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      // đóng hộp thoại khi xảy ra lỗi
      Navigator.pop(context);
      //show error message
      showErrorMsg(e.code);

      // Wrong email
      // if (e.code == 'user-not-found') {
      //   // email không tồn tại
      //   wrongEmailMessage();
      //   // Wrong password
      // } else if (e.code == 'wrong-password') {
      //   // sai password
      //   wrongPasswordMessage();
      // } else if (e.code == 'invalid-email') {
      //   invalidEmailMessage();
      // } else {
      //   // xử lý các lỗi khác
      //   print("Lỗi đăng nhập ${e.code}");
      // }
    }
  }

  // error message to user
  void showErrorMsg(String msg) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: ColorPalette.secondColor,
          title: Center(
            child: Text(
              msg,
              style: TextStyle(color: Colors.white),
            ),
          ),
        );
      },
    );
  }

  // Show and Hide password
  void onToggleShowPass() {
    setState(() {
      _showPass = !_showPass;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // logo
                  SizedBox(height: 25),
                  Icon(
                    color: ColorPalette.primaryColor,
                    FontAwesomeIcons.rightToBracket,
                    size: 50,
                  ),
                  SizedBox(height: 25),
                  Container(
                    alignment: Alignment.centerLeft,
                    child: Text("Đăng nhập", style: TextStyles.h4.bold),
                  ),
                  SizedBox(height: 5),

                  // Enter your account detail or use Email Google
                  Container(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Hãy nhập chi tiết tài khoản của bạn hoặc sử dụng Email Google",
                      style: TextStyles.h5.setColor(ColorPalette.textHide),
                    ),
                  ),
                  SizedBox(height: 25),

                  // email textField
                  MyTextField(
                    prefixIcon: Icon(
                      FontAwesomeIcons.solidEnvelope,
                      size: kDefaultIconSize,
                      color: ColorPalette.primaryColor,
                    ),
                    messageError: 'Email không hợp lệ',
                    controller: emailController,
                    hintText: 'Email',
                    obscureText: false,
                  ),
                  SizedBox(height: 10),

                  // password textField
                  MyTextField(
                    prefixIcon: Icon(
                      FontAwesomeIcons.key,
                      size: kDefaultIconSize,
                      color: ColorPalette.primaryColor,
                    ),
                    suffixIcon: GestureDetector(
                      onTap: onToggleShowPass,
                      child: Icon(
                        _showPass
                            ? FontAwesomeIcons.eyeSlash
                            : FontAwesomeIcons.eye,
                        size: kDefaultIconSize,
                        color: ColorPalette.primaryColor,
                      ),
                    ),
                    messageError: 'Password không hợp lệ',
                    controller: passwordController,
                    hintText: 'Password',
                    obscureText: !_showPass,
                  ),
                  SizedBox(height: 10),

                  // forgot password?
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context)
                              .pushNamed(ForgotPasswordScreen.routeName);
                        },
                        child: Text(
                          'Quên mật khẩu?',
                          style: TextStyle(
                              fontSize: 16,
                              decoration: TextDecoration.underline,
                              decorationThickness: 0.8,
                              decorationColor: Colors.blue,
                              color: Colors.blue,
                              fontFamily: FontFamilyRoboto.roboto,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 25),

                  // sign in button
                  // MyButton(action: 'Sign In', onTap: signInClicked),
                  ButtonWidget(
                    size: 22,
                    height: 70,
                    title: 'Đăng nhập',
                    onTap: signInClicked,
                  ),
                  SizedBox(height: 30),

                  // or continue with
                  Row(
                    children: [
                      Expanded(
                        child: Divider(
                          thickness: 0.5,
                          color: ColorPalette.primaryColor,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: Text(
                          'Hoặc tiếp tục với',
                          style: TextStyles.h5,
                        ),
                      ),
                      Expanded(
                        child: Divider(
                          thickness: 0.5,
                          color: ColorPalette.primaryColor,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 40),

                  // google  sign in buttons
                  SquareTile(
                    onTap: () => AuthService().signInWithGoogle(),
                    child:
                        ImageHelper.loadFromAsset(AssetHelper.imageLogoGoogle),
                  ),
                  SizedBox(height: 40),

                  // Dont't have an account? register now
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Bạn chưa có tài khoản?",
                        style: TextStyles.h5,
                      ),
                      SizedBox(width: 10),
                      GestureDetector(
                        onTap: widget.onTap,
                        // onTap: () {
                        //   Navigator.of(context)
                        //       .pushNamed(RegisterScreen.routeName);
                        // },
                        child: Text(
                          'Đăng ký ngay.',
                          style: TextStyles.h5.bold.setColor(Colors.blue),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
