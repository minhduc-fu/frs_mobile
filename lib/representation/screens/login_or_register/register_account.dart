import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:frs_mobile/core/constants/my_textformfield.dart';
import '../../../bloc/register_stepper_bloc.dart';
import '../../../core/constants/color_constants.dart';
import '../../../core/constants/dismension_constants.dart';
import '../../../core/constants/textstyle_constants.dart';
import '../../../services/authentication_service.dart';
import '../../../utils/dialog_helper.dart';
import '../../widgets/button_widget.dart';

class RegisterAccount extends StatefulWidget {
  final Function()? onTap;
  const RegisterAccount({super.key, required this.onTap});

  @override
  State<RegisterAccount> createState() => _RegisterAccountState();
}

class _RegisterAccountState extends State<RegisterAccount> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  String selectedRole = "Chọn vai trò";
  bool _showPass = false;
  bool _showConfirmPass = false;
  int? accountID;
  Future<void> createAccount() async {
    if (emailController.text.isEmpty) {
      showCustomDialog(context, 'Lỗi', 'Vui lòng nhập "Email".', true);
    } else if (validateEmail(emailController.text) != null) {
      showCustomDialog(context, 'Lỗi', 'Email không hợp lệ', true);
    } else if (passwordController.text.isEmpty) {
      showCustomDialog(context, 'Lỗi', 'Bạn chưa điền "Mật khẩu".', true);
    } else if (validatePassword(passwordController.text) != null) {
      showCustomDialog(context, 'Lỗi', 'Mật khẩu không hợp lệ', true);
    } else if (confirmPasswordController.text.isEmpty) {
      showCustomDialog(
          context, 'Lỗi', 'Bạn chưa điền "Xác nhận mật khẩu".', true);
    } else if (selectedRole == 'Chọn vai trò') {
      showCustomDialog(context, 'Lỗi', 'Bạn chưa chọn "Vai trò".', true);
    } else if (passwordController.text != confirmPasswordController.text) {
      showCustomDialog(
          context, 'Lỗi', 'Xác nhận mật khẩu không trùng khớp.', true);
    } else {
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
        final response = await AuthenticationService.createAccount(
            emailController.text,
            passwordController.text,
            selectedRole == 'Customer' ? 1 : 2);
        Navigator.pop(context);

        if (response != null) {
          accountID = response['accountID'] as int;
          if (response['status'] == 'Lỗi' &&
              response['message'] == 'Created Fail By Email Already Existed') {
            showCustomDialog(context, 'Lỗi',
                'Email này đã tồn tại. Vui lòng sử dụng một email khác.', true);
          } else {
            showCustomDialog(context, 'Thành công',
                'Bạn đã đăng ký tài khoản thành công.', true);
            print(accountID);
            final walletResponse =
                await AuthenticationService.createWallet(accountID!, 0);
            if (walletResponse != null) {
              print('Tạo ví thành công.');
            } else {
              print('Thất bại tạo ví.');
            }
          }
        } else {
          showCustomDialog(context, 'Lỗi',
              'Xin lỗi! Đăng ký tài khoản không thành công', true);
        }
      } catch (e) {
        showCustomDialog(context, 'Error', e.toString(), true);
      }
    }
  }

  void onToggleShowPass() {
    setState(() {
      _showPass = !_showPass;
    });
  }

  void onToggleShowConfirmPass() {
    setState(() {
      _showConfirmPass = !_showConfirmPass;
    });
  }

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

  Widget createAccountWidget() {
    return Column(
      children: [
        SizedBox(height: 20),
        Icon(
          FontAwesomeIcons.userPlus,
          size: 50,
        ),
        SizedBox(height: 20),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              Container(
                alignment: Alignment.centerLeft,
                child: Text("Đăng ký", style: TextStyles.h4.bold),
              ),
              SizedBox(height: 5),

              // Let's create an account for you!
              Container(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Hãy tạo một tài khoản cho bạn!",
                  style: TextStyles.h5.setColor(ColorPalette.textHide),
                ),
              ),
              SizedBox(height: 25),

              // Email
              MyTextFormField(
                controller: emailController,
                hintText: 'Email',
                obscureText: false,
                validator: validateEmail,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                prefixIcon: Icon(
                  FontAwesomeIcons.solidEnvelope,
                  size: kDefaultIconSize18,
                ),
              ),
              // MyTextField(
              //   prefixIcon: Icon(
              //     FontAwesomeIcons.solidEnvelope,
              //     size: kDefaultIconSize18,
              //   ),
              //   controller: emailController,
              //   hintText: 'Email',
              //   obscureText: false,
              // ),
              SizedBox(height: 10),

              //  Password
              MyTextFormField(
                controller: passwordController,
                hintText: 'Mật khẩu',
                obscureText: !_showPass,
                validator: validatePassword,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                prefixIcon: Icon(
                  FontAwesomeIcons.key,
                  size: kDefaultIconSize18,
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
              // MyTextField(
              //   suffixIcon: GestureDetector(
              //     onTap: onToggleShowPass,
              //     child: Icon(
              //       _showPass
              //           ? FontAwesomeIcons.eyeSlash
              //           : FontAwesomeIcons.eye,
              //       size: kDefaultIconSize18,
              //       color: ColorPalette.primaryColor,
              //     ),
              //   ),
              //   prefixIcon: Icon(
              //     FontAwesomeIcons.key,
              //     size: kDefaultIconSize18,
              //   ),
              //   controller: passwordController,
              //   hintText: 'Mật khẩu',
              //   obscureText: !_showPass,
              // ),
              SizedBox(height: 10),

              // Confirm password
              MyTextFormField(
                controller: confirmPasswordController,
                hintText: 'Xác nhận mật khẩu',
                obscureText: !_showConfirmPass,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập Confirm Password';
                  }
                  if (value.contains(' ')) {
                    return 'Mật khẩu không được chứa khoảng trắng';
                  }
                  if (value.contains(',')) {
                    return 'Không được chứa dấu ","';
                  }
                  if (value != passwordController.text) {
                    return 'Xác nhận mật khẩu không trùng khớp với mật khẩu';
                  }
                  return null;
                },
                autovalidateMode: AutovalidateMode.onUserInteraction,
                suffixIcon: GestureDetector(
                  onTap: onToggleShowConfirmPass,
                  child: Icon(
                    _showConfirmPass
                        ? FontAwesomeIcons.eyeSlash
                        : FontAwesomeIcons.eye,
                    size: kDefaultIconSize18,
                    color: ColorPalette.primaryColor,
                  ),
                ),
                prefixIcon: Icon(
                  FontAwesomeIcons.check,
                  size: kDefaultIconSize18,
                ),
              ),
              // MyTextField(
              //   suffixIcon: GestureDetector(
              //     onTap: onToggleShowConfirmPass,
              //     child: Icon(
              //       _showConfirmPass
              //           ? FontAwesomeIcons.eyeSlash
              //           : FontAwesomeIcons.eye,
              //       size: kDefaultIconSize18,
              //       color: ColorPalette.primaryColor,
              //     ),
              //   ),
              //   prefixIcon: Icon(
              //     FontAwesomeIcons.check,
              //     size: kDefaultIconSize18,
              //   ),
              //   controller: confirmPasswordController,
              //   hintText: 'Xác nhận mật khẩu',
              //   obscureText: !_showConfirmPass,
              // ),
              SizedBox(height: 25),
              Container(
                alignment: Alignment.centerLeft,
                child: Text(
                  selectedRole == "Chọn vai trò"
                      ? 'Hãy chọn vai trò bạn muốn trở thành!'
                      : 'Bạn đã chọn ${selectedRole}, ' +
                          'bạn có thể ' +
                          (selectedRole == 'Customer'
                              ? 'thuê và mua sản phẩm!'
                              : 'đăng bán và cho thuê sản phẩm!'),
                  style: TextStyles.h5.setColor(ColorPalette.textHide),
                ),
              ),
              SizedBox(height: 10),
              // chọn vai trò
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(kDefaultCircle14),
                  border: Border.all(color: ColorPalette.textHide),
                ),
                child: ListTile(
                  title: Text(
                    'Vai trò',
                    style: TextStyles.h5,
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        selectedRole == 'Chọn vai trò'
                            ? 'Chưa chọn vai trò'
                            : selectedRole,
                        style: TextStyles.defaultStyle,
                      ),
                      SizedBox(width: 10),
                      Icon(
                        FontAwesomeIcons.angleRight,
                        size: kDefaultIconSize18,
                        color: ColorPalette.primaryColor,
                      )
                    ],
                  ),
                  onTap: () async {
                    final result =
                        await RegisterStepperBloc.showRoleBottomSheet(context);
                    if (result != null) {
                      setState(() {
                        selectedRole = result;
                      });
                    }
                  },
                ),
              ),
              SizedBox(height: 20),
              ButtonWidget(
                title: 'Tiếp tục',
                size: 22,
                height: 70,
                onTap: createAccount,
              ),
            ],
          ),
        ),
        SizedBox(height: 20),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            createAccountWidget(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Bạn đã có tài khoản?",
                  style: TextStyles.h5,
                ),
                SizedBox(width: 10),
                GestureDetector(
                  onTap: widget.onTap,
                  child: Text(
                    'Đăng nhập ngay.',
                    style: TextStyles.h5.bold.setColor(Colors.blue),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
