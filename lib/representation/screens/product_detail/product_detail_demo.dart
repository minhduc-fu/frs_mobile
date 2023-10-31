import 'package:carousel_slider/carousel_slider.dart';
import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:frs_mobile/models/product_detail_model.dart';
import 'package:frs_mobile/models/product_image_model.dart';
import 'package:frs_mobile/representation/screens/product_detail/bloc/product_detail_bloc.dart';
import 'package:frs_mobile/representation/screens/product_detail/full_screen_receipt.dart';
import 'package:frs_mobile/representation/screens/product_detail/widgets/image_slider.dart';
import 'package:frs_mobile/representation/widgets/app_bar_main.dart';
import 'package:intl/intl.dart';
import 'package:frs_mobile/core/extensions/date_ext.dart';
import '../../../core/constants/color_constants.dart';
import '../../../core/constants/dismension_constants.dart';
import '../../../core/constants/textstyle_constants.dart';
import '../../../models/productOwner_model.dart';
import '../../../utils/dialog_helper.dart';
import '../../widgets/button_widget.dart';
import '../../widgets/indicator_widget.dart';
import '../select_date_screen.dart';

class ProductDetailDemo extends StatefulWidget {
  final ProductDetailModel? productDetailModel;
  final ProductOwnerModel? productOwnerModel;
  final List<ProductImageModel> productImageModel;
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

  bool isBuy = true;
  bool isRentalPeriodSelected = false;
  int selectedRentalPeriod = 0;
  String? dateSelected;

  bool? isRenting = null;
  void toggleRenting(bool? value) {
    setState(() {
      isRenting = value ?? false;
    });
  }

  int _currentImage = 0;

