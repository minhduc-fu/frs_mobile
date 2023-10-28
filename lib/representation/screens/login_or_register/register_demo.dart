import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:frs_mobile/representation/screens/login_or_register/register_screen.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/constants/color_constants.dart';
import '../../../core/constants/dismension_constants.dart';
import '../../../core/constants/my_textfield.dart';
import '../../../core/constants/textstyle_constants.dart';
import '../../../utils/asset_helper.dart';
import '../../../utils/image_picker.dart';

class RegisterDemo extends StatefulWidget {
  final Function()? onTap;
  const RegisterDemo({super.key, required this.onTap});
  static const String routeName = '/register_demo';

  @override
  State<RegisterDemo> createState() => _RegisterDemoState();
}

class _RegisterDemoState extends State<RegisterDemo> {
  String selectedRole = "Chọn vai trò";
  TextEditingController fullNameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  bool showRegistrationForm = false;
  bool? isMale;
  bool _showPass = false;
  bool _showConfirmPass = false;

  Uint8List?
      _image; // lưu trữ dữ liệu của ảnh đã chọn. Uint8List là 1 mảng byte không dấu
  void selectImage() async {
    Uint8List img = await pickAImage(ImageSource.gallery);
    setState(() {
      _image = img;
    });
  }

  void usageCamera() async {
    Uint8List img = await pickAImage(ImageSource.camera);
    setState(() {
      _image = img;
    });
  }

  // hàm để hide or show pass
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

