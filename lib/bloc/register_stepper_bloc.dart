import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../core/constants/color_constants.dart';
import '../core/constants/dismension_constants.dart';

class RegisterStepperBloc {
  static Future<String?> showRoleBottomSheet(BuildContext context) async {
    String selectedRole = 'Chọn vai trò';
    final result = await showModalBottomSheet<String>(
      elevation: 0,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(kDefaultCircle14)),
      backgroundColor: ColorPalette.backgroundScaffoldColor,
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 250,
          child: Column(
            children: [
              SizedBox(height: 20),
              Center(
                child: Container(
                  decoration: BoxDecoration(
                      color: ColorPalette.primaryColor,
                      borderRadius: BorderRadius.circular(kDefaultCircle14)),
                  height: 7,
                  width: 50,
                ),
              ),
              SizedBox(height: 20),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 25, vertical: 8),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(kDefaultCircle14),
                    border: Border.all(color: ColorPalette.textHide),
                  ),
                  child: ListTile(
                    title: Center(
                      child: Text('Customer'),
                    ),
                    onTap: () {
                      Navigator.pop(context, 'Customer');
                    },
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 25, vertical: 8),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
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

    if (result != null) {
      selectedRole = result;
    }

    return selectedRole;
  }

  static Future<bool?> showGenderBottomSheet(BuildContext context) async {
    bool? isMale;
    final result = await showModalBottomSheet(
      elevation: 0,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(kDefaultCircle14)),
      backgroundColor: ColorPalette.backgroundScaffoldColor,
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 250,
          child: Column(
            children: [
              SizedBox(height: 20),
              Center(
                child: Container(
                  decoration: BoxDecoration(
                      color: ColorPalette.primaryColor,
                      borderRadius: BorderRadius.circular(kDefaultCircle14)),
                  height: 7,
                  width: 50,
                ),
              ),
              SizedBox(height: 20),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 25, vertical: 8),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(kDefaultCircle14),
                    border: Border.all(color: ColorPalette.textHide),
                  ),
                  child: ListTile(
                    title: Center(child: Text('Nam')),
                    onTap: () {
                      Navigator.pop(context, false); // chọn giới tính là Nam
                    },
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 25, vertical: 8),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(kDefaultCircle14),
                    border: Border.all(color: ColorPalette.textHide),
                  ),
                  child: ListTile(
                    title: Center(child: Text('Nữ')),
                    onTap: () {
                      Navigator.pop(context, true);
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );

    if (result != null) {
      isMale = result;
    }

    return isMale;
  }
}
