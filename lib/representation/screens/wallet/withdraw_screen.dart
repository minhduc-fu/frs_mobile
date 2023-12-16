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
import 'package:frs_mobile/utils/dialog_helper.dart';

class WithdrawScreen extends StatefulWidget {
  @override
  State<WithdrawScreen> createState() => _WithdrawScreenState();
}

class _WithdrawScreenState extends State<WithdrawScreen> {
  TextEditingController _moneyToDeposit = TextEditingController();
  late AuthProvider authProvider;

  void confirmPayment() async {
    final accountID = AuthProvider.userModel!.accountID;
    final amount = int.tryParse(_moneyToDeposit.text);
    final walletData =
        await AuthenticationService.getWalletByAccountID(accountID);

    if (amount != null &&
        amount > 0 &&
        validateAmount(_moneyToDeposit.text) == null) {
      if (amount > walletData!.balance.toInt()) {
        showCustomDialog(context, "Lỗi", "Số dư của bạn không đủ!", true);
      } else {
        final response = await AuthenticationService.submitOrder(
            accountID, amount, 'rut tien');

        if (response != null) {
          Navigator.of(context).push(CupertinoPageRoute(
              builder: ((context) => WebView(response: response))));
        }
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
        return 'Số tiền phải trong khoảng 5000 vnđ đến 1 tỷ';
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
                  Text('Số tiền cần rút', style: TextStyles.h5.bold),
                  SizedBox(height: 10),
                  MyTextFormField(
                    controller: _moneyToDeposit,
                    hintText: 'Số tiền cần rút',
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
