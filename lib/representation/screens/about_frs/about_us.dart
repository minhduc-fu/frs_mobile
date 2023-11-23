import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:frs_mobile/core/constants/color_constants.dart';
import 'package:frs_mobile/core/constants/dismension_constants.dart';
import 'package:frs_mobile/core/constants/textstyle_constants.dart';
import 'package:frs_mobile/utils/asset_helper.dart';
import 'package:frs_mobile/utils/image_helper.dart';

class AboutUs extends StatelessWidget {
  const AboutUs({super.key});
  static const String routeName = '/about_us';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorPalette.backgroundScaffoldColor,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(FontAwesomeIcons.angleLeft),
        ),
        title: Center(
          child: Text('Về chúng tôi'),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                  color: ColorPalette.primaryColor,
                  borderRadius: BorderRadius.circular(kDefaultCircle14)),
              padding: EdgeInsets.all(10),
              height: 230,
              width: double.infinity,
              child: Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(kDefaultCircle14),
                  child: Opacity(
                    opacity: 0.2,
                    child: ImageHelper.loadFromAsset(AssetHelper.imageAboutUs,
                        fit: BoxFit.cover),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            Text(
              'FRS là nền tảng thương mại điện tử hàng đầu trong tim chúng tôi',
              style: TextStyles.h4,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 10),
            Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(kDefaultCircle14),
              ),
              child: Column(
                children: [
                  Text(
                    'Ra mắt năm 2023, nền tảng thương mại FRS được xây dựng nhằm cung cấp cho người dùng những dịch vụ thuê và mua các mặt hàng thời trang hàng hiệu cao cấp.',
                  ),
                  Text(
                    'Chúng tôi có niềm tin mạnh mẽ rằng khi bạn sử dụng dịch vụ của FRS sẽ tiết kiệm được một khoản tiền lớn và đa dạng phong phú với phong cách ăn mặc của bản thân.',
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                    child: _build(
                        ImageHelper.loadFromAsset(AssetHelper.imageGanGui,
                            width: kBottomBarIconSize20,
                            height: kBottomBarIconSize20),
                        Colors.red,
                        'Thân thiện',
                        'subTitle')),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

Widget _build(Widget icon, Color color, String title, String subTitle) {
  return Column(
    children: [
      Container(
        padding: EdgeInsets.symmetric(vertical: kMediumPadding24),
        decoration: BoxDecoration(
          color: color.withOpacity(0.2),
          borderRadius: BorderRadius.circular(kDefaultCircle14),
        ),
        child: icon,
      ),
      SizedBox(
        height: kItemPadding10,
      ),
      Text(title),
      Text(subTitle),
    ],
  );
}