  //  hàm show BottomSeet cho giới tính
  void _showGenderBottomSheet() async {
    final selectedGender = await showModalBottomSheet(
      backgroundColor: ColorPalette.primaryColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(kDefaultCircle14),
          topRight: Radius.circular(kDefaultCircle14),
        ),
      ),
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 150,
          child: Column(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 25, vertical: 8),
                child: Container(
                  decoration: BoxDecoration(
                    color: ColorPalette.backgroundScaffoldColor,
                    borderRadius: BorderRadius.circular(kDefaultCircle14),
                    border: Border.all(color: ColorPalette.textHide),
                  ),
                  child: ListTile(
                    title: Text('Nam'),
                    onTap: () {
                      Navigator.pop(context, true); // chọn giới tính là Nam
                    },
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 25, vertical: 8),
                child: Container(
                  decoration: BoxDecoration(
                    color: ColorPalette.backgroundScaffoldColor,
                    borderRadius: BorderRadius.circular(kDefaultCircle14),
                    border: Border.all(color: ColorPalette.textHide),
                  ),
                  child: ListTile(
                    title: Text('Nữ'),
                    onTap: () {
                      Navigator.pop(context, false);
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );

    if (selectedGender != null) {
      setState(() {
        isMale = selectedGender;
      });
    }
  }

  // hàm show vai trò
  void _showRoleBottomSheet() async {
    final selectedRole = await showModalBottomSheet(
      backgroundColor: ColorPalette.primaryColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(kDefaultCircle14),
          topRight: Radius.circular(kDefaultCircle14),
        ),
      ),
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 150,
          child: Column(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 25, vertical: 8),
                child: Container(
                  decoration: BoxDecoration(
                    color: ColorPalette.backgroundScaffoldColor,
                    borderRadius: BorderRadius.circular(kDefaultCircle14),
                    border: Border.all(color: ColorPalette.textHide),
                  ),
                  child: ListTile(
                    title: Center(
                      child: Text('Customer'),
                    ),
                    onTap: () {
                      Navigator.pop(
                          context, 'Customer'); // chọn giới tính là Nam
                    },
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 25, vertical: 8),
                child: Container(
                  decoration: BoxDecoration(
                    color: ColorPalette.backgroundScaffoldColor,
                    borderRadius: BorderRadius.circular(kDefaultCircle14),
                    border: Border.all(color: ColorPalette.textHide),
                  ),
                  child: ListTile(
                    title: Center(child: Text('Product Owner')),
                    onTap: () {
                      Navigator.pop(context, 'Product Owner');
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );

    if (selectedRole != null) {
      setState(() {
        this.selectedRole = selectedRole;
        showRegistrationForm = true;
      });
    }
  }

  Widget _buildRegistrationForm() {
    if (selectedRole == "Customer") {
      return Column(
        children: [
          SizedBox(height: 10),
          Stack(
            children: [
              _image != null
                  ? CircleAvatar(
                      radius: 40,
                      backgroundImage: MemoryImage(_image!),
                    )
                  : CircleAvatar(
                      radius: 40,
                      backgroundImage:
                          AssetImage(AssetHelper.imageCircleAvtMain),
                    ),
              Positioned(
                bottom: 1,
                left: 50,
                child: Center(
                  child: CircleAvatar(
                    backgroundColor: ColorPalette.primaryColor,
                    radius: 15,
                    child: IconButton(
                      onPressed: selectImage,
                      icon: Icon(
                        color: Colors.white,
                        FontAwesomeIcons.plus,
                        size: 16,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          // Họ và tên
          MyTextField(
            prefixIcon: Icon(
              FontAwesomeIcons.signature,
              size: kDefaultIconSize18,
            ),
            controller: fullNameController,
            hintText: 'Họ và tên',
            obscureText: false,
          ),
          SizedBox(height: 10),

          // SDT
          MyTextField(
            prefixIcon: Icon(
              FontAwesomeIcons.phone,
              size: kDefaultIconSize18,
            ),
            hintText: 'Số điện thoại',
            obscureText: false,
            controller: phoneController,
          ),
          SizedBox(height: 10),

          // Email
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

          // Password
          MyTextField(
            suffixIcon: GestureDetector(
              onTap: onToggleShowPass,
              child: Icon(
                _showPass ? FontAwesomeIcons.eyeSlash : FontAwesomeIcons.eye,
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
          SizedBox(height: 10),

          // Giới tính
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(kDefaultCircle14),
              border: Border.all(color: ColorPalette.textHide),
            ),
            child: ListTile(
              title: Text('Giới tính'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    isMale == null
                        ? 'Chưa chọn giới tính'
                        : (isMale! ? 'Nam' : 'Nữ'),
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
              onTap: _showGenderBottomSheet,
            ),
          ),
        ],
      );
    } else if (selectedRole == "Product Owner") {
      return Column(
        children: [
          SizedBox(height: 10),

          // Họ và tên
          MyTextField(
            prefixIcon: Icon(
              FontAwesomeIcons.signature,
              size: kDefaultIconSize18,
            ),
            controller: fullNameController,
            hintText: 'Họ và tên',
            obscureText: false,
          ),
          SizedBox(height: 10),

          // SDT
          MyTextField(
            prefixIcon: Icon(
              FontAwesomeIcons.phone,
              size: kDefaultIconSize18,
            ),
            hintText: 'Số điện thoại',
            obscureText: false,
            controller: phoneController,
          ),
          SizedBox(height: 10),

          // Email
          MyTextField(
            hintText: 'Email',
            prefixIcon: Icon(
              FontAwesomeIcons.solidEnvelope,
              size: kDefaultIconSize18,
            ),
            controller: emailController,
            obscureText: false,
          ),
          SizedBox(height: 10),

          // Password
          MyTextField(
            suffixIcon: GestureDetector(
              onTap: onToggleShowPass,
              child: Icon(
                _showPass ? FontAwesomeIcons.eyeSlash : FontAwesomeIcons.eye,
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
          SizedBox(height: 10),

          MyTextField(
            prefixIcon: Icon(
              FontAwesomeIcons.locationDot,
              size: kDefaultIconSize18,
            ),
            controller: emailController,
            hintText: 'Địa chỉ',
            obscureText: false,
          ),
          SizedBox(height: 10),
        ],
      );
    } else {
      return SizedBox
          .shrink(); // Trường hợp không chọn vai trò nào, không hiển thị gì cả
      // return Text('ahihi');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 10),
            Icon(
              FontAwesomeIcons.userPlus,
              size: selectedRole == 'Chọn vai trò' ? 50 : 30,
            ),
            SizedBox(height: 25),
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

            Container(
              alignment: Alignment.centerLeft,
              child: Text(
                selectedRole == 'Chọn vai trò'
                    ? 'Đầu tiên, hãy chọn vai trò bạn muốn trở thành!'
                    : ('Bạn đã chọn ${selectedRole} nên là bạn có thể' +
                        (selectedRole == "Customer"
                            ? ' thuê/mua sản phẩm.'
                            : ' cho thuê/bán sản phẩm.')),
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
                onTap: _showRoleBottomSheet,
              ),
            ),
            if (showRegistrationForm) _buildRegistrationForm(),
            // Already hvae an account? Login now
            SizedBox(height: 40),
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
                  // onTap: () {
                  //   Navigator.of(context).pushNamed(LoginScreen.routeName);
                  // },
                  child: Text(
                    'Đăng nhập ngay.',
                    style: TextStyles.h5.bold.setColor(Colors.blue),
                  ),
                )
              ],
            ),
            SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
