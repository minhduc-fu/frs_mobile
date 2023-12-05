import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:frs_mobile/core/constants/color_constants.dart';
import 'package:frs_mobile/core/constants/dismension_constants.dart';
import 'package:frs_mobile/core/constants/textstyle_constants.dart';
import 'package:frs_mobile/models/transaction_model.dart';
import 'package:intl/intl.dart';

class TransactionHistory extends StatelessWidget {
  final List<dynamic>? transactions;
  const TransactionHistory({super.key, required this.transactions});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: ColorPalette.backgroundScaffoldColor,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Container(
              color: ColorPalette.backgroundScaffoldColor,
              child: Icon(FontAwesomeIcons.angleLeft)),
        ),
        title: Text(
          'Lịch sử giao dịch',
          style: TextStyles.defaultStyle.bold.setTextSize(19),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            transactions != []
                ? Expanded(
                    child: ListView(
                      children: [
                        ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: transactions!.length,
                          itemBuilder: (context, index) {
                            final transaction =
                                TransactionModel.fromJson(transactions![index]);
                            return Container(
                              margin: EdgeInsets.only(bottom: 10),
                              decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.circular(kDefaultCircle14),
                                  color: Colors.white),
                              child: ListTile(
                                leading:
                                    Icon(FontAwesomeIcons.moneyBillTransfer),
                                title: Text(
                                  transaction.description,
                                  style: TextStyles.h5.bold,
                                ),
                                contentPadding:
                                    EdgeInsets.symmetric(horizontal: 16),
                                subtitle: Text(
                                  '${NumberFormat.currency(locale: 'vi_VN', symbol: 'vnđ').format(transaction.amount)}',
                                ),
                                trailing: Text(
                                  '${DateFormat.yMd().format(transaction.transactionDate)}',
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  )
                : Text('Bạn chưa có giao dịch nào.')
          ],
        ),
      ),
    );
  }
}
