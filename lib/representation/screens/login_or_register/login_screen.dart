import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:frs_mobile/core/constants/my_textformfield.dart';
import 'package:frs_mobile/services/auth_service.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/color_constants.dart';
import '../../../core/constants/dismension_constants.dart';

import '../../../core/constants/textstyle_constants.dart';
import '../../../models/user_model.dart';
import '../../../services/authentication_service.dart';
import '../../../services/authprovider.dart';
import '../../../utils/asset_helper.dart';
import '../../../utils/dialog_helper.dart';
import '../../../utils/image_helper.dart';
import '../../widgets/button_widget.dart';
import '../customer/customer_main_screen.dart';
import '../productowner_screen/productowner_main_screen.dart';
import 'forgot_password_screen.dart';
import '../../../api/firebase_api.dart';

class LoginScreen extends StatefulWidget {
  final Function()? onTap;
  const LoginScreen({super.key, required this.onTap});

  static const String routeName = '/login_screen';

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

bool _showPass = false;

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController passwordController = new TextEditingController();
  final TextEditingController emailController = new TextEditingController();
  User? user;
  @override
  void initState() {
    super.initState();
    // user = FirebaseAuth.instance.currentUser;
    // if (user == null) {
    //   emailController.text = "";
    //   passwordController.text = "";
    // }
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
  // void signInClicked() async {
  //   //show loading circle
  //   showDialog(
  //     context: context,
  //     builder: (context) {
  //       return Center(
  //         child: CircularProgressIndicator(
  //           color: ColorPalette.primaryColor,
  //         ),
  //       );
  //     },
  //   );
  //   // try sign in
  //   try {
  //     await FirebaseAuth.instance.signInWithEmailAndPassword(
  //         email: emailController.text, password: passwordController.text);
  //     // login thành công
  //     Navigator.pop(context);
  //   } on FirebaseAuthException catch (e) {
  //     // đóng hộp thoại khi xảy ra lỗi
  //     Navigator.pop(context);
  //     //show error message
  //     showErrorMsg(e.code);
  //     // Wrong email
  //     // if (e.code == 'user-not-found') {
  //     //   // email không tồn tại
  //     //   wrongEmailMessage();
  //     //   // Wrong password
  //     // } else if (e.code == 'wrong-password') {
  //     //   // sai password
  //     //   wrongPasswordMessage();
  //     // } else if (e.code == 'invalid-email') {
  //     //   invalidEmailMessage();
  //     // } else {
  //     //   // xử lý các lỗi khác
  //     //   print("Lỗi đăng nhập ${e.code}");
  //     // }
  //   }
  // }

  void signInClicked() async {
    if (emailController.text.isEmpty) {
      showCustomDialog(context, 'Lỗi', 'Bạn chưa nhập "Email".', true);
    } else if (passwordController.text.isEmpty) {
      showCustomDialog(context, 'Lỗi', 'Bạn chưa nhập "Password".', true);
    } else {
      if (validateEmail(emailController.text) == null &&
          validatePassword(passwordController.text) == null) {
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
        try {
          final response = await AuthenticationService.logIn(
              emailController.text, passwordController.text);
          Navigator.pop(context);
          if (response != null) {
            final userModel = UserModel.fromJson(response);
            var box = Hive.box('userBox');
            box.put('user', json.encode(userModel.toJson()));
            final authProvider =
                Provider.of<AuthProvider>(context, listen: false);
            authProvider.setUser(userModel);

            await FirebaseApi.initNotifications();

            if (userModel.role.roleName == 'Customer') {
              Navigator.of(context).pushNamed(CustomerMainScreen.routeName);
            } else if (userModel.role.roleName == "ProductOwner") {
              Navigator.of(context).pushNamed(ProductOwnerMainScreen.routeName);
            }
          } else {
            showCustomDialog(
                context, 'Lỗi', 'Xin lỗi! Đăng nhập thất bại.', true);
          }
        } catch (e) {
          showCustomDialog(context, 'Lỗi', e.toString(), true);
        }
      }
    }
  }

  void onToggleShowPass() {
    setState(() {
      _showPass = !_showPass;
    });
  }

  //ít nhất một ký tự trước và sau ký tự @,
  //có một dấu . sau ký tự @,
  //tên miền có ít nhất hai ký tự.
  //Cho phép sử dụng các ký tự đặc biệt như _, %, +, và - trong phần tên người dùng.
  String? validateEmail(String? email) {
    if (email == null || email.isEmpty) {
      return 'Vui lòng nhập Email';
    }

    String emailPattern = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
    RegExp regex = RegExp(emailPattern);

    if (!regex.hasMatch(email)) {
      return 'Email không hợp lệ';
    }

    return null;
  }

  String? validatePassword(String? password) {
    if (password == null || password.isEmpty) {
      return 'Vui lòng nhập Password';
    }

    if (password.contains(',')) {
      return 'Không được chứa dấu ","';
    }

    if (password.contains(' ')) {
      return 'Mật khẩu không được chứa khoảng trắng';
    }

    return null;
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
                  MyTextFormField(
                    controller: emailController,
                    hintText: 'Email',
                    validator: validateEmail,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    prefixIcon: Icon(
                      FontAwesomeIcons.solidEnvelope,
                      size: kDefaultIconSize18,
                      color: ColorPalette.primaryColor,
                    ),
                  ),
                  SizedBox(height: 10),

                  // password textField
                  MyTextFormField(
                    controller: passwordController,
                    hintText: 'Password',
                    obscureText: !_showPass,
                    validator: validatePassword,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    prefixIcon: Icon(
                      FontAwesomeIcons.key,
                      size: kDefaultIconSize18,
                      color: ColorPalette.primaryColor,
                    ),
                    suffixIcon: GestureDetector(
                      onTap: onToggleShowPass,
                      child: Icon(
                        _showPass
                            ? FontAwesomeIcons.eyeSlash
                            : FontAwesomeIcons.eye,
                        size: kDefaultIconSize18,
                        color: ColorPalette.primaryColor,
                      ),
                    ),
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
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 25),

                  // sign in button
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
                  SizedBox(height: 20),

                  // google  sign in buttons
                  GestureDetector(
                    onTap: () => AuthService().signInWithGoogle(),
                    child:
                        ImageHelper.loadFromAsset(AssetHelper.imageLogoGoogle),
                  ),
                  //   onTap: () => AuthService().signInWithGoogle(),
                  SizedBox(height: 20),

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
