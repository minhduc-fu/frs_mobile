import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:frs_mobile/core/constants/color_constants.dart';
import 'package:frs_mobile/core/constants/textstyle_constants.dart';
import 'package:frs_mobile/representation/screens/wallet/transaction_history/transaction_history.dart';
import 'package:frs_mobile/services/authentication_service.dart';
import 'package:frs_mobile/services/authprovider.dart';
import 'package:intl/intl.dart';

import '../../../core/constants/dismension_constants.dart';
import '../../../models/wallet_model.dart';
import '../../widgets/button_widget.dart';
import 'widgets/payment_method.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});
  static const String routeName = '/wallet_screen';

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  WalletModel? wallet;
  String transactionCountText = '';
  List<dynamic>? transactions;
  @override
  void initState() {
    super.initState();
    print(AuthProvider.userModel!.accountID);
    fetchWalletData();
  }

  Future<void> fetchWalletData() async {
    final accountID = AuthProvider.userModel!.accountID;
    try {
      final walletData =
          await AuthenticationService.getWalletByAccountID(accountID);
      final transactionData =
          await AuthenticationService.getAllTransactionByAccountID(accountID);

      setState(() {
        wallet = walletData;
        transactions = transactionData;
        final transactionCount = transactionData?.length ?? 0;
        transactionCountText = '$transactionCount giao dịch đã được thực hiện';
      });
    } catch (e) {
      print('Không thể getWalletByAccountID: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    // print("WalletScreen is being rebuilt");
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
                          // '0',
                          '${NumberFormat.currency(locale: 'vi_VN', symbol: 'vnđ').format(wallet?.balance ?? 0)}',
                          style: TextStyles.h4.bold,
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(CupertinoPageRoute(
                          builder: (Context) => TransactionHistory(
                                transactions: transactions,
                              )));
                    },
                    child: Container(
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
                              Text(transactionCountText),
                            ],
                          ),
                          Icon(FontAwesomeIcons.angleRight),
                        ],
                      ),
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
