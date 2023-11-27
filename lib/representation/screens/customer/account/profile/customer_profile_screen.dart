import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../../../../bloc/register_stepper_bloc.dart';
import '../../../../../core/constants/color_constants.dart';
import '../../../../../core/constants/dismension_constants.dart';
import '../../../../../core/constants/my_textfield.dart';
import '../../../../../core/constants/textstyle_constants.dart';
import '../../../../../models/customer_model.dart';
import '../../../../../services/add_image_cloud.dart';
import '../../../../../services/authentication_service.dart';
import '../../../../../services/authprovider.dart';
import '../../../../../utils/asset_helper.dart';
import '../../../../../utils/dialog_helper.dart';
import '../../../../../utils/image_picker.dart';
import '../../../../widgets/app_bar_main.dart';
import '../../../../widgets/button_widget.dart';

class CustomerProfileScreen extends StatefulWidget {
  const CustomerProfileScreen({super.key});
  static const String routeName = '/customer_profile_screen';
  @override
  State<CustomerProfileScreen> createState() => _CustomerProfileScreenState();
}

final TextEditingController fullNameController = new TextEditingController();
final TextEditingController phoneController = new TextEditingController();

class _CustomerProfileScreenState extends State<CustomerProfileScreen> {
  int? accountID = AuthProvider.userModel?.accountID;
  String? imageUrl;
  bool? isMale;
  Uint8List?
      _image; // lưu trữ dữ liệu của ảnh đã chọn. Uint8List là 1 mảng byte không dấu
  void selectImage() async {
    Uint8List img = await pickAImage(ImageSource.gallery);
    setState(() {
      _image = img;
    });
  }

  late AuthProvider authProvider;

  @override
  void initState() {
    super.initState();
    fullNameController.text = AuthProvider.userModel?.customer?.fullName ?? '';
    phoneController.text = AuthProvider.userModel?.customer?.phone ?? '';
    isMale = AuthProvider.userModel?.customer?.sex ?? null;
    imageUrl = AuthProvider.userModel?.customer?.avatarUrl ?? null;
  }

