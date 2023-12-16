import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:frs_mobile/core/constants/color_constants.dart';

import 'package:frs_mobile/core/constants/my_textformfield.dart';
import 'package:frs_mobile/core/constants/textstyle_constants.dart';
import 'package:frs_mobile/representation/screens/wallet/webview.dart';
import 'package:frs_mobile/representation/widgets/button_widget.dart';
import 'package:frs_mobile/services/authentication_service.dart';
import 'package:frs_mobile/services/authprovider.dart';

class RechargeScreen extends StatefulWidget {
  @override
  State<RechargeScreen> createState() => _RechargeScreenState();
}

class _RechargeScreenState extends State<RechargeScreen> {
  TextEditingController _moneyToDeposit = TextEditingController();
  late AuthProvider authProvider;

  void confirmPayment() async {
    final accountID = AuthProvider.userModel!.accountID;
    final amount = int.tryParse(_moneyToDeposit.text);

    if (amount != null &&
        amount > 0 &&
        validateAmount(_moneyToDeposit.text) == null) {
      final response = await AuthenticationService.submitOrder(
          accountID, amount, 'nap tien');

      if (response != null) {
        Navigator.of(context).push(CupertinoPageRoute(
            builder: ((context) => WebView(response: response))));
      }
    }
  }

  String? validateAmount(String? value) {
    if (value == null || value.isEmpty) {
      return 'Số tiền không được để trống';
    }

    try {
      int amount = int.parse(value);
      if (amount < 5000 || amount > 1000000000) {
        return 'Số tiền phải nằm trong khoảng từ 5000 vnđ đến 1 tỷ';
      }
    } catch (e) {
      return 'Số tiền không hợp lệ';
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorPalette.backgroundScaffoldColor,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Container(
            color: ColorPalette.backgroundScaffoldColor,
            child: Icon(
              FontAwesomeIcons.angleLeft,
            ),
          ),
        ),
        title: Text(
          "Xác nhận thanh toán",
          style: TextStyles.defaultStyle.setTextSize(19).bold,
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Số tiền cần nạp', style: TextStyles.h5.bold),
                  SizedBox(height: 10),
                  MyTextFormField(
                    controller: _moneyToDeposit,
                    hintText: 'Số tiền cần nạp',
                    keyboardType: TextInputType.number,
                    validator: validateAmount,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
            ButtonWidget(
              title: 'Xác nhận',
              onTap: confirmPayment,
              height: 70,
              size: 18,
            ),
          ],
        ),
      ),
    );
  }
}
