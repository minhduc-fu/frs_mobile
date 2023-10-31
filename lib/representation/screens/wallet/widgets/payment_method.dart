import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:frs_mobile/core/constants/textstyle_constants.dart';
import 'package:frs_mobile/representation/widgets/button_widget.dart';
import 'package:frs_mobile/utils/asset_helper.dart';
import 'package:frs_mobile/utils/image_helper.dart';

import '../../../../core/constants/color_constants.dart';
import '../../../../core/constants/dismension_constants.dart';
import '../confirm_method_payment.dart';

class PaymentMethod {
  static void showPaymentMethodDialog(BuildContext context) {
    String selectedPaymentMethod = "Chọn phương thức thanh toán";
    bool isPaymentConfirmed = false;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text(
                "Phương thức thanh toán",
                style: TextStyles.h4.bold,
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DropdownButton<String>(
                    elevation: 10,
                    borderRadius: BorderRadius.circular(kDefaultCircle14),
                    value: selectedPaymentMethod,
                    items: [
                      "Chọn phương thức thanh toán",
                      "Thanh toán với VN Pay",
                      "Khác"
                    ].map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Row(
                          children: [
                            if (value == "Thanh toán với VN Pay")
                              ClipRRect(
                                borderRadius:
                                    BorderRadius.circular(kDefaultCircle14),
                                child: ImageHelper.loadFromAsset(
                                    height: 25,
                                    width: 25,
                                    AssetHelper.imageVnpay,
                                    fit: BoxFit.cover),
                              ),
                            SizedBox(width: 10),
                            Text(value),
                          ],
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value == "Chọn phương thức thanh toán") {
                        return null;
                      } else {
                        setState(() {
                          selectedPaymentMethod = value!;
                          isPaymentConfirmed = true;
                        });
                      }
                    },
                  ),
                ],
              ),
              actions: <Widget>[
                ButtonWidget(
                  title: "Hủy",
                  size: 18,
                  height: 40,
                  width: 120,
                  onTap: () {
                    setState(() {
                      selectedPaymentMethod = "Chọn phương thức thanh toán";
                    });
                    Navigator.of(context).pop();
                  },
                ),
                ButtonWidget(
                  title: "Xác nhận",
                  size: 18,
                  height: 40,
                  width: 120,
                  onTap: () {
                    if (selectedPaymentMethod !=
                            "Chọn phương thức thanh toán" &&
                        isPaymentConfirmed) {
                      Navigator.of(context).push(CupertinoPageRoute(
                        builder: (context) => ConfirmMethodPayment(),
                      ));
                    }
                  },
                ),
                // TextButton(
                //   onPressed: () {
                //     if (selectedPaymentMethod !=
                //             "Chọn phương thức thanh toán" &&
                //         isPaymentConfirmed) {
                //       Navigator.of(context).push(CupertinoPageRoute(
                //         builder: (context) => ConfirmMethodPayment(),
                //       ));
                //     }
                //   },
                //   child: Text("Xác nhận"),
                // ),
              ],
              shape: OutlineInputBorder(
                borderRadius: BorderRadius.circular(kDefaultCircle14),
                borderSide: BorderSide.none,
              ),
            );
          },
        );
      },
    );
  }
}