  Future<void> updateCustomerProfile() async {
    if (AuthProvider.userModel != null &&
        AuthProvider.userModel?.customer != null) {
      final customerID = AuthProvider.userModel?.customer?.customerID;
      final fullName = fullNameController.text;
      final phone = phoneController.text;
      final sex = isMale;
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
        if (_image == null) {
          imageUrl = AuthProvider.userModel?.customer?.avatarUrl;
        } else {
          imageUrl = await AddImageCloud()
              .uploadImageToStorage('avatarCustomer', _image!);
        }
        final response = await AuthenticationService.updateCustomer(
            customerID!, imageUrl!, fullName, phone, sex!);
        Navigator.pop(context);

        if (response != null) {
          final updateUserModel = AuthProvider.userModel
              ?.copyWith(customer: CustomerModel.fromJson(response));
          if (updateUserModel != null) {
            final authProvider =
                Provider.of<AuthProvider>(context, listen: false);
            authProvider.setUser(updateUserModel);
            var box = Hive.box('userBox');
            box.put('user', json.encode(updateUserModel.toJson()));
            setState(() {
              fullNameController.text =
                  AuthProvider.userModel?.customer?.fullName ?? '';
              phoneController.text =
                  AuthProvider.userModel?.customer?.phone ?? '';
              isMale = AuthProvider.userModel?.customer?.sex ?? null;
              imageUrl = AuthProvider.userModel?.customer?.avatarUrl ?? '';
            });
          }
          showCustomDialog(
              context, "Thành công", "Bạn đã cập nhật thành công.", true);
        } else {
          print('faild');
          showCustomDialog(
              context, "Lỗi", "Xin lỗi. Bạn cập nhật không thành công.", true);
        }
      } catch (e) {
        showCustomDialog(context, "Lỗi", e.toString(), true);
      }
    }
  }

  Future<void> createCustomer() async {
    if (_image == null) {
      showCustomDialog(context, 'Lỗi', 'Bạn chưa chọn "Avatar".', true);
    } else if (fullNameController.text.isEmpty) {
      showCustomDialog(context, 'Lỗi', 'Bạn chưa nhập "Họ và tên".', true);
    } else if (phoneController.text.isEmpty) {
      showCustomDialog(context, 'Lỗi', 'Bạn chưa nhập "Số điện thoại".', true);
    } else if (isMale == null) {
      showCustomDialog(context, 'Lỗi', 'Bạn chưa chọn "Giới tính".', true);
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
        imageUrl = await AddImageCloud()
            .uploadImageToStorage('avatarCustomer', _image!);
        final response = await AuthenticationService.createCustomer(accountID!,
            fullNameController.text, phoneController.text, isMale!, imageUrl!);
        Navigator.pop(context);
        if (response != null) {
          final responseStatus =
              await AuthenticationService.updateStatus(accountID!, "VERIFIED");
          if (responseStatus != null) {
            final updateUserModel = AuthProvider.userModel?.copyWith(
                customer: CustomerModel.fromJson(response), status: 'VERIFIED');
            if (updateUserModel != null) {
              authProvider.setUser(updateUserModel);
              var box = Hive.box('userBox');
              box.put('user', json.encode(updateUserModel.toJson()));
              setState(() {
                fullNameController.text =
                    AuthProvider.userModel?.customer?.fullName ?? '';
                phoneController.text =
                    AuthProvider.userModel?.customer?.phone ?? '';
                isMale = AuthProvider.userModel?.customer?.sex ?? null;
                imageUrl = AuthProvider.userModel?.customer?.avatarUrl ?? '';
              });
            }
          }
          print('ok');
          print(AuthProvider.userModel?.status);
          showCustomDialog(context, 'Thành công',
              'Chúc mừng bạn đã xác minh thành công!', true);
        } else {
          print('faild');
          showCustomDialog(
              context, 'Lỗi', 'Xin lỗi! Xác minh không thành công.', true);
        }
      } catch (e) {
        showCustomDialog(context, "Lỗi", e.toString(), true);
      }
    }
  }

  bool isFullNameValid(String fullName) {
    return fullName.trim().contains(' ');
  }

  bool isFullNameValidAbc(String fullName) {
    return fullName.trim().contains(' ');
  }

  final _formKey = GlobalKey<FormState>();
  String? fullNameErrorText;
  @override
  Widget build(BuildContext context) {
    authProvider = Provider.of<AuthProvider>(context);
    return AppBarMain(
      titleAppbar: 'Thông tin cá nhân',
      isCart: true,
      leading: GestureDetector(
        onTap: () {
          Navigator.of(context).pop();
        },
        child: Icon(FontAwesomeIcons.angleLeft),
      ),
      child: Scaffold(
        body: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  SizedBox(height: 20),
                  if (AuthProvider.userModel?.status == "NOT_VERIFIED")
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Stack(
                            children: [
                              _image != null
                                  ? CircleAvatar(
                                      radius: 40,
                                      backgroundImage: MemoryImage(_image!),
                                    )
                                  : CircleAvatar(
                                      radius: 40,
                                      backgroundImage: AssetImage(
                                          AssetHelper.imageCircleAvtMain),
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
                        ),
                        SizedBox(height: 10),
                        Column(
                          children: [
                            // tên
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Tên của bạn",
                                  style: TextStyles.h5.setTextSize(20).bold,
                                ),
                              ],
                            ),
                            //gmail
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  AuthProvider.userModel?.email ?? '',
                                  style: TextStyles.h5,
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                        //fullName
                        Text(
                          'Họ và tên',
                          style: TextStyles.h5.bold,
                        ),
                        SizedBox(height: 10),
                        TextFormField(
                          controller: fullNameController,
                          validator: (value) =>
                              value!.trim().contains(' ') ? null : 'DMM',
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          decoration: InputDecoration(
                            hintText: "Họ và tên",
                            enabledBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.circular(kDefaultCircle14),
                              borderSide:
                                  BorderSide(color: ColorPalette.textHide),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: ColorPalette.primaryColor),
                            ),
                            fillColor: Colors.white,
                            filled: true,
                            hintStyle: TextStyles.defaultStyle
                                .setColor(ColorPalette.textHide),
                          ),
                        ),
                        // MyTextField(
                        //   controller: fullNameController,
                        //   hintText: 'Họ và tên',
                        //   obscureText: false,
                        // ),
                        SizedBox(height: 10),
                        //phone
                        Text(
                          'Số điện thoại',
                          style: TextStyles.h5.bold,
                        ),
                        SizedBox(height: 10),
                        MyTextField(
                          textInputType: TextInputType.number,
                          controller: phoneController,
                          hintText: 'Số điện thoại',
                          obscureText: false,
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Giới tính',
                          style: TextStyles.h5.bold,
                        ),
                        SizedBox(height: 10),
                        //gioi tinh
                        Container(
                          decoration: BoxDecoration(
                            color: ColorPalette.hideColor,
                            borderRadius:
                                BorderRadius.circular(kDefaultCircle14),
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
                                      : (isMale! ? 'Nữ' : 'Nam'),
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
                              final result = await RegisterStepperBloc
                                  .showGenderBottomSheet(context);
                              if (result != null) {
                                setState(() {
                                  isMale = result;
                                });
                              }
                            },
                          ),
                        ),
                        SizedBox(height: 20),
                        ButtonWidget(
                          height: 70,
                          size: 22,
                          title: 'Xác minh',
                          onTap: createCustomer,
                        ),
                      ],
                    ),
                  if (AuthProvider.userModel?.status == "VERIFIED")
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Stack(
                            children: [
                              _image != null
                                  ? CircleAvatar(
                                      radius: 40,
                                      backgroundImage: MemoryImage(_image!),
                                    )
                                  : CircleAvatar(
                                      radius: 40,
                                      backgroundImage: NetworkImage(
                                        AuthProvider.userModel?.customer
                                                ?.avatarUrl ??
                                            '',
                                      ),
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
                        ),
                        SizedBox(height: 10),
                        //fullName
                        Column(
                          children: [
                            // tên
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  AuthProvider.userModel?.customer?.fullName ??
                                      '',
                                  style: TextStyles.h5.setTextSize(20).bold,
                                ),
                              ],
                            ),
                            //gmail
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  AuthProvider.userModel?.email ?? '',
                                  style: TextStyles.h5,
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                        //fullName
                        Text(
                          'Họ và tên',
                          style: TextStyles.h5.bold,
                        ),
                        SizedBox(height: 10),
                        TextField(
                          onSubmitted: (String value) {
                            if (!isFullNameValid(value)) {
                              setState(() {
                                fullNameErrorText =
                                    'Họ và tên phải chứa khoảng trắng.';
                              });
                            } else {
                              setState(() {
                                fullNameErrorText = null;
                              });
                            }
                          },
                          controller: fullNameController,
                          decoration: InputDecoration(
                            labelText: 'Họ và tên',
                            labelStyle: TextStyles.defaultStyle
                                .setColor(ColorPalette.textHide),
                            enabledBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.circular(kDefaultCircle14),
                              borderSide:
                                  BorderSide(color: ColorPalette.textHide),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: ColorPalette.primaryColor),
                            ),
                            fillColor: Colors.white,
                            filled: true,
                            hintText: 'Họ và tên',
                            hintStyle: TextStyles.defaultStyle
                                .setColor(ColorPalette.textHide),
                            errorText: fullNameErrorText,
                          ),
                          obscureText: false,
                        ),
                        // MyTextField(
                        //   controller: fullNameController,
                        //   hintText: 'Họ và tên',
                        //   obscureText: false,
                        // ),
                        SizedBox(height: 10),

                        //phone
                        Text(
                          'Số điện thoại',
                          style: TextStyles.h5.bold,
                        ),
                        SizedBox(height: 10),
                        MyTextField(
                          controller: phoneController,
                          hintText: 'Số điện thoại',
                          obscureText: false,
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Giới tính',
                          style: TextStyles.h5.bold,
                        ),
                        SizedBox(height: 10),
                        //gioi tinh
                        Container(
                          decoration: BoxDecoration(
                            color: ColorPalette.hideColor,
                            borderRadius:
                                BorderRadius.circular(kDefaultCircle14),
                            border: Border.all(color: ColorPalette.textHide),
                          ),
                          child: ListTile(
                            title: Text('Giới tính'),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  AuthProvider.userModel?.customer?.sex == true
                                      ? 'Nữ'
                                      : "Nam",
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
                              final result = await RegisterStepperBloc
                                  .showGenderBottomSheet(context);
                              if (result != null) {
                                setState(() {
                                  AuthProvider.userModel?.customer?.sex =
                                      result;
                                  isMale =
                                      AuthProvider.userModel?.customer?.sex;
                                });
                              }
                            },
                          ),
                        ),
                        SizedBox(height: 20),
                        ButtonWidget(
                          height: 70,
                          size: 22,
                          title: 'Cập nhật',
                          onTap: updateCustomerProfile,
                        ),
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
