import 'package:carousel_slider/carousel_slider.dart';
import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:frs_mobile/models/product_detail_model.dart';
import 'package:frs_mobile/models/product_image_model.dart';
import 'package:intl/intl.dart';
import 'package:frs_mobile/core/extensions/date_ext.dart';

import '../../core/constants/color_constants.dart';
import '../../core/constants/dismension_constants.dart';
import '../../core/constants/textstyle_constants.dart';

import '../../models/productOwner_model.dart';
import '../../utils/asset_helper.dart';
import '../../utils/dialog_helper.dart';
import '../../utils/image_helper.dart';
import '../widgets/button_widget.dart';
import '../widgets/container_decoration.dart';
import '../widgets/indicator_widget.dart';
import 'select_date_screen.dart';

class ProductDetailDemo extends StatefulWidget {
  final ProductDetailModel? productDetailModel;
  final ProductOwnerModel? productOwnerModel;
  final List<ProductImageModel>? productImageModel;
  const ProductDetailDemo({
    super.key,
    required this.productDetailModel,
    required this.productOwnerModel,
    required this.productImageModel,
  });
  static const String routeName = '/product_detail_demo';
  @override
  State<ProductDetailDemo> createState() => _ProductDetailDemoState();
}

class _ProductDetailDemoState extends State<ProductDetailDemo> {
  final CarouselController _controller = CarouselController();

  bool? isRenting = null;
  bool isBuy = true;
  bool isRentalPeriodSelected = false;
  int selectedRentalPeriod = 0;
  String? dateSelected;

  void toggleRenting(bool? value) {
    setState(() {
      isRenting = value ?? false;
    });
  }

  int _currentIndexBanner = 0;
  final List<Widget> _bannerImages = [
    ImageHelper.loadFromAsset(AssetHelper.imageBanner1),
    ImageHelper.loadFromAsset(AssetHelper.imageBanner2),
    ImageHelper.loadFromAsset(AssetHelper.imageBanner3),
  ];

