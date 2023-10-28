import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../core/constants/color_constants.dart';
import '../core/constants/dismension_constants.dart';

class RegisterStepperBloc {
  static Future<String?> showRoleBottomSheet(BuildContext context) async {
    String selectedRole = 'Chọn vai trò';
    final result = await showModalBottomSheet<String>(
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

    if (result != null) {
      selectedRole = result;
    }

    return selectedRole;
  }

  static Future<bool?> showGenderBottomSheet(BuildContext context) async {
    bool? isMale;
    final result = await showModalBottomSheet(
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
                    color: ColorPalette.backgroundScaffoldColor,
                    borderRadius: BorderRadius.circular(kDefaultCircle14),
                    border: Border.all(color: ColorPalette.textHide),
                  ),
                  child: ListTile(
                    title: Text('Nữ'),
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
