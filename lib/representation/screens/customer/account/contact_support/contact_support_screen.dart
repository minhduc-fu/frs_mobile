import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:frs_mobile/core/constants/dismension_constants.dart';
import 'package:frs_mobile/core/constants/textstyle_constants.dart';
import 'package:frs_mobile/representation/widgets/button_widget.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../../core/constants/color_constants.dart';

class ContactSupportScreen extends StatelessWidget {
  const ContactSupportScreen({super.key});
  static const String routeName = '/contact_support_screen';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Container(
              color: ColorPalette.backgroundScaffoldColor,
              child: Icon(FontAwesomeIcons.angleLeft)),
        ),
        centerTitle: true,
        title: Text(
          'Liên hệ hỗ trợ',
          style: TextStyles.defaultStyle.bold.setTextSize(19),
        ),
        backgroundColor: ColorPalette.backgroundScaffoldColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Xin lỗi vì sự bất tiện này. Hãy gọi vào số điện thoại dưới đây để gặp nhân viên hỗ trợ cho bạn.',
              style: TextStyles.h5,
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(kDefaultCircle14),
                      border: Border.all(color: ColorPalette.textHide)),
                  child: Text('0916293863'),
                ),
                SizedBox(width: 10),
                ButtonWidget(
                  title: 'Gọi',
                  size: 18,
                  width: 100,
                  onTap: () {
                    _makePhoneCall('0916293863');
                  },
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(scheme: 'tel', path: phoneNumber);
    await launchUrl(launchUri);
  }
}
