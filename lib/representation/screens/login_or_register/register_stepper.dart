import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:frs_mobile/services/authprovider.dart';
import 'package:im_stepper/stepper.dart';
import 'package:image_picker/image_picker.dart';

import '../../../bloc/register_stepper_bloc.dart';
import '../../../core/constants/color_constants.dart';
import '../../../core/constants/dismension_constants.dart';
import '../../../core/constants/my_textfield.dart';
import '../../../core/constants/textstyle_constants.dart';
import '../../../services/add_image_cloud.dart';
import '../../../services/authentication_service.dart';
import '../../../utils/asset_helper.dart';
import '../../../utils/image_picker.dart';
import '../../widgets/button_widget.dart';

class RegisterStepper extends StatefulWidget {
  final Function()? onTap;
  const RegisterStepper({super.key, required this.onTap});

  @override
  State<RegisterStepper> createState() => _RegisterStepperState();
}

class _RegisterStepperState extends State<RegisterStepper> {
  TextEditingController fullNameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  String selectedRole = "Chọn vai trò";
  bool _showPass = false;
  bool _showConfirmPass = false;
  bool? isMale;
  int activeStep = 0;
  int dotCount = 2;
  int? accountID;
  String? imageUrl;
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

  Widget bodyBuilder() {
    switch (activeStep) {
      case 0:
        return createAccountWidget();
      case 1:
        return createCustomerWidget();
      default:
        return createAccountWidget();
    }
  }

  Widget createAccountWidget() {
    return Column(
      children: [
        Text(
          "Bước ${activeStep + 1}: Tạo tài khoản",
          style: TextStyles.h5.bold,
        ),
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
                child: Text("Tạo tài khoản", style: TextStyles.h4.bold),
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
                  'Hãy chọn vai trò bạn muốn trở thành!',
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
                onTap: () async {
                  if (activeStep < dotCount - 1) {
                    if (emailController.text.isEmpty) {
                      showErrorMsg('Bạn chưa điền Email.');
                    } else if (passwordController.text.isEmpty) {
                      showErrorMsg('Bạn chưa điền Mật khẩu');
                    } else if (confirmPasswordController.text.isEmpty) {
                      showErrorMsg('Bạn chưa điền Xác nhận mật khẩu');
                    } else if (selectedRole == 'Chọn vai trò') {
                      showErrorMsg('Bạn chưa chọn vai trò.');
                    } else if (passwordController.text !=
                        confirmPasswordController.text) {
                      showErrorMsg('Xác nhận mật khẩu không trùng khớp.');
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
                        final response =
                            await AuthenticationService.createAccount(
                                emailController.text,
                                passwordController.text,
                                selectedRole == 'Customer' ? 1 : 2);
                        Navigator.pop(context);

                        if (response != null) {
                          accountID = response['accountID'] as int;
                          if (response['status'] == 'Error' &&
                              response['message'] ==
                                  'Created Fail By Email Already Existed') {
                            showErrorMsg(
                                'Email này đã tồn tại. Vui lòng sử dụng một email khác.');
                          } else {
                            showErrorMsg(
                                'Bạn đã đăng ký tài khoản thành công.');
                            print(accountID);
                            setState(() {
                              activeStep++;
                            });
                          }
                        } else {
                          showErrorMsg('Đăng ký tài khoản không thành công');
                        }
                      } catch (e) {
                        showErrorMsg(e.toString());
                      }
                    }
                  }
                },
              ),
            ],
          ),
        ),
        SizedBox(height: 10),
      ],
    );
  }

  Widget createCustomerWidget() {
    return Column(
      children: [
        Text(
          "Bước ${activeStep + 1}: Đăng ký",
          style: TextStyles.h5.bold,
        ),
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
              if (selectedRole == 'Customer')
                Column(
                  children: [
                    Text(
                      'Bạn đã chọn Customer và bạn có thể mua hoặc thuê sản phẩm!',
                      style: TextStyles.h5.setColor(ColorPalette.textHide),
                    ),
                    SizedBox(height: 10),
                    //avt
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
                        onTap: () async {
                          final result =
                              await RegisterStepperBloc.showGenderBottomSheet(
                                  context);
                          if (result != null) {
                            setState(() {
                              isMale = result;
                            });
                          }
                        },
                      ),
                    ),
                  ],
                ),
              if (selectedRole == 'Product Owner')
                Column(
                  children: [
                    Text(
                      'Bạn đã chọn Product Owner và bạn có thể đăng sản phẩm để cho thuê hoặc bán!',
                      style: TextStyles.h5.setColor(ColorPalette.textHide),
                    ),
                    SizedBox(height: 10),
                    //avt
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
                    //địa chỉ
                    MyTextField(
                      prefixIcon: Icon(
                        FontAwesomeIcons.locationDot,
                        size: kDefaultIconSize18,
                      ),
                      controller: addressController,
                      hintText: 'Địa chỉ',
                      obscureText: false,
                    ),
                  ],
                ),
              SizedBox(height: 20),
              ButtonWidget(
                title: 'Đăng ký',
                size: 22,
                height: 70,
                onTap: () async {
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
                    if (fullNameController.text.isEmpty ||
                        phoneController.text.isEmpty ||
                        isMale == null ||
                        _image == null) {
                      showErrorMsg('Vui lòng điền đầy đủ thông tin!');
                      return;
                    } else {
                      imageUrl = await AddImageCloud().uploadImageToStorage(
                          'avatarCustomer',
                          _image!,
                          AuthProvider.userModel!.accountID);
                      final response =
                          await AuthenticationService.createCustomer(
                        accountID!,
                        fullNameController.text,
                        phoneController.text,
                        isMale!,
                        imageUrl!,
                      );
                      Navigator.pop(context);
                      if (response != null) {
                        print('ok');
                        // Navigator.of(context)
                        //     .pushNamed(LoginScreen.routeName);
                      } else {
                        print('faild');
                      }
                    }
                  } catch (e) {
                    showErrorMsg(e.toString());
                  }
                  print('Đăng ký');
                },
              ),
              SizedBox(height: 20),
              ButtonWidget(
                title: 'Hủy',
                size: 22,
                height: 70,
                onTap: () {
                  if (activeStep > 0) {
                    setState(() {
                      activeStep--;
                    });
                  }
                  print('Hủy');
                },
              ),
            ],
          ),
        ),
        SizedBox(height: 10)
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            DotStepper(
              dotCount: dotCount, // số lượng step
              dotRadius: 20, // kích thước step
              activeStep: activeStep,
              shape: Shape.stadium, // hình dạng step
              spacing: 10, // khoảng cách giữa các step
              indicator: Indicator.shift, // animation khi chuyển step
              onDotTapped: (tappedDotIndex) {
                setState(() {
                  activeStep = tappedDotIndex;
                });
              },

              fixedDotDecoration: FixedDotDecoration(
                color: ColorPalette.textHide,
              ),
              indicatorDecoration: IndicatorDecoration(
                color: ColorPalette.primaryColor,
              ),
            ),
            bodyBuilder(),
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