  @override
  Widget build(BuildContext context) {
    final productDetailModel = widget.productDetailModel;
    final productOwnerModel = widget.productOwnerModel;
    final List<ProductImageModel>? productImages = widget.productImageModel;
    Size size = MediaQuery.of(context).size; // get screen size
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Chi tiết sản phẩm')),
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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: ListView(
                children: [
                  // load ảnh productDetail
                  CarouselSlider.builder(
                    carouselController: _controller,
                    itemCount: productImages!.length,
                    itemBuilder:
                        (BuildContext context, int index, int realIndex) {
                      return Container(
                        margin: EdgeInsets.all(5.0),
                        child: ClipRRect(
                            borderRadius: BorderRadius.all(
                                Radius.circular(kDefaultCircle14)),
                            child: Stack(
                              children: <Widget>[
                                // _bannerImages[index],
                                Image.network(
                                  productImages[index].imgUrl,
                                  // fit: BoxFit.contain,
                                  fit: BoxFit.cover,
                                  width: 1000.0,
                                ),
                                Positioned(
                                  bottom: 0.0,
                                  left: 0.0,
                                  right: 0.0,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          Color.fromARGB(200, 0, 0, 0),
                                          Color.fromARGB(0, 0, 0, 0)
                                        ],
                                        begin: Alignment.bottomCenter,
                                        end: Alignment.topCenter,
                                      ),
                                    ),
                                    padding: EdgeInsets.symmetric(
                                        vertical: 10.0, horizontal: 20.0),
                                    child: Text('No. ${index + 1} image',
                                        style: TextStyles.defaultStyle
                                            .setTextSize(20)
                                            .bold
                                            .setColor(Colors.white)),
                                  ),
                                ),
                              ],
                            )),
                      );
                    },
                    options: CarouselOptions(
                      autoPlay: false,
                      enlargeCenterPage: true, // phóng to trung tâm trang
                      // height: 200,
                      aspectRatio: 16 / 9,
                      onPageChanged: (index, reason) {
                        setState(() {
                          _currentIndexBanner = index;
                        });
                      },
                    ),
                  ),
                  SizedBox(height: 10),
                  // cục indicator
                  Center(
                    child: Container(
                      height: 8,
                      // margin: EdgeInsets.symmetric(vertical: 13, horizontal: 30), //
                      child: ListView.builder(
                        // nằm giữa hay không là nó nằm ở shrinWrap này nè
                        shrinkWrap:
                            true, // Cho phép ListView.builder co lại theo nội dung
                        itemCount: productImages.length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          return buildIndicator(
                              index == _currentIndexBanner, size);
                        },
                      ),
                    ),
                  ),
                  SizedBox(height: 10),

                  // thông tin sản phẩm
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(kDefaultCircle14),
                        color: ColorPalette.hideColor),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Tên sẩn phẩm
                          Text(
                            productDetailModel!.productName,
                            style: TextStyles.h4.bold,
                          ),
                          SizedBox(height: 10),

                          // Mô tả
                          ExpandableText(
                            // 'Sản phẩm này đã dùng là có người yêu. Không nói điêu, chỉ có chiêu, điệu đà và nhiệt tình đấy, đừng chần chừ. Nó mang lại sự thuận tiện, giúp cuộc sống thêm phần tiện lợi.Tạo nên trải nghiệm tuyệt vời, cho mọi người trong gia đình này.',
                            productDetailModel.description,
                            expandText: 'Xem thêm',
                            linkColor: Colors.blue,
                            collapseText: 'Thu gọn',
                            maxLines: 2,
                            style: TextStyles.defaultStyle.setColor(
                              ColorPalette.textColor.withOpacity(0.6),
                            ),
                          ),
                          SizedBox(height: 10),

                          // Thương hiệu và Kích thước
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // Thương hiệu
                              Column(
                                children: [
                                  Text(
                                    'Thương hiệu',
                                    style: TextStyles.h5.bold,
                                  ),
                                  SizedBox(height: 10),
                                  customContainer(
                                    Text(
                                      '${productDetailModel.productSpecificationData != null ? (productDetailModel.productSpecificationData?['brandName'] ?? "N/A") : "N/A"}',
                                      style: TextStyles
                                          .defaultStyle.whiteTextColor,
                                    ),
                                  ),
                                ],
                              ),

                              // Kích thước
                              Column(
                                children: [
                                  Text(
                                    'Kích thước',
                                    style: TextStyles.h5.bold,
                                  ),
                                  SizedBox(height: 10),
                                  customContainer(
                                    Text(
                                      'M',
                                      style: TextStyles
                                          .defaultStyle.whiteTextColor,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(height: 10),

                          // Đánh giá
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                children: [
                                  Text(
                                    'Đánh giá',
                                    style: TextStyles.h5.bold,
                                  ),
                                  SizedBox(height: 10),
                                  Row(
                                    children: [
                                      Icon(
                                        FontAwesomeIcons.solidStar,
                                        color: Colors.amber,
                                        size: kDefaultPadding16,
                                      ),
                                      SizedBox(width: 10),
                                      Text('5.0'),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  // thông tin PO
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(kDefaultCircle14),
                        color: ColorPalette.hideColor),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // avt, tên chủ tiệm và button liên hệ
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              //avt chủ tiệm
                              Row(
                                children: [
                                  CircleAvatar(
                                    radius: 20,
                                    backgroundImage: AssetImage(
                                        AssetHelper.imageCircleAvtMain),
                                  ),
                                  SizedBox(width: 10),
                                  Text(
                                    // 'cc',
                                    productOwnerModel!.fullName,
                                    style: TextStyles.h5.bold,
                                  ),
                                ],
                              ),

                              // Button liên hệ
                              GestureDetector(
                                onTap: () {},
                                child: Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(
                                          kDefaultCircle14),
                                      color: ColorPalette.primaryColor),
                                  child: Row(
                                    children: [
                                      Icon(
                                        FontAwesomeIcons.solidMessage,
                                        color: Colors.white,
                                      ),
                                      SizedBox(width: 10),
                                      Text(
                                        'Liên hệ',
                                        style: TextStyles
                                            .defaultStyle.whiteTextColor,
                                      )
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                          SizedBox(height: 10),
                          Row(
                            children: [
                              Icon(
                                FontAwesomeIcons.solidStar,
                                color: Colors.amber,
                                size: kDefaultPadding16,
                              ),
                              SizedBox(width: 10),
                              Text('5.0'),
                              Text(' | '),
                              Icon(
                                FontAwesomeIcons.solidMessage,
                                size: kDefaultPadding16,
                              ),
                              SizedBox(width: 10),
                              Text('99.0%'),
                            ],
                          ),
                          SizedBox(height: 10),
                          Row(
                            children: [
                              Icon(FontAwesomeIcons.locationDot),
                              SizedBox(width: 10),
                              Text(productOwnerModel.address)
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 20),

                  // những bài đánh giá
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(kDefaultCircle14),
                        color: ColorPalette.hideColor),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 10),
                      child: Column(
                        children: [
                          // Khách hàng đánh giá
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.circular(kDefaultCircle14),
                              border: Border.all(color: ColorPalette.textHide),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      FontAwesomeIcons.solidStar,
                                      color: Colors.amber,
                                    ),
                                    SizedBox(width: 10),
                                    Text(
                                      'Khách hàng đánh giá',
                                      style: TextStyles.h5.bold,
                                    ),
                                  ],
                                ),
                                Text(
                                  '3 đánh giá',
                                  style: TextStyles.defaultStyle
                                      .setColor(Colors.blue),
                                )
                              ],
                            ),
                          ),
                          SizedBox(height: 10),

                          // List đánh giá
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.circular(kDefaultCircle14),
                              border: Border.all(color: ColorPalette.textHide),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      'Tên khách hàng',
                                      style: TextStyles.defaultStyle.bold,
                                    ),
                                    SizedBox(height: 10),
                                  ],
                                ),
                                SizedBox(height: 10),
                                Row(
                                  children: [
                                    Text('03:18'),
                                    Text(' | '),
                                    Text('05/06/2023'),
                                  ],
                                ),
                                SizedBox(height: 10),
                                Text('Tên sản phẩm'),
                                SizedBox(height: 10),
                                Text(
                                  'Description của đánh giá',
                                  style: TextStyles.defaultStyle.setColor(
                                      ColorPalette.textColor.withOpacity(0.6)),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          SizedBox(height: 10),

          // cục ở dưới màn hình gồm Thuê và Mua
          Container(
            decoration: BoxDecoration(
              color: ColorPalette.backgroundScaffoldColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(kDefaultCircle14),
                topRight: Radius.circular(kDefaultCircle14),
              ),
            ),
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                // Thuê
                Container(
                  decoration: BoxDecoration(
                    color: ColorPalette.hideColor,
                    borderRadius: BorderRadius.circular(kDefaultCircle14),
                    border: Border.all(color: ColorPalette.textHide),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Radio(
                                  materialTapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                  activeColor: ColorPalette.primaryColor,
                                  value: true,
                                  groupValue: isRenting,
                                  onChanged: toggleRenting),
                              Text(
                                'Thuê',
                                style: TextStyles.defaultStyle.bold,
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 12),
                            child: Text(
                              'Giá thuê',
                            ),
                          ),
                        ],
                      ),
                      // Hiển thị thông tin thuê nếu đang ở trạng thái Thuê
                      Visibility(
                        visible: isRenting == true,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // giai đoạn thuê
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 12),
                              child: Text('Giai đoạn thuê: '),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      selectedRentalPeriod = 4;
                                      isRentalPeriodSelected = true;
                                    });
                                  },
                                  child: Row(
                                    children: [
                                      Radio(
                                        activeColor: ColorPalette.primaryColor,
                                        value: 4,
                                        groupValue: selectedRentalPeriod,
                                        onChanged: (value) {
                                          setState(() {
                                            selectedRentalPeriod = value as int;
                                            isRentalPeriodSelected = true;
                                          });
                                        },
                                      ),
                                      Text('4 ngày'),
                                    ],
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      selectedRentalPeriod = 7;
                                      isRentalPeriodSelected = true;
                                    });
                                  },
                                  child: Row(
                                    children: [
                                      Radio(
                                        activeColor: ColorPalette.primaryColor,
                                        value: 7,
                                        groupValue: selectedRentalPeriod,
                                        onChanged: (value) {
                                          setState(() {
                                            selectedRentalPeriod = value as int;
                                            isRentalPeriodSelected = true;
                                          });
                                        },
                                      ),
                                      Text('7 ngày'),
                                    ],
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      selectedRentalPeriod = 10;
                                      isRentalPeriodSelected = true;
                                    });
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.only(right: 12),
                                    child: Row(
                                      children: [
                                        Radio(
                                          activeColor:
                                              ColorPalette.primaryColor,
                                          value: 10,
                                          groupValue: selectedRentalPeriod,
                                          onChanged: (value) {
                                            setState(() {
                                              selectedRentalPeriod =
                                                  value as int;
                                              isRentalPeriodSelected = true;
                                            });
                                          },
                                        ),
                                        Text('10 ngày'),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            if (isRentalPeriodSelected)
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12),
                                    child: Text(
                                      'Thuê với giá 123đ',
                                      style: TextStyles.defaultStyle.bold,
                                    ),
                                  ),
                                  SizedBox(height: kItemPadding10),
                                  // Chọn ngày thuê
                                  StatefulBuilder(
                                    builder: (context, setState) {
                                      return GestureDetector(
                                        onTap: () async {
                                          final selectDate =
                                              await Navigator.of(context).push(
                                            CupertinoPageRoute(
                                              builder: (context) =>
                                                  SelectDateScreen(
                                                selectedRentalPeriod:
                                                    selectedRentalPeriod,
                                              ),
                                            ),
                                          );
                                          if (selectDate != null &&
                                              selectDate is List<DateTime?> &&
                                              !(selectDate as List<DateTime?>)
                                                  .any((element) =>
                                                      element == null)) {
                                            dateSelected =
                                                '${selectDate[0]?.getStartDate} - ${selectDate[1]?.getEndDate}';
                                            setState(() {});
                                          } else {
                                            dateSelected = null;
                                            setState(() {});
                                          }
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 12),
                                          child: Container(
                                            padding: const EdgeInsets.all(10),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      kDefaultCircle14),
                                              border: Border.all(
                                                  color: ColorPalette.textHide),
                                            ),
                                            child: Row(
                                              children: [
                                                Icon(FontAwesomeIcons
                                                    .calendarDays),
                                                SizedBox(width: kItemPadding10),
                                                Text(
                                                  'Chọn ngày:',
                                                ),
                                                SizedBox(width: kItemPadding10),
                                                Text(
                                                  dateSelected ??
                                                      'Chưa chọn ngày',
                                                  style: TextStyles
                                                      .defaultStyle.bold,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            SizedBox(height: 10),

                            // add to cart button
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 12),
                              child: ButtonWidget(
                                title: 'Thêm vào giỏ hàng Thuê',
                                onTap: () {
                                  if (dateSelected != null) {
                                  } else {
                                    showCustomDialog(context, 'Error',
                                        'Làm ơn chọn ngày thuê!');
                                  }
                                },
                                height: 70,
                                size: 18,
                              ),
                            ),
                            SizedBox(height: 10),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10),

                // Mua
                if (isBuy)
                  Container(
                    decoration: BoxDecoration(
                      color: ColorPalette.hideColor,
                      borderRadius: BorderRadius.circular(kDefaultCircle14),
                      border: Border.all(color: ColorPalette.textHide),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Radio(
                                    materialTapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                    activeColor: ColorPalette.primaryColor,
                                    value: false,
                                    groupValue: isRenting,
                                    onChanged: toggleRenting),
                                Text(
                                  'Mua',
                                  style: TextStyles.defaultStyle.bold,
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 12),
                              child: Text(
                                ' ${NumberFormat.currency(locale: 'vi_VN', symbol: 'đ').format(productDetailModel.price)}',
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Visibility(
                            visible: isRenting == false,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 20),
                                // add to cart button
                                ButtonWidget(
                                  title: 'Thêm vào giỏ hàng Mua',
                                  onTap: () {},
                                  height: 70,
                                  size: 18,
                                ),
                                SizedBox(height: 10),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
