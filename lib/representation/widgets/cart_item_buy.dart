import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../core/constants/color_constants.dart';
import '../../core/constants/dismension_constants.dart';
import '../../core/constants/textstyle_constants.dart';
import '../../utils/asset_helper.dart';
import '../../utils/image_helper.dart';

class CartItemBuy extends StatelessWidget {
  final List<Widget> imageList = [
    // ImageHelper.loadFromAsset(AssetHelper.imageBanner1),
    // ImageHelper.loadFromAsset(AssetHelper.imageBanner2),
    // ImageHelper.loadFromAsset(AssetHelper.imageBanner3),
    // ImageHelper.loadFromAsset(AssetHelper.imageAoKhoacGucci),
    // ImageHelper.loadFromAsset(AssetHelper.imgaeAoVersace),
    // ImageHelper.loadFromAsset(AssetHelper.imageDior),
    ImageHelper.loadFromAsset(AssetHelper.imageChanel, fit: BoxFit.fill),
    ImageHelper.loadFromAsset(AssetHelper.imageKinhGucci),
    ImageHelper.loadFromAsset(AssetHelper.imageQuanVersace),
    ImageHelper.loadFromAsset(AssetHelper.imageLV),
  ];
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: ScrollPhysics(),
      // physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: imageList.length,
      itemBuilder: (context, index) {
        return Container(
          margin: EdgeInsets.only(top: 10),
          padding: EdgeInsets.all(10),
          height: 110,
          // margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
          // padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: ColorPalette.hideColor,
            borderRadius: BorderRadius.circular(kDefaultCircle14),
          ),
          child: Row(
            children: [
              // checkbox
              SizedBox(
                height: 20,
                width: 20,
                child: Checkbox(
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  activeColor: ColorPalette.primaryColor,
                  value: true,
                  onChanged: (value) {},
                ),
              ),
              SizedBox(width: 10),
              // ảnh sản phẩm
              Container(
                height: 80,
                width: 80,
                decoration: BoxDecoration(
                  color: ColorPalette.backgroundScaffoldColor,
                  borderRadius: BorderRadius.circular(kDefaultCircle14),
                ),
                child: imageList[index],
              ),
              SizedBox(width: 10),
              // Tên sản phẩm, best selling, giá tiền
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Tên Sản phẩm',
                    style: TextStyles.h5.bold,
                  ),
                  Text(
                    'Số lượng hàng còn:',
                  ),
                  Text(
                    'Giá tiền',
                    style: TextStyles.defaultStyle.bold
                        .setColor(ColorPalette.primaryColor),
                  ),
                ],
              ),
              Spacer(),

              // delete,
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // delete
                  Icon(FontAwesomeIcons.trashCan),

                  // + -
                  Row(
                    children: [
                      // trừ
                      Container(
                        padding: EdgeInsets.all(7),
                        decoration: BoxDecoration(
                          color: ColorPalette.primaryColor,
                          borderRadius: BorderRadius.circular(kDefaultCircle14),
                        ),
                        child: Icon(
                          CupertinoIcons.minus,
                          color: ColorPalette.hideColor,
                        ),
                      ),
                      SizedBox(width: 5),
                      Text('01'),
                      SizedBox(width: 5),

                      // +
                      Container(
                        padding: EdgeInsets.all(7),
                        decoration: BoxDecoration(
                          color: ColorPalette.primaryColor,
                          borderRadius: BorderRadius.circular(kDefaultCircle14),
                        ),
                        child: Icon(
                          CupertinoIcons.plus,
                          color: ColorPalette.hideColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
