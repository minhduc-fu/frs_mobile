import 'package:demo_frs_app/core/constants/color_constants.dart';
import 'package:demo_frs_app/core/constants/textstyle_constants.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class RegisterDemo extends StatefulWidget {
  const RegisterDemo({super.key});

  @override
  State<RegisterDemo> createState() => _RegisterDemoState();
}

class _RegisterDemoState extends State<RegisterDemo> {
  String selectedRole = "Chose Role";
  TextEditingController fullNameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  bool showRegistrationForm = false;
  bool? isMale;

  void _showGenderBottomSheet() async {
    final selectedGender = await showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 200,
          child: Column(
            children: [
              ListTile(
                title: Text('Nam'),
                onTap: () {
                  Navigator.pop(context, true); // chọn giới tính là Nam
                },
              ),
              ListTile(
                title: Text('Nữ'),
                onTap: () {
                  Navigator.pop(context, false);
                },
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

  //

  // cập nhật giới tính được chọn
  // void _selectGender(String gender) {
  //   setState(() {
  //     selectedGender = gender;
  //   });
  // }

  Widget _buildRegistrationForm() {
    if (selectedRole == "Customer") {
      return Column(
        children: [
          TextField(
            controller: fullNameController,
            decoration: InputDecoration(labelText: "Họ và Tên"),
          ),
          SizedBox(height: 10),
          TextField(
            controller: phoneController,
            decoration: InputDecoration(labelText: "Số điện thoại"),
          ),
          SizedBox(height: 10),
          TextField(
            controller: emailController,
            decoration: InputDecoration(labelText: "Email"),
          ),
          SizedBox(height: 10),
          TextField(
            controller: passwordController,
            decoration: InputDecoration(labelText: "Password"),
          ),
          SizedBox(height: 10),
          ListTile(
            title: Text('Giới tính'),
            subtitle: Text(isMale == null
                ? 'Chưa chọn giới tính'
                : (isMale! ? 'Nam' : 'Nữ')),
            onTap: _showGenderBottomSheet,
          ),
        ],
      );
    } else if (selectedRole == "Product Owner") {
      return Column(
        children: [
          TextField(
            controller: fullNameController,
            decoration: InputDecoration(labelText: "Họ và Tên"),
          ),
          SizedBox(height: 10),
          TextField(
            controller: phoneController,
            decoration: InputDecoration(labelText: "Số điện thoại"),
          ),
          SizedBox(height: 10),
          TextField(
            controller: emailController,
            decoration: InputDecoration(labelText: "Email"),
          ),
          SizedBox(height: 10),
          TextField(
            controller: passwordController,
            decoration: InputDecoration(labelText: "Password"),
          ),
          SizedBox(height: 10),
          TextField(
            controller: addressController,
            decoration: InputDecoration(labelText: "Địa chỉ"),
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
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 25),
                Icon(
                  FontAwesomeIcons.userPlus,
                  size: 50,
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
                // if (!showRegistrationForm)
                Row(
                  children: [
                    Text('Chọn vai trò'),
                    SizedBox(width: 20),
                    DropdownButton<String>(
                      value: selectedRole,
                      hint: Text('Chọn vai trò'),
                      onChanged: (value) {
                        // if (value != "Chose Role") { //
                        setState(() {
                          selectedRole = value!;
                          showRegistrationForm = true;
                        });
                        // }
                      },
                      items: ["Chose Role", "Customer", "Product Owner"]
                          .where((role) =>
                              role == selectedRole || role != "Chose Role")
                          .map((role) {
                        return DropdownMenuItem<String>(
                          child: Text(role),
                          value: role,
                        );
                      }).toList(),
                    ),
                  ],
                ),
                if (showRegistrationForm) _buildRegistrationForm(),
                // if (showRegistrationForm)
                //   if (selectedRole == "Customer")
                //     Column(
                //       children: [
                //         TextField(
                //           controller: fullNameController,
                //           decoration: InputDecoration(labelText: "Họ và Tên"),
                //         ),
                //         SizedBox(height: 10),
                //         TextField(
                //           controller: phoneController,
                //           decoration: InputDecoration(labelText: "Số điện thoại"),
                //         ),
                //         SizedBox(height: 10),
                //         TextField(
                //           controller: emailController,
                //           decoration: InputDecoration(labelText: "Email"),
                //         ),
                //         SizedBox(height: 10),
                //         TextField(
                //           controller: passwordController,
                //           decoration: InputDecoration(labelText: "Password"),
                //         ),
                //         SizedBox(height: 10),
                //       ],
                //     ),
                // if (selectedRole == "Product Owner")
                //   Column(
                //     children: [
                //       TextField(
                //         controller: fullNameController,
                //         decoration: InputDecoration(labelText: "Họ và Tên"),
                //       ),
                //       SizedBox(height: 10),
                //       TextField(
                //         controller: phoneController,
                //         decoration: InputDecoration(labelText: "Số điện thoại"),
                //       ),
                //       SizedBox(height: 10),
                //       TextField(
                //         controller: emailController,
                //         decoration: InputDecoration(labelText: "Email"),
                //       ),
                //       SizedBox(height: 10),
                //       TextField(
                //         controller: passwordController,
                //         decoration: InputDecoration(labelText: "Password"),
                //       ),
                //       SizedBox(height: 10),
                //       TextField(
                //         controller: passwordController,
                //         decoration: InputDecoration(labelText: "Địa chỉ"),
                //       ),
                //       SizedBox(height: 10),
                //     ],
                //   ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