  @override
  Widget build(BuildContext context) {
    final productDetailModel = widget.productDetailModel;
    final productOwnerModel = widget.productOwnerModel;
    final List<ProductImageModel> productImages = widget.productImageModel;
    double rentalPrice1 = productDetailModel!.rentalPrice?.rentPrice1 ?? 0.0;
    final String checkType = productDetailModel.checkType;
    Size size = MediaQuery.of(context).size; // get screen size
    return AppBarMain(
      titleAppbar: 'Chi tiết sản phẩm',
      leading: GestureDetector(
        onTap: () {
          Navigator.pop(context);
        },
        child: Icon(
          FontAwesomeIcons.angleLeft,
          size: kDefaultIconSize18,
        ),
      ),
      child: Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: ListView(
                  children: [
                    // load ảnh productDetail
                    ImageSlider(
                      productImages: productImages,
                      currentImage: _currentImage,
                      onPageChanged: (int index) {
                        setState(() {
                          _currentImage = index;
                        });
                      },
                      carouselController: _controller,
                    ),
                    SizedBox(height: 10),
                    // cục indicator
                    Center(
                      child: Container(
                        height: 8,
                        child: ListView.builder(
                          // nằm giữa hay không là nó nằm ở shrinWrap này nè. Cho phép ListView co lại theo nội dung
                          shrinkWrap: true,
                          itemCount: productImages.length,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            return buildIndicator(index == _currentImage, size);
                          },
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    // information product
                    Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(kDefaultCircle14),
                          color: ColorPalette.hideColor),
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // name product
                            Text(
                              productDetailModel.productName,
                              style: TextStyles.h4.bold,
                            ),
                            SizedBox(height: 10),
                            // description
                            ExpandableText(
                              productDetailModel.description,
                              expandText: 'Xem thêm',
                              linkColor: Colors.blue,
                              collapseText: 'Thu gọn',
                              maxLines: 2,
                              style: TextStyles.defaultStyle.setColor(
                                // ColorPalette.textColor.withOpacity(0.6),
                                ColorPalette.grey3,
                              ),
                            ),
                            SizedBox(height: 10),
                            // brand, madeof
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Thương hiệu',
                                      style: TextStyles.h5.bold,
                                    ),
                                    SizedBox(height: 10),
                                    Text(
                                      '${productDetailModel.productSpecificationData != null ? (productDetailModel.productSpecificationData?['brandName'] ?? "N/A") : "N/A"}',
                                    )
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      'Chất liệu',
                                      style: TextStyles.h5.bold,
                                    ),
                                    SizedBox(height: 10),
                                    Text(
                                      '${productDetailModel.productSpecificationData != null ? (productDetailModel.productSpecificationData?['madeOf'] ?? "N/A") : "N/A"}',
                                    )
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(height: 10),
                            // condition, rate
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Tình trạng',
                                      style: TextStyles.h5.bold,
                                    ),
                                    SizedBox(height: 10),
                                    Text(productDetailModel.productCondition),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
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
                            SizedBox(height: 10),
                            //productReceiptUrl
                            Text(
                              'Hóa đơn',
                              style: TextStyles.h5.bold,
                            ),
                            SizedBox(height: 10),
                            GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(
                                  CupertinoPageRoute(
                                    builder: (context) => FullScreenReceipt(
                                        productReceiptUrl: productDetailModel
                                            .productReceiptUrl),
                                  ),
                                );
                              },
                              child: ClipRRect(
                                borderRadius:
                                    BorderRadius.circular(kDefaultCircle14),
                                child: Image.network(
                                  cacheHeight: 100,
                                  cacheWidth: 80,
                                  productDetailModel.productReceiptUrl,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    // information PO
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
                            // avatarUrl, productOwnerName, button contact
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 25,
                                      backgroundImage: NetworkImage(
                                          productOwnerModel!.avatarUrl),
                                    ),
                                    SizedBox(width: 10),
                                    Text(
                                      productOwnerModel.fullName,
                                      style: TextStyles.h5.bold,
                                    ),
                                  ],
                                ),
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
                            // rate
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
                            // phone
                            Row(
                              children: [
                                Icon(FontAwesomeIcons.phone),
                                SizedBox(width: 10),
                                Text(productOwnerModel.phone)
                              ],
                            ),
                            SizedBox(height: 10),
                            // address
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
                        padding: EdgeInsets.all(10),
                        child: Column(
                          children: [
                            // Khách hàng đánh giá
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.circular(kDefaultCircle14),
                                border:
                                    Border.all(color: ColorPalette.textHide),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                                border:
                                    Border.all(color: ColorPalette.textHide),
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
                                        ColorPalette.textColor
                                            .withOpacity(0.6)),
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
                  if (checkType == "RENT" || checkType == "SALE_RENT")
                    Container(
                      decoration: BoxDecoration(
                        color: ColorPalette.hideColor,
                        borderRadius: BorderRadius.circular(kDefaultCircle14),
                        border: Border.all(color: ColorPalette.textHide),
                      ),
                      child: Column(
                        children: [
                          // Radio + Thuê + rentalPrice1
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Radio(
                                    // xác định kích thước của radio mà người dùng chạm vào để chọn
                                    materialTapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                    activeColor: ColorPalette.primaryColor,
                                    // nếu value == groupValue thì radio này sẽ được chọn
                                    value: true,
                                    // Những radio có cùng giá trị với groupValue thì là cùng nhóm
                                    groupValue: isRenting,
                                    // onChanged sẽ truyền value vào toggleRenting
                                    onChanged: toggleRenting,
                                  ),
                                  Text(
                                    'Thuê',
                                    style: TextStyles.defaultStyle.bold,
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.only(right: 12),
                                child: Text(
                                  '${NumberFormat.currency(locale: 'vi_VN', symbol: 'vnđ').format(rentalPrice1)}',
                                ),
                              ),
                            ],
                          ),
                          // Hiển thị thông tin thuê nếu đang ở trạng thái Thuê
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: Visibility(
                              // visible nếu giá trị của nó là true thì sẽ hiển thị
                              visible: isRenting == true,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // giai đoạn thuê
                                  Text('Giai đoạn thuê: '),
                                  Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            selectedRentalPeriod = 4;
                                            isRentalPeriodSelected = true;
                                          });
                                        },
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                Radio(
                                                  activeColor:
                                                      ColorPalette.primaryColor,
                                                  value: 4,
                                                  groupValue:
                                                      selectedRentalPeriod,
                                                  onChanged: (value) {
                                                    setState(() {
                                                      selectedRentalPeriod =
                                                          value as int;
                                                      isRentalPeriodSelected =
                                                          true;
                                                    });
                                                  },
                                                ),
                                                Text('4 ngày'),
                                              ],
                                            ),
                                            if (selectedRentalPeriod == 4)
                                              Text(
                                                'Thuê với giá: ${NumberFormat.currency(locale: 'vi_VN', symbol: 'vnđ').format(ProductDetailBloc.getRentalPrice(selectedRentalPeriod, productDetailModel))}',
                                                style: TextStyles
                                                    .defaultStyle.bold,
                                              ),
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
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                Radio(
                                                  activeColor:
                                                      ColorPalette.primaryColor,
                                                  value: 7,
                                                  groupValue:
                                                      selectedRentalPeriod,
                                                  onChanged: (value) {
                                                    setState(() {
                                                      selectedRentalPeriod =
                                                          value as int;
                                                      isRentalPeriodSelected =
                                                          true;
                                                    });
                                                  },
                                                ),
                                                Text('7 ngày'),
                                              ],
                                            ),
                                            if (selectedRentalPeriod == 7)
                                              Text(
                                                'Thuê với giá: ${NumberFormat.currency(locale: 'vi_VN', symbol: 'vnđ').format(ProductDetailBloc.getRentalPrice(selectedRentalPeriod, productDetailModel))}',
                                                style: TextStyles
                                                    .defaultStyle.bold,
                                              ),
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
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                Radio(
                                                  activeColor:
                                                      ColorPalette.primaryColor,
                                                  value: 10,
                                                  groupValue:
                                                      selectedRentalPeriod,
                                                  onChanged: (value) {
                                                    setState(() {
                                                      selectedRentalPeriod =
                                                          value as int;
                                                      isRentalPeriodSelected =
                                                          true;
                                                    });
                                                  },
                                                ),
                                                Text('10 ngày'),
                                              ],
                                            ),
                                            if (selectedRentalPeriod == 10)
                                              Text(
                                                'Thuê với giá: ${NumberFormat.currency(locale: 'vi_VN', symbol: 'vnđ').format(ProductDetailBloc.getRentalPrice(selectedRentalPeriod, productDetailModel))}',
                                                style: TextStyles
                                                    .defaultStyle.bold,
                                              ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),

                                  if (isRentalPeriodSelected)
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        // Chọn ngày thuê
                                        StatefulBuilder(
                                          builder: (context, setState) {
                                            return GestureDetector(
                                              onTap: () async {
                                                final selectDate =
                                                    await Navigator.of(context)
                                                        .push(
                                                  CupertinoPageRoute(
                                                    builder: (context) =>
                                                        SelectDateScreen(
                                                      selectedRentalPeriod:
                                                          selectedRentalPeriod,
                                                    ),
                                                  ),
                                                );
                                                if (selectDate != null &&
                                                    selectDate
                                                        is List<DateTime?> &&
                                                    !(selectDate
                                                            as List<DateTime?>)
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
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.all(10),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          kDefaultCircle14),
                                                  border: Border.all(
                                                      color: ColorPalette
                                                          .textHide),
                                                ),
                                                child: Row(
                                                  children: [
                                                    Icon(FontAwesomeIcons
                                                        .calendarDays),
                                                    SizedBox(
                                                        width: kItemPadding10),
                                                    Text(
                                                      'Chọn ngày:',
                                                    ),
                                                    SizedBox(
                                                        width: kItemPadding10),
                                                    Text(
                                                      dateSelected ??
                                                          'Chưa chọn ngày',
                                                      style: TextStyles
                                                          .defaultStyle.bold,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                  SizedBox(height: 10),

                                  // add to cart button
                                  ButtonWidget(
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
                                  SizedBox(height: 10),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  SizedBox(height: 10),

                  // Mua
                  if (checkType == "SALE" || checkType == "SALE_RENT")
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
                                  ' ${NumberFormat.currency(locale: 'vi_VN', symbol: 'vnđ').format(productDetailModel.price)}',
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
      ),
    );

    // return Scaffold(
    //   appBar: AppBar(
    //     title: Center(child: Text('Chi tiết sản phẩm')),
    //     leading: GestureDetector(
    //       onTap: () {
    //         Navigator.pop(context);
    //       },
    //       child: Icon(
    //         FontAwesomeIcons.angleLeft,
    //         size: kDefaultIconSize18,
    //       ),
    //     ),
    //   ),
    //   body: Column(
    //     crossAxisAlignment: CrossAxisAlignment.start,
    //     children: [
    //       Expanded(
    //         child: Padding(
    //           padding: const EdgeInsets.symmetric(horizontal: 20),
    //           child: ListView(
    //             children: [
    //               // load ảnh productDetail
    //               ImageSlider(
    //                 productImages: productImages,
    //                 currentImage: _currentImage,
    //                 onPageChanged: (int index) {
    //                   setState(() {
    //                     _currentImage = index;
    //                   });
    //                 },
    //                 carouselController: _controller,
    //               ),
    //               SizedBox(height: 10),
    //               // cục indicator
    //               Center(
    //                 child: Container(
    //                   height: 8,
    //                   child: ListView.builder(
    //                     // nằm giữa hay không là nó nằm ở shrinWrap này nè. Cho phép ListView co lại theo nội dung
    //                     shrinkWrap: true,
    //                     itemCount: productImages.length,
    //                     scrollDirection: Axis.horizontal,
    //                     itemBuilder: (context, index) {
    //                       return buildIndicator(index == _currentImage, size);
    //                     },
    //                   ),
    //                 ),
    //               ),
    //               SizedBox(height: 10),
    //               // information product
    //               Container(
    //                 decoration: BoxDecoration(
    //                     borderRadius: BorderRadius.circular(kDefaultCircle14),
    //                     color: ColorPalette.hideColor),
    //                 child: Padding(
    //                   padding: const EdgeInsets.all(10),
    //                   child: Column(
    //                     crossAxisAlignment: CrossAxisAlignment.start,
    //                     children: [
    //                       // name product
    //                       Text(
    //                         productDetailModel.productName,
    //                         style: TextStyles.h4.bold,
    //                       ),
    //                       SizedBox(height: 10),
    //                       // description
    //                       ExpandableText(
    //                         productDetailModel.description,
    //                         expandText: 'Xem thêm',
    //                         linkColor: Colors.blue,
    //                         collapseText: 'Thu gọn',
    //                         maxLines: 2,
    //                         style: TextStyles.defaultStyle.setColor(
    //                           // ColorPalette.textColor.withOpacity(0.6),
    //                           ColorPalette.grey3,
    //                         ),
    //                       ),
    //                       SizedBox(height: 10),
    //                       // brand, madeof
    //                       Row(
    //                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //                         children: [
    //                           Column(
    //                             crossAxisAlignment: CrossAxisAlignment.start,
    //                             children: [
    //                               Text(
    //                                 'Thương hiệu',
    //                                 style: TextStyles.h5.bold,
    //                               ),
    //                               SizedBox(height: 10),
    //                               Text(
    //                                 '${productDetailModel.productSpecificationData != null ? (productDetailModel.productSpecificationData?['brandName'] ?? "N/A") : "N/A"}',
    //                               )
    //                             ],
    //                           ),
    //                           Column(
    //                             crossAxisAlignment: CrossAxisAlignment.end,
    //                             children: [
    //                               Text(
    //                                 'Chất liệu',
    //                                 style: TextStyles.h5.bold,
    //                               ),
    //                               SizedBox(height: 10),
    //                               Text(
    //                                 '${productDetailModel.productSpecificationData != null ? (productDetailModel.productSpecificationData?['madeOf'] ?? "N/A") : "N/A"}',
    //                               )
    //                             ],
    //                           ),
    //                         ],
    //                       ),
    //                       SizedBox(height: 10),
    //                       // condition, rate
    //                       Row(
    //                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //                         children: [
    //                           Column(
    //                             crossAxisAlignment: CrossAxisAlignment.start,
    //                             children: [
    //                               Text(
    //                                 'Tình trạng',
    //                                 style: TextStyles.h5.bold,
    //                               ),
    //                               SizedBox(height: 10),
    //                               Text(productDetailModel.productCondition),
    //                             ],
    //                           ),
    //                           Column(
    //                             crossAxisAlignment: CrossAxisAlignment.end,
    //                             children: [
    //                               Text(
    //                                 'Đánh giá',
    //                                 style: TextStyles.h5.bold,
    //                               ),
    //                               SizedBox(height: 10),
    //                               Row(
    //                                 children: [
    //                                   Icon(
    //                                     FontAwesomeIcons.solidStar,
    //                                     color: Colors.amber,
    //                                     size: kDefaultPadding16,
    //                                   ),
    //                                   SizedBox(width: 10),
    //                                   Text('5.0'),
    //                                 ],
    //                               ),
    //                             ],
    //                           ),
    //                         ],
    //                       ),
    //                       SizedBox(height: 10),
    //                       //productReceiptUrl
    //                       Text(
    //                         'Hóa đơn',
    //                         style: TextStyles.h5.bold,
    //                       ),
    //                       SizedBox(height: 10),
    //                       GestureDetector(
    //                         onTap: () {
    //                           Navigator.of(context).push(
    //                             CupertinoPageRoute(
    //                               builder: (context) => FullScreenReceipt(
    //                                   productReceiptUrl:
    //                                       productDetailModel.productReceiptUrl),
    //                             ),
    //                           );
    //                         },
    //                         child: ClipRRect(
    //                           borderRadius:
    //                               BorderRadius.circular(kDefaultCircle14),
    //                           child: Image.network(
    //                             cacheHeight: 100,
    //                             cacheWidth: 80,
    //                             productDetailModel.productReceiptUrl,
    //                             fit: BoxFit.cover,
    //                           ),
    //                         ),
    //                       ),
    //                     ],
    //                   ),
    //                 ),
    //               ),
    //               SizedBox(height: 20),
    //               // information PO
    //               Container(
    //                 decoration: BoxDecoration(
    //                     borderRadius: BorderRadius.circular(kDefaultCircle14),
    //                     color: ColorPalette.hideColor),
    //                 child: Padding(
    //                   padding: const EdgeInsets.symmetric(
    //                       horizontal: 10, vertical: 10),
    //                   child: Column(
    //                     crossAxisAlignment: CrossAxisAlignment.start,
    //                     children: [
    //                       // avatarUrl, productOwnerName, button contact
    //                       Row(
    //                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //                         children: [
    //                           Row(
    //                             children: [
    //                               CircleAvatar(
    //                                 radius: 25,
    //                                 backgroundImage: NetworkImage(
    //                                     productOwnerModel!.avatarUrl),
    //                               ),
    //                               SizedBox(width: 10),
    //                               Text(
    //                                 productOwnerModel.fullName,
    //                                 style: TextStyles.h5.bold,
    //                               ),
    //                             ],
    //                           ),
    //                           GestureDetector(
    //                             onTap: () {},
    //                             child: Container(
    //                               padding: const EdgeInsets.all(12),
    //                               decoration: BoxDecoration(
    //                                   borderRadius: BorderRadius.circular(
    //                                       kDefaultCircle14),
    //                                   color: ColorPalette.primaryColor),
    //                               child: Row(
    //                                 children: [
    //                                   Icon(
    //                                     FontAwesomeIcons.solidMessage,
    //                                     color: Colors.white,
    //                                   ),
    //                                   SizedBox(width: 10),
    //                                   Text(
    //                                     'Liên hệ',
    //                                     style: TextStyles
    //                                         .defaultStyle.whiteTextColor,
    //                                   )
    //                                 ],
    //                               ),
    //                             ),
    //                           )
    //                         ],
    //                       ),
    //                       SizedBox(height: 10),
    //                       // rate
    //                       Row(
    //                         children: [
    //                           Icon(
    //                             FontAwesomeIcons.solidStar,
    //                             color: Colors.amber,
    //                             size: kDefaultPadding16,
    //                           ),
    //                           SizedBox(width: 10),
    //                           Text('5.0'),
    //                           Text(' | '),
    //                           Icon(
    //                             FontAwesomeIcons.solidMessage,
    //                             size: kDefaultPadding16,
    //                           ),
    //                           SizedBox(width: 10),
    //                           Text('99.0%'),
    //                         ],
    //                       ),
    //                       SizedBox(height: 10),
    //                       // phone
    //                       Row(
    //                         children: [
    //                           Icon(FontAwesomeIcons.phone),
    //                           SizedBox(width: 10),
    //                           Text(productOwnerModel.phone)
    //                         ],
    //                       ),
    //                       SizedBox(height: 10),
    //                       // address
    //                       Row(
    //                         children: [
    //                           Icon(FontAwesomeIcons.locationDot),
    //                           SizedBox(width: 10),
    //                           Text(productOwnerModel.address)
    //                         ],
    //                       ),
    //                     ],
    //                   ),
    //                 ),
    //               ),
    //               SizedBox(height: 20),

    //               // những bài đánh giá
    //               Container(
    //                 decoration: BoxDecoration(
    //                     borderRadius: BorderRadius.circular(kDefaultCircle14),
    //                     color: ColorPalette.hideColor),
    //                 child: Padding(
    //                   padding: EdgeInsets.all(10),
    //                   child: Column(
    //                     children: [
    //                       // Khách hàng đánh giá
    //                       Container(
    //                         padding: const EdgeInsets.all(12),
    //                         decoration: BoxDecoration(
    //                           borderRadius:
    //                               BorderRadius.circular(kDefaultCircle14),
    //                           border: Border.all(color: ColorPalette.textHide),
    //                         ),
    //                         child: Row(
    //                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //                           children: [
    //                             Row(
    //                               children: [
    //                                 Icon(
    //                                   FontAwesomeIcons.solidStar,
    //                                   color: Colors.amber,
    //                                 ),
    //                                 SizedBox(width: 10),
    //                                 Text(
    //                                   'Khách hàng đánh giá',
    //                                   style: TextStyles.h5.bold,
    //                                 ),
    //                               ],
    //                             ),
    //                             Text(
    //                               '3 đánh giá',
    //                               style: TextStyles.defaultStyle
    //                                   .setColor(Colors.blue),
    //                             )
    //                           ],
    //                         ),
    //                       ),
    //                       SizedBox(height: 10),

    //                       // List đánh giá
    //                       Container(
    //                         padding: const EdgeInsets.all(12),
    //                         decoration: BoxDecoration(
    //                           borderRadius:
    //                               BorderRadius.circular(kDefaultCircle14),
    //                           border: Border.all(color: ColorPalette.textHide),
    //                         ),
    //                         child: Column(
    //                           crossAxisAlignment: CrossAxisAlignment.start,
    //                           children: [
    //                             Row(
    //                               children: [
    //                                 Text(
    //                                   'Tên khách hàng',
    //                                   style: TextStyles.defaultStyle.bold,
    //                                 ),
    //                                 SizedBox(height: 10),
    //                               ],
    //                             ),
    //                             SizedBox(height: 10),
    //                             Row(
    //                               children: [
    //                                 Text('03:18'),
    //                                 Text(' | '),
    //                                 Text('05/06/2023'),
    //                               ],
    //                             ),
    //                             SizedBox(height: 10),
    //                             Text('Tên sản phẩm'),
    //                             SizedBox(height: 10),
    //                             Text(
    //                               'Description của đánh giá',
    //                               style: TextStyles.defaultStyle.setColor(
    //                                   ColorPalette.textColor.withOpacity(0.6)),
    //                             ),
    //                           ],
    //                         ),
    //                       ),
    //                     ],
    //                   ),
    //                 ),
    //               ),
    //             ],
    //           ),
    //         ),
    //       ),
    //       SizedBox(height: 10),
    //       // cục ở dưới màn hình gồm Thuê và Mua
    //       Container(
    //         decoration: BoxDecoration(
    //           color: ColorPalette.backgroundScaffoldColor,
    //           borderRadius: BorderRadius.only(
    //             topLeft: Radius.circular(kDefaultCircle14),
    //             topRight: Radius.circular(kDefaultCircle14),
    //           ),
    //         ),
    //         padding: EdgeInsets.all(20),
    //         child: Column(
    //           children: [
    //             // Thuê
    //             if (checkType == "RENT" || checkType == "SALE_RENT")
    //               Container(
    //                 decoration: BoxDecoration(
    //                   color: ColorPalette.hideColor,
    //                   borderRadius: BorderRadius.circular(kDefaultCircle14),
    //                   border: Border.all(color: ColorPalette.textHide),
    //                 ),
    //                 child: Column(
    //                   children: [
    //                     // Radio + Thuê + rentalPrice1
    //                     Row(
    //                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //                       children: [
    //                         Row(
    //                           children: [
    //                             Radio(
    //                               // xác định kích thước của radio mà người dùng chạm vào để chọn
    //                               materialTapTargetSize:
    //                                   MaterialTapTargetSize.shrinkWrap,
    //                               activeColor: ColorPalette.primaryColor,
    //                               // nếu value == groupValue thì radio này sẽ được chọn
    //                               value: true,
    //                               // Những radio có cùng giá trị với groupValue thì là cùng nhóm
    //                               groupValue: isRenting,
    //                               // onChanged sẽ truyền value vào toggleRenting
    //                               onChanged: toggleRenting,
    //                             ),
    //                             Text(
    //                               'Thuê',
    //                               style: TextStyles.defaultStyle.bold,
    //                             ),
    //                           ],
    //                         ),
    //                         Padding(
    //                           padding: const EdgeInsets.only(right: 12),
    //                           child: Text(
    //                             '${NumberFormat.currency(locale: 'vi_VN', symbol: 'vnđ').format(rentalPrice1)}',
    //                           ),
    //                         ),
    //                       ],
    //                     ),
    //                     // Hiển thị thông tin thuê nếu đang ở trạng thái Thuê
    //                     Padding(
    //                       padding: const EdgeInsets.symmetric(horizontal: 12),
    //                       child: Visibility(
    //                         // visible nếu giá trị của nó là true thì sẽ hiển thị
    //                         visible: isRenting == true,
    //                         child: Column(
    //                           crossAxisAlignment: CrossAxisAlignment.start,
    //                           children: [
    //                             // giai đoạn thuê
    //                             Text('Giai đoạn thuê: '),
    //                             Column(
    //                               mainAxisAlignment:
    //                                   MainAxisAlignment.spaceBetween,
    //                               children: [
    //                                 GestureDetector(
    //                                   onTap: () {
    //                                     setState(() {
    //                                       selectedRentalPeriod = 4;
    //                                       isRentalPeriodSelected = true;
    //                                     });
    //                                   },
    //                                   child: Row(
    //                                     mainAxisAlignment:
    //                                         MainAxisAlignment.spaceBetween,
    //                                     children: [
    //                                       Row(
    //                                         children: [
    //                                           Radio(
    //                                             activeColor:
    //                                                 ColorPalette.primaryColor,
    //                                             value: 4,
    //                                             groupValue:
    //                                                 selectedRentalPeriod,
    //                                             onChanged: (value) {
    //                                               setState(() {
    //                                                 selectedRentalPeriod =
    //                                                     value as int;
    //                                                 isRentalPeriodSelected =
    //                                                     true;
    //                                               });
    //                                             },
    //                                           ),
    //                                           Text('4 ngày'),
    //                                         ],
    //                                       ),
    //                                       if (selectedRentalPeriod == 4)
    //                                         Text(
    //                                           'Thuê với giá: ${NumberFormat.currency(locale: 'vi_VN', symbol: 'vnđ').format(ProductDetailBloc.getRentalPrice(selectedRentalPeriod, productDetailModel))}',
    //                                           style:
    //                                               TextStyles.defaultStyle.bold,
    //                                         ),
    //                                     ],
    //                                   ),
    //                                 ),
    //                                 GestureDetector(
    //                                   onTap: () {
    //                                     setState(() {
    //                                       selectedRentalPeriod = 7;
    //                                       isRentalPeriodSelected = true;
    //                                     });
    //                                   },
    //                                   child: Row(
    //                                     mainAxisAlignment:
    //                                         MainAxisAlignment.spaceBetween,
    //                                     children: [
    //                                       Row(
    //                                         children: [
    //                                           Radio(
    //                                             activeColor:
    //                                                 ColorPalette.primaryColor,
    //                                             value: 7,
    //                                             groupValue:
    //                                                 selectedRentalPeriod,
    //                                             onChanged: (value) {
    //                                               setState(() {
    //                                                 selectedRentalPeriod =
    //                                                     value as int;
    //                                                 isRentalPeriodSelected =
    //                                                     true;
    //                                               });
    //                                             },
    //                                           ),
    //                                           Text('7 ngày'),
    //                                         ],
    //                                       ),
    //                                       if (selectedRentalPeriod == 7)
    //                                         Text(
    //                                           'Thuê với giá: ${NumberFormat.currency(locale: 'vi_VN', symbol: 'vnđ').format(ProductDetailBloc.getRentalPrice(selectedRentalPeriod, productDetailModel))}',
    //                                           style:
    //                                               TextStyles.defaultStyle.bold,
    //                                         ),
    //                                     ],
    //                                   ),
    //                                 ),
    //                                 GestureDetector(
    //                                   onTap: () {
    //                                     setState(() {
    //                                       selectedRentalPeriod = 10;
    //                                       isRentalPeriodSelected = true;
    //                                     });
    //                                   },
    //                                   child: Row(
    //                                     mainAxisAlignment:
    //                                         MainAxisAlignment.spaceBetween,
    //                                     children: [
    //                                       Row(
    //                                         children: [
    //                                           Radio(
    //                                             activeColor:
    //                                                 ColorPalette.primaryColor,
    //                                             value: 10,
    //                                             groupValue:
    //                                                 selectedRentalPeriod,
    //                                             onChanged: (value) {
    //                                               setState(() {
    //                                                 selectedRentalPeriod =
    //                                                     value as int;
    //                                                 isRentalPeriodSelected =
    //                                                     true;
    //                                               });
    //                                             },
    //                                           ),
    //                                           Text('10 ngày'),
    //                                         ],
    //                                       ),
    //                                       if (selectedRentalPeriod == 10)
    //                                         Text(
    //                                           'Thuê với giá: ${NumberFormat.currency(locale: 'vi_VN', symbol: 'vnđ').format(ProductDetailBloc.getRentalPrice(selectedRentalPeriod, productDetailModel))}',
    //                                           style:
    //                                               TextStyles.defaultStyle.bold,
    //                                         ),
    //                                     ],
    //                                   ),
    //                                 ),
    //                               ],
    //                             ),

    //                             if (isRentalPeriodSelected)
    //                               Column(
    //                                 crossAxisAlignment:
    //                                     CrossAxisAlignment.start,
    //                                 children: [
    //                                   // Chọn ngày thuê
    //                                   StatefulBuilder(
    //                                     builder: (context, setState) {
    //                                       return GestureDetector(
    //                                         onTap: () async {
    //                                           final selectDate =
    //                                               await Navigator.of(context)
    //                                                   .push(
    //                                             CupertinoPageRoute(
    //                                               builder: (context) =>
    //                                                   SelectDateScreen(
    //                                                 selectedRentalPeriod:
    //                                                     selectedRentalPeriod,
    //                                               ),
    //                                             ),
    //                                           );
    //                                           if (selectDate != null &&
    //                                               selectDate
    //                                                   is List<DateTime?> &&
    //                                               !(selectDate
    //                                                       as List<DateTime?>)
    //                                                   .any((element) =>
    //                                                       element == null)) {
    //                                             dateSelected =
    //                                                 '${selectDate[0]?.getStartDate} - ${selectDate[1]?.getEndDate}';
    //                                             setState(() {});
    //                                           } else {
    //                                             dateSelected = null;
    //                                             setState(() {});
    //                                           }
    //                                         },
    //                                         child: Container(
    //                                           padding: const EdgeInsets.all(10),
    //                                           decoration: BoxDecoration(
    //                                             borderRadius:
    //                                                 BorderRadius.circular(
    //                                                     kDefaultCircle14),
    //                                             border: Border.all(
    //                                                 color:
    //                                                     ColorPalette.textHide),
    //                                           ),
    //                                           child: Row(
    //                                             children: [
    //                                               Icon(FontAwesomeIcons
    //                                                   .calendarDays),
    //                                               SizedBox(
    //                                                   width: kItemPadding10),
    //                                               Text(
    //                                                 'Chọn ngày:',
    //                                               ),
    //                                               SizedBox(
    //                                                   width: kItemPadding10),
    //                                               Text(
    //                                                 dateSelected ??
    //                                                     'Chưa chọn ngày',
    //                                                 style: TextStyles
    //                                                     .defaultStyle.bold,
    //                                               ),
    //                                             ],
    //                                           ),
    //                                         ),
    //                                       );
    //                                     },
    //                                   ),
    //                                 ],
    //                               ),
    //                             SizedBox(height: 10),

    //                             // add to cart button
    //                             ButtonWidget(
    //                               title: 'Thêm vào giỏ hàng Thuê',
    //                               onTap: () {
    //                                 if (dateSelected != null) {
    //                                 } else {
    //                                   showCustomDialog(context, 'Error',
    //                                       'Làm ơn chọn ngày thuê!');
    //                                 }
    //                               },
    //                               height: 70,
    //                               size: 18,
    //                             ),
    //                             SizedBox(height: 10),
    //                           ],
    //                         ),
    //                       ),
    //                     ),
    //                   ],
    //                 ),
    //               ),
    //             SizedBox(height: 10),

    //             // Mua
    //             if (checkType == "SALE" || checkType == "SALE_RENT")
    //               Container(
    //                 decoration: BoxDecoration(
    //                   color: ColorPalette.hideColor,
    //                   borderRadius: BorderRadius.circular(kDefaultCircle14),
    //                   border: Border.all(color: ColorPalette.textHide),
    //                 ),
    //                 child: Column(
    //                   children: [
    //                     Row(
    //                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //                       children: [
    //                         Row(
    //                           children: [
    //                             Radio(
    //                                 materialTapTargetSize:
    //                                     MaterialTapTargetSize.shrinkWrap,
    //                                 activeColor: ColorPalette.primaryColor,
    //                                 value: false,
    //                                 groupValue: isRenting,
    //                                 onChanged: toggleRenting),
    //                             Text(
    //                               'Mua',
    //                               style: TextStyles.defaultStyle.bold,
    //                             ),
    //                           ],
    //                         ),
    //                         Padding(
    //                           padding: const EdgeInsets.only(right: 12),
    //                           child: Text(
    //                             ' ${NumberFormat.currency(locale: 'vi_VN', symbol: 'vnđ').format(productDetailModel.price)}',
    //                           ),
    //                         ),
    //                       ],
    //                     ),
    //                     Padding(
    //                       padding: const EdgeInsets.symmetric(horizontal: 12),
    //                       child: Visibility(
    //                         visible: isRenting == false,
    //                         child: Column(
    //                           crossAxisAlignment: CrossAxisAlignment.start,
    //                           children: [
    //                             SizedBox(height: 20),
    //                             // add to cart button
    //                             ButtonWidget(
    //                               title: 'Thêm vào giỏ hàng Mua',
    //                               onTap: () {},
    //                               height: 70,
    //                               size: 18,
    //                             ),
    //                             SizedBox(height: 10),
    //                           ],
    //                         ),
    //                       ),
    //                     ),
    //                   ],
    //                 ),
    //               ),
    //           ],
    //         ),
    //       ),
    //     ],
    //   ),
    // );
  }
}
