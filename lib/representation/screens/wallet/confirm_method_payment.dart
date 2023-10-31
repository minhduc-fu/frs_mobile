import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:frs_mobile/core/constants/color_constants.dart';
import 'package:frs_mobile/core/constants/my_textfield.dart';
import 'package:frs_mobile/core/constants/textstyle_constants.dart';
import 'package:frs_mobile/representation/widgets/button_widget.dart';

import '../../../core/constants/dismension_constants.dart';

class ConfirmMethodPayment extends StatefulWidget {
  @override
  State<ConfirmMethodPayment> createState() => _ConfirmMethodPaymentState();
}

class _ConfirmMethodPaymentState extends State<ConfirmMethodPayment> {
  TextEditingController _moneyToDeposit = TextEditingController();
  TextEditingController _transferInformation = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorPalette.backgroundScaffoldColor,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            FontAwesomeIcons.angleLeft,
            size: kDefaultIconSize18,
          ),
        ),
        title: Center(child: Text("Xác nhận thanh toán")),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Expanded(
              child: Column(
                children: [
                  Text('Số tiền cần nạp', style: TextStyles.h5.bold),
                  SizedBox(height: 10),
                  MyTextField(
                      textInputType: TextInputType.number,
                      controller: _moneyToDeposit,
                      hintText: 'Số tiền cần nạp',
                      obscureText: false),
                  SizedBox(height: 20),
                  Text(
                    'Thông tin chuyển khoản',
                    style: TextStyles.h5.bold,
                  ),
                  SizedBox(height: 10),
                  MyTextField(
                      controller: _transferInformation,
                      hintText: 'Thông tin chuyển khoản',
                      obscureText: false),
                ],
              ),
            ),
            ButtonWidget(
              title: 'Xác nhận',
              onTap: () {},
              height: 70,
              size: 18,
            ),
          ],
        ),
      ),
    );
  }
}
