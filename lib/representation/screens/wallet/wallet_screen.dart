import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:frs_mobile/core/constants/color_constants.dart';
import 'package:frs_mobile/core/constants/textstyle_constants.dart';
import 'package:frs_mobile/representation/screens/wallet/confirm_method_payment.dart';

import '../../../core/constants/dismension_constants.dart';
import '../../widgets/button_widget.dart';
import 'widgets/payment_method.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});
  static const String routeName = '/wallet_screen';
  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // elevation: 0,
        backgroundColor: ColorPalette.backgroundScaffoldColor,
        title: Center(child: Text('Ví của bạn')),
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            FontAwesomeIcons.angleLeft,
            size: kDefaultIconSize18,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            SizedBox(height: 20),
            Expanded(
              child: ListView(
                children: [
                  Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(kDefaultCircle14),
                        color: ColorPalette.hideColor),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Số dư trong ví',
                          style: TextStyles.h5.bold,
                        ),
                        SizedBox(height: 10),
                        Text(
                          '0 vnđ',
                          style: TextStyles.h4.bold,
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(kDefaultCircle14),
                        color: ColorPalette.hideColor),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Lịch sử giao dịch',
                              style: TextStyles.h5.bold,
                            ),
                            SizedBox(height: 10),
                            Text('10 giao dịch đã được thực hiện')
                          ],
                        ),
                        Icon(FontAwesomeIcons.angleRight),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            ButtonWidget(
              title: 'Nạp tiền vào ví',
              onTap: () {
                PaymentMethod.showPaymentMethodDialog(context);
              },
              height: 70,
              size: 18,
            ),
            SizedBox(height: 20)
          ],
        ),
      ),
    );
  }
}
