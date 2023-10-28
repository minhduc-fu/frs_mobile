import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../core/constants/color_constants.dart';
import '../../../core/constants/my_textfield.dart';
import '../../../core/constants/textstyle_constants.dart';
import '../../widgets/button_widget.dart';

class RegisterScreen extends StatefulWidget {
  final Function()? onTap;
  const RegisterScreen({super.key, required this.onTap});
  static const String routeName = '/register_screen';

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

final TextEditingController emailController = new TextEditingController();
final TextEditingController passwordController = new TextEditingController();
final TextEditingController fullNameController = new TextEditingController();
final TextEditingController phoneController = new TextEditingController();
final TextEditingController addressController = new TextEditingController();

final TextEditingController confirmPasswordController =
    new TextEditingController();

bool _showPass = false;

class _RegisterScreenState extends State<RegisterScreen> {
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

  //Sign up
  void signUpClicked() async {
    //show loading circle
    showDialog(
      context: context,
      builder: (context) {
        return Center(
            child: CircularProgressIndicator(
          color: Colors.black,
        ));
      },
    );
    // try creating the user
    try {
      //check if password is confirmed
      if (passwordController.text == confirmPasswordController.text) {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: emailController.text, password: passwordController.text);
      } else {
        // show error msg if password don't match
        showErrorMsg("Mật khẩu không khớp!");
      }
      // Signup thành công
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
          backgroundColor: Colors.grey[400],
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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Icon
                SizedBox(height: 25),
                Icon(
                  FontAwesomeIcons.userPlus,
                  size: 50,
                  color: ColorPalette.primaryColor,
                ),
                SizedBox(height: 25),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Container(
                    alignment: Alignment.centerLeft,
                    child: Text("Đăng ký", style: TextStyles.h4.bold),
                  ),
                ),
                SizedBox(height: 5),

                // Let's create an account for you!
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Container(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Hãy tạo một tài khoản cho bạn!",
                      style: TextStyles.h5.setColor(ColorPalette.textHide),
                    ),
                  ),
                ),
                SizedBox(height: 25),
                MyTextField(
                  controller: fullNameController,
                  hintText: 'Họ và tên',
                  obscureText: false,
                ),
                SizedBox(height: 10),
                MyTextField(
                  controller: phoneController,
                  hintText: 'Số điện thoại',
                  obscureText: false,
                ),
                SizedBox(height: 10),

                // email textField
                Stack(
                  alignment: AlignmentDirectional.centerEnd,
                  children: [
                    MyTextField(
                      controller: emailController,
                      hintText: 'Email',
                      obscureText: false,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 35),
                      child: Icon(
                        FontAwesomeIcons.solidEnvelope,
                        size: 18,
                        color: ColorPalette.primaryColor,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),

                // password textField
                Stack(
                  alignment: AlignmentDirectional.centerEnd,
                  children: [
                    MyTextField(
                      controller: passwordController,
                      hintText: 'Mật khẩu',
                      obscureText: !_showPass,
                    ),
                    GestureDetector(
                      onTap: onToggleShowPass,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 35),
                        child: Icon(
                          _showPass
                              ? FontAwesomeIcons.eyeSlash
                              : FontAwesomeIcons.eye,
                          size: 18,
                          color: ColorPalette.primaryColor,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),

                // confirm password
                Stack(
                  alignment: AlignmentDirectional.centerEnd,
                  children: [
                    MyTextField(
                      controller: confirmPasswordController,
                      hintText: 'Xác nhận mật khẩu',
                      obscureText: !_showPass,
                    ),
                    GestureDetector(
                      onTap: onToggleShowPass,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 35),
                        child: Icon(
                          _showPass
                              ? FontAwesomeIcons.eyeSlash
                              : FontAwesomeIcons.eye,
                          size: 18,
                          color: ColorPalette.primaryColor,
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 25),

                // sign in button
                Container(
                  padding: EdgeInsets.all(25),
                  // margin: EdgeInsets.symmetric(horizontal: 25),
                  child: ButtonWidget(
                    height: 70,
                    title: 'Đăng ký',
                    onTap: signUpClicked,
                    size: 22,
                  ),
                ),
                SizedBox(height: 30),

                // or continue with
                // Padding(
                //   padding: const EdgeInsets.symmetric(horizontal: 25),
                //   child: Row(
                //     children: [
                //       Expanded(
                //         child: Divider(
                //           thickness: 0.5,
                //           color: ColorPalette.primaryColor,
                //         ),
                //       ),
                //       Padding(
                //         padding: const EdgeInsets.symmetric(horizontal: 4),
                //         child: Text(
                //           'Hoặc tiếp tục với',
                //           style: TextStyles.defaultStyle,
                //         ),
                //       ),
                //       Expanded(
                //         child: Divider(
                //           thickness: 0.5,
                //           color: ColorPalette.primaryColor,
                //         ),
                //       ),
                //     ],
                //   ),
                // ),
                // SizedBox(height: 50),

                // google + apple sign in buttons
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.center,
                //   children: [
                //     // google button
                //     SquareTile(
                //       onTap: () {},
                //       child: ImageHelper.loadFromAsset(
                //           AssetHelper.imageLogoGoogle),
                //     ),
                //     SizedBox(width: 25),

                //     // apple button
                //     SquareTile(
                //       onTap: () {},
                //       child:
                //           ImageHelper.loadFromAsset(AssetHelper.imageLogoApple),
                //     ),
                //   ],
                // ),
                // SizedBox(height: 50),

                // Already hvae an account? Login now
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Bạn đã có tài khoản?",
                      style: TextStyles.defaultStyle,
                    ),
                    SizedBox(width: 10),
                    GestureDetector(
                      onTap: widget.onTap,
                      // onTap: () {
                      //   Navigator.of(context).pushNamed(LoginScreen.routeName);
                      // },
                      child: Text(
                        'Đăng nhập ngay.',
                        style:
                            TextStyles.defaultStyle.bold.setColor(Colors.blue),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
