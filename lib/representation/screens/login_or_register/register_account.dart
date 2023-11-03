import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../bloc/register_stepper_bloc.dart';
import '../../../core/constants/color_constants.dart';
import '../../../core/constants/dismension_constants.dart';
import '../../../core/constants/my_textfield.dart';
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
      showCustomDialog(context, 'Lỗi', 'Bạn chưa điền "Email".');
    } else if (!emailController.text.endsWith('@gmail.com')) {
      showCustomDialog(context, 'Lỗi',
          'Emal không hợp lệ. Vui lòng sử dụng email có định dạng "@gmail.com"');
    } else if (passwordController.text.isEmpty) {
      showCustomDialog(context, 'Lỗi', 'Bạn chưa điền "Mật khẩu".');
    } else if (confirmPasswordController.text.isEmpty) {
      showCustomDialog(context, 'Lỗi', 'Bạn chưa điền "Xác nhận mật khẩu".');
    } else if (selectedRole == 'Chọn vai trò') {
      showCustomDialog(context, 'Lỗi', 'Bạn chưa chọn "Vai trò".');
    } else if (passwordController.text != confirmPasswordController.text) {
      showCustomDialog(context, 'Lỗi', 'Xác nhận mật khẩu không trùng khớp.');
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
                'Email này đã tồn tại. Vui lòng sử dụng một email khác.');
          } else {
            showCustomDialog(
                context, 'Thành công', 'Bạn đã đăng ký tài khoản thành công.');
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
          showCustomDialog(
              context, 'Lỗi', 'Xin lỗi! Đăng ký tài khoản không thành công');
        }
      } catch (e) {
        showCustomDialog(context, 'Error', e.toString());
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
              MyTextField(
                prefixIcon: Icon(
                  FontAwesomeIcons.solidEnvelope,
                  size: kDefaultIconSize18,
                ),
                controller: emailController,
                hintText: 'Email',
                obscureText: false,
              ),
              SizedBox(height: 10),
              MyTextField(
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
                prefixIcon: Icon(
                  FontAwesomeIcons.key,
                  size: kDefaultIconSize18,
                ),
                controller: passwordController,
                hintText: 'Mật khẩu',
                obscureText: !_showPass,
              ),
              SizedBox(height: 10),

              // Confirm password
              MyTextField(
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
                controller: confirmPasswordController,
                hintText: 'Xác nhận mật khẩu',
                obscureText: !_showConfirmPass,
              ),
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
