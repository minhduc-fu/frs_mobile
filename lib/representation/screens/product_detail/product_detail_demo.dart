import 'package:auto_size_text/auto_size_text.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:frs_mobile/models/cart_item_model.dart';
import 'package:frs_mobile/models/feedback_model.dart';
import 'package:frs_mobile/models/product_detail_model.dart';
import 'package:frs_mobile/models/product_image_model.dart';
import 'package:frs_mobile/models/rental_cart_item_model.dart';
import 'package:frs_mobile/representation/screens/favorite/services/api_favorite.dart';
import 'package:frs_mobile/representation/screens/product_detail/full_screen_receipt.dart';
import 'package:frs_mobile/representation/screens/product_detail/services/api_product_detail.dart';
import 'package:frs_mobile/representation/screens/product_detail/widgets/image_slider.dart';
import 'package:frs_mobile/representation/screens/productowner_screen/productOwner_shop_screen.dart';
import 'package:frs_mobile/representation/widgets/app_bar_main.dart';
import 'package:frs_mobile/services/authprovider.dart';
import 'package:frs_mobile/services/cart_provider.dart';
import 'package:frs_mobile/services/rental_cart_provider.dart';
import 'package:intl/intl.dart';
import 'package:frs_mobile/core/extensions/date_ext.dart';
import 'package:like_button/like_button.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/color_constants.dart';
import '../../../core/constants/dismension_constants.dart';
import '../../../core/constants/textstyle_constants.dart';
import '../../../models/productOwner_model.dart';
import '../../../utils/dialog_helper.dart';
import '../../widgets/button_widget.dart';
import '../../widgets/indicator_widget.dart';
import 'select_date_screen.dart';

class ProductDetailDemo extends StatefulWidget {
  final ProductDetailModel? productDetailModel;
  final ProductOwnerModel? productOwnerModel;
  final List<ProductImageModel> productImageModel;
  final List<FeedbackModel> feedbackList;
  const ProductDetailDemo({
    super.key,
    required this.productDetailModel,
    required this.productOwnerModel,
    required this.productImageModel,
    required this.feedbackList,
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
  int selectedMockday = 0;
  String? dateSelected;
  DateTime? startDate;
  DateTime? endDate;
  double selectedRenPrice = 0;

  bool isAccept = false;

  bool? isRenting = null;
  void toggleRenting(bool? value) {
    setState(() {
      isRenting = value ?? false;
    });
  }

  int _currentImage = 0;

  bool isFavorite = false;
  @override
  void initState() {
    super.initState();
    final userModel = AuthProvider.userModel;
    if (userModel != null) {
      checkFavoriteStatus();
    }
  }

  void checkFavoriteStatus() async {
    try {
      List<Map<String, dynamic>>? favoriteProducts =
          await ApiFavorite.getFavoriteByCusID(
              AuthProvider.userModel!.customer!.customerID);

      if (favoriteProducts != null && favoriteProducts.isNotEmpty) {
        for (var favoriteProduct in favoriteProducts) {
          var productDTO = favoriteProduct['productDTO'];

          if (productDTO['productID'] == widget.productDetailModel!.productID) {
            setState(() {
              isFavorite = true;
            });
            break;
          }
        }
      }
    } catch (e) {
      print('Error checking favorite status: $e');
    }
  }

  void addToFavorites() async {
    try {
      await ApiFavorite.createFavoriteProduct(
        AuthProvider.userModel!.customer!.customerID,
        widget.productDetailModel!.productID,
      );
      print('Added to favorites successfully');
    } catch (e) {
      print('Error adding to favorites: $e');
    }
  }

  void removeFromFavorites() async {
    try {
      List<Map<String, dynamic>>? favoriteProducts =
          await ApiFavorite.getFavoriteByCusID(
              AuthProvider.userModel!.customer!.customerID);

      if (favoriteProducts != null && favoriteProducts.isNotEmpty) {
        for (var favoriteProduct in favoriteProducts) {
          var productDTO = favoriteProduct['productDTO'];

          if (productDTO['productID'] == widget.productDetailModel!.productID) {
            var favoriteProductID = favoriteProduct['favoriteProductID'];
            await ApiFavorite.unmarkFavoriteStatus(favoriteProductID);
            print('Removed from favorites successfully');
            break;
          }
        }
      }
    } catch (e) {
      print('Error removing from favorites: $e');
    }
  }

  void _toggleFavoriteStatus() {
    setState(() {
      isFavorite = !isFavorite;
    });

    if (isFavorite) {
      addToFavorites();
    } else {
      removeFromFavorites();
    }
  }

  Widget buildRatingHeader() {
    return Padding(
      padding: const EdgeInsets.all(10),
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
            '${widget.feedbackList.length} đánh giá',
            style: TextStyles.defaultStyle.setColor(Colors.blue),
          ),
        ],
      ),
    );
  }

  Widget buildFeedbackList() {
    if (widget.feedbackList.isEmpty) {
      return Column(
        children: [
          Row(
            children: [
              SizedBox(width: 10),
              Text('Chưa có đánh giá nào'),
            ],
          ),
          SizedBox(height: 10),
        ],
      );
    } else {
      return ListView.builder(
        shrinkWrap: true,
        itemCount: widget.feedbackList.length,
        itemBuilder: (context, index) {
          return buildFeedbackItem(widget.feedbackList[index]);
        },
      );
    }
  }

  Widget buildFeedbackItem(FeedbackModel feedback) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(kDefaultCircle14),
          border: Border.all(color: ColorPalette.textHide),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 10,
                      backgroundImage:
                          NetworkImage(feedback.customerDTO.avatarUrl),
                    ),
                    SizedBox(width: 10),
                    Text(
                      '${feedback.customerDTO.fullName}',
                      style: TextStyles.defaultStyle.bold,
                    ),
                  ],
                ),
                Text(
                  '${DateFormat.yMd().format(feedback.createdDate)}',
                ),
              ],
            ),
            SizedBox(height: 10),
            Row(
              children: [
                RatingBar(
                  itemSize: 18,
                  initialRating: feedback.ratingPoint.toDouble(),
                  minRating: 1,
                  direction: Axis.horizontal,
                  allowHalfRating: false,
                  itemCount: 5,
                  itemPadding: EdgeInsets.symmetric(horizontal: 2.0),
                  ratingWidget: RatingWidget(
                    full: Icon(
                      FontAwesomeIcons.solidStar,
                      color: Colors.amber,
                    ),
                    half: Icon(FontAwesomeIcons.solidStar),
                    empty: Icon(
                      FontAwesomeIcons.star,
                      color: Colors.amber,
                    ),
                  ),
                  onRatingUpdate: (value) {},
                  ignoreGestures: true,
                ),
              ],
            ),
            SizedBox(height: 10),
            AutoSizeText(
              '${feedback.description}',
              minFontSize: 14,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyles.defaultStyle
                  .setColor(ColorPalette.textColor.withOpacity(0.6)),
            ),
            SizedBox(height: 10),
            feedback.imgDTOs.isNotEmpty
                ? SizedBox(
                    height: 80,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: feedback.imgDTOs.length,
                      itemBuilder: (context, index) {
                        return Container(
                          margin: EdgeInsets.symmetric(horizontal: 18),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(14),
                            child: Image.network(
                              feedback.imgDTOs[index].imgUrl,
                              cacheHeight: 80,
                              cacheWidth: 80,
                              fit: BoxFit.cover,
                            ),
                          ),
                        );
                      },
                    ),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }

  double calculateAverageRating(List<FeedbackModel> feedbacks) {
    if (feedbacks.isEmpty) {
      return 0.0;
    }

    double totalRating = 0.0;
    for (var feedback in feedbacks) {
      totalRating += feedback.ratingPoint;
    }

    return totalRating / feedbacks.length;
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    final rentalCartProvider =
        Provider.of<RentalCartProvider>(context, listen: false);
    final productDetailModel = widget.productDetailModel;
    final productOwnerModel = widget.productOwnerModel;
    final List<ProductImageModel> productImages = widget.productImageModel;
    final String checkType = productDetailModel!.checkType;
    Size size = MediaQuery.of(context).size; // get screen size
    return AppBarMain(
      titleAppbar: 'Chi tiết sản phẩm',
      leading: GestureDetector(
        onTap: () {
          Navigator.pop(context);
        },
        child: Container(
          color: ColorPalette.backgroundScaffoldColor,
          child: Icon(
            FontAwesomeIcons.angleLeft,
            // size: kDefaultIconSize18,
          ),
        ),
      ),
      child: Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: ListView(
                  children: [
                    // load ảnh productDetail
                    Stack(
                      children: [
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
                        Positioned(
                          right: 40,
                          top: 10,
                          child: LikeButton(
                            bubblesSize: 100,
                            bubblesColor: BubblesColor(
                                dotPrimaryColor: Colors.red,
                                dotSecondaryColor: Colors.black),
                            isLiked: isFavorite,
                            onTap: (bool isLiked) {
                              final userModel = AuthProvider.userModel;
                              if (userModel != null) {
                                if (AuthProvider.userModel?.status ==
                                    "NOT_VERIFIED") {
                                  showCustomDialog(context, "Lỗi",
                                      "Hãy cập nhật thông tin cá nhân", true);
                                  return Future.value(false);
                                } else {
                                  _toggleFavoriteStatus();
                                  return Future.value(!isLiked);
                                }
                              } else {
                                showCustomDialog(
                                    context,
                                    "Lỗi",
                                    "Hãy 'Đăng nhập' vào hệ thống để 'Đặt hàng'",
                                    true);
                                return Future.value(false);
                              }
                            },
                            size: 38,
                            likeBuilder: (isLiked) {
                              return isLiked
                                  ? Icon(
                                      FontAwesomeIcons.solidHeart,
                                      color: Colors.redAccent,
                                    )
                                  : Icon(
                                      FontAwesomeIcons.heart,
                                      color: Colors.redAccent,
                                    );
                            },
                          ),
                        ),
                      ],
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
                            AutoSizeText(
                              maxLines: 1,
                              '${productDetailModel.productName}',
                              style: TextStyles.h4.bold,
                              minFontSize: 25,
                              overflow: TextOverflow.ellipsis,
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
                                    SizedBox(height: 5),
                                    Text(
                                      '${productDetailModel.getBrandName()}',
                                    )
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    if (productDetailModel
                                            .category!.categoryName ==
                                        'Jewelry')
                                      Text(
                                        'Dịp',
                                        style: TextStyles.h5.bold,
                                      ),
                                    if (productDetailModel
                                            .category!.categoryName ==
                                        'Bag')
                                      Text(
                                        'Loại da',
                                        style: TextStyles.h5.bold,
                                      ),
                                    if (productDetailModel
                                            .category!.categoryName ==
                                        'Sunglasses')
                                      Text(
                                        'Chất liệu khung kính',
                                        style: TextStyles.h5.bold,
                                      ),
                                    if (productDetailModel
                                            .category!.categoryName ==
                                        'Hat')
                                      Text(
                                        'Chất liệu mũ',
                                        style: TextStyles.h5.bold,
                                      ),
                                    if (productDetailModel
                                            .category!.categoryName ==
                                        'Shoe')
                                      Text(
                                        'Loại da ',
                                        style: TextStyles.h5.bold,
                                      ),
                                    SizedBox(height: 5),
                                    Text(
                                      '${productDetailModel.getMadeOf()}',
                                    )
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      productDetailModel
                                                  .category!.categoryName ==
                                              'Sunglasses'
                                          ? 'Hình dạng khung kính'
                                          : 'Xuất xứ',
                                      style: TextStyles.h5.bold,
                                    ),
                                    SizedBox(height: 5),
                                    Text(
                                      '${productDetailModel.getOrigin()}',
                                    )
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    if (productDetailModel
                                            .category!.categoryName ==
                                        'Sunglasses')
                                      Text(
                                        'Loại Lens',
                                        style: TextStyles.h5.bold,
                                      ),
                                    if (productDetailModel
                                            .category!.categoryName ==
                                        'Shoe')
                                      Text(
                                        'Da ngoài',
                                        style: TextStyles.h5.bold,
                                      ),
                                    if (productDetailModel
                                            .category!.categoryName ==
                                        'Jewelry')
                                      Text(
                                        'Kiểu trang sức',
                                        style: TextStyles.h5.bold,
                                      ),
                                    if (productDetailModel
                                            .category!.categoryName ==
                                        'Bag')
                                      Text(
                                        'Kết cấu da',
                                        style: TextStyles.h5.bold,
                                      ),
                                    if (productDetailModel
                                            .category!.categoryName ==
                                        'Hat')
                                      Text(
                                        'Loại mũ',
                                        style: TextStyles.h5.bold,
                                      ),
                                    SizedBox(height: 5),
                                    Text(
                                      '${productDetailModel.getType()}',
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
                                    SizedBox(height: 5),
                                    Text(
                                        '${productDetailModel.productCondition}%'),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      'Đánh giá',
                                      style: TextStyles.h5.bold,
                                    ),
                                    SizedBox(height: 5),
                                    Row(
                                      children: [
                                        calculateAverageRating(
                                                    widget.feedbackList) ==
                                                0.0
                                            ? Container()
                                            : Icon(
                                                FontAwesomeIcons.solidStar,
                                                color: Colors.amber,
                                                size: kDefaultPadding16,
                                              ),
                                        SizedBox(width: 10),
                                        Text(calculateAverageRating(
                                                    widget.feedbackList) ==
                                                0.0
                                            ? 'Chưa có'
                                            : calculateAverageRating(
                                                    widget.feedbackList)
                                                .toString())
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(height: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Số serial',
                                  style: TextStyles.h5.bold,
                                ),
                                SizedBox(height: 5),
                                Row(
                                  children: [
                                    Text(
                                      '${productDetailModel.serialNumber}',
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(height: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                for (var detailItem
                                    in productDetailModel.details!)
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '${detailItem.detailName}',
                                        style: TextStyles.h5.bold,
                                      ),
                                      SizedBox(height: 5),
                                      Text('${detailItem.value}',
                                          style: TextStyles.defaultStyle),
                                      SizedBox(height: 10),
                                    ],
                                  ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Hóa đơn',
                                  style: TextStyles.h5.bold,
                                ),
                                SizedBox(height: 5),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).push(
                                      CupertinoPageRoute(
                                        builder: (context) => FullScreenReceipt(
                                            productReceiptUrl:
                                                productDetailModel
                                                    .productReceiptUrl),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color: ColorPalette.textHide),
                                        borderRadius: BorderRadius.circular(
                                            kDefaultCircle14)),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(
                                          kDefaultCircle14),
                                      child: Image.network(
                                        cacheHeight: 80,
                                        cacheWidth: 80,
                                        productDetailModel.productReceiptUrl,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            SizedBox(height: 10),
                            if (checkType == "RENT")
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Tiền cọc',
                                    style: TextStyles.h5.bold,
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                    '${NumberFormat.currency(locale: 'vi_VN', symbol: 'vnđ').format(productDetailModel.price)}',
                                  ),
                                ],
                              ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
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
                            Row(
                              children: [
                                Icon(
                                  FontAwesomeIcons.rectangleList,
                                  size: 20,
                                ),
                                SizedBox(width: 10),
                                Text(
                                  checkType == "RENT"
                                      ? "Điều khoản thuê"
                                      : 'Điều khoản mua',
                                  style: TextStyles.h5.bold.setTextSize(15),
                                ),
                              ],
                            ),
                            SizedBox(height: 20),
                            productDetailModel.term == ''
                                ? Text('Chưa có quy định thuê')
                                : ExpandableText(
                                    '${productDetailModel.term.replaceAll('@', '\n')}',
                                    expandText: 'Xem thêm',
                                    linkColor: Colors.blue,
                                    collapseText: 'Thu gọn',
                                    maxLines: 5,
                                  ),
                            Row(
                              children: [
                                SizedBox(
                                  width: 20,
                                  child: Checkbox(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(14)),
                                    value: isAccept,
                                    onChanged: (value) {
                                      setState(() {
                                        isAccept = value ?? false;
                                      });
                                      print('${isAccept}');
                                    },
                                  ),
                                ),
                                SizedBox(width: 10),
                                Text('Tôi đã đọc và đồng ý với các quy định',
                                    style: TextStyles.defaultStyle.bold),
                              ],
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
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      CupertinoPageRoute(
                                        builder: (context) =>
                                            ProductOwnerShopScreen(
                                          productOwnerModel: productOwnerModel,
                                        ),
                                      ),
                                    );
                                  },
                                  child: Row(
                                    children: [
                                      Stack(
                                        children: [
                                          CircleAvatar(
                                            radius: 30,
                                            backgroundColor:
                                                ColorPalette.primaryColor,
                                          ),
                                          Positioned(
                                            top: 5,
                                            left: 5,
                                            bottom: 5,
                                            right: 5,
                                            child: CircleAvatar(
                                              radius: 30,
                                              backgroundImage: NetworkImage(
                                                  productOwnerModel!.avatarUrl),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(width: 10),
                                      Text(
                                        productOwnerModel.fullName,
                                        style:
                                            TextStyles.h5.bold.setTextSize(15),
                                      ),
                                    ],
                                  ),
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
                                Icon(FontAwesomeIcons.solidThumbsUp),
                                SizedBox(width: 10),
                                Text(
                                    '${widget.productOwnerModel!.reputationPoint}'),
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
                                Flexible(
                                  child: Text(
                                    productOwnerModel.address,
                                  ),
                                )
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
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          buildRatingHeader(),
                          Divider(
                            thickness: 0.5,
                            color: ColorPalette.primaryColor,
                          ),
                          // List đánh giá
                          buildFeedbackList(),
                        ],
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
                  if (checkType == "RENT")
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
                                    onChanged: (value) {
                                      if (widget.productDetailModel!.term !=
                                          '') {
                                        if (isAccept) {
                                          toggleRenting(value);
                                        } else {
                                          showCustomDialog(
                                              context,
                                              'Lỗi',
                                              "Vui lòng đọc và đồng ý quy định thuê",
                                              true);
                                        }
                                      } else {
                                        toggleRenting(value);
                                      }
                                    },
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
                                  '${NumberFormat.currency(locale: 'vi_VN', symbol: 'vnđ').format(productDetailModel.rentalPrices![0]!.rentPrice)}/${productDetailModel.rentalPrices![0]!.mockDay} ngày',
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
                                    children: productDetailModel.rentalPrices!
                                        .where((rentalPrice) =>
                                            rentalPrice!.mockDay != 1)
                                        .map((rentalPrice) {
                                      final index = productDetailModel
                                              .rentalPrices!
                                              .indexOf(rentalPrice) +
                                          1;
                                      return GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            selectedRentalPeriod = index;
                                            isRentalPeriodSelected = true;
                                            selectedMockday =
                                                rentalPrice.mockDay;
                                            selectedRenPrice =
                                                rentalPrice.rentPrice;
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
                                                  value: index,
                                                  groupValue:
                                                      selectedRentalPeriod,
                                                  onChanged: (value) {
                                                    setState(() {
                                                      selectedRentalPeriod =
                                                          value as int;
                                                      isRentalPeriodSelected =
                                                          true;
                                                      selectedMockday =
                                                          rentalPrice!.mockDay;
                                                      selectedRenPrice =
                                                          rentalPrice.rentPrice;
                                                    });
                                                  },
                                                ),
                                                Text(
                                                    '${rentalPrice!.mockDay} ngày'),
                                              ],
                                            ),
                                            if (selectedRentalPeriod == index)
                                              Text(
                                                'Thuê với giá: ${NumberFormat.currency(locale: 'vi_VN', symbol: 'vnđ').format(rentalPrice.rentPrice)}',
                                                style: TextStyles
                                                    .defaultStyle.bold,
                                              ),
                                          ],
                                        ),
                                      );
                                    }).toList(),
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
                                                Map<String, List<int>>
                                                    rentDetail =
                                                    await ApiProductDetail
                                                        .getOrderRentDetailByProductIDAndOrderRentStatusRenting(
                                                            widget
                                                                .productDetailModel!
                                                                .productID);
                                                final selectDate =
                                                    await Navigator.of(context)
                                                        .push(
                                                  CupertinoPageRoute(
                                                    builder: (context) =>
                                                        SelectDateScreen(
                                                      selectedRentalPeriod:
                                                          selectedMockday,
                                                      rentingDate: rentDetail,
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
                                                  startDate = selectDate[0];
                                                  endDate = selectDate[1];
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
                                        final productAlreadyInRentalCart =
                                            rentalCartProvider
                                                .isProductInRentalCart(
                                                    productDetailModel
                                                        .productID);
                                        if (productDetailModel.status ==
                                            "AVAILABLE") {
                                          if (productAlreadyInRentalCart) {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                backgroundColor: Colors.red,
                                                content: Text(
                                                    'Sản phẩm đã có trong giỏ hàng Thuê'),
                                              ),
                                            );
                                          } else {
                                            final selectedProduct = ProductDetailModel(
                                                productID: widget
                                                    .productDetailModel!
                                                    .productID,
                                                productName: widget
                                                    .productDetailModel!
                                                    .productName,
                                                productReceiptUrl: widget
                                                    .productDetailModel!
                                                    .productReceiptUrl,
                                                productCondition: widget
                                                    .productDetailModel!
                                                    .productCondition,
                                                description: widget
                                                    .productDetailModel!
                                                    .description,
                                                term: widget
                                                    .productDetailModel!.term,
                                                price: widget
                                                    .productDetailModel!.price,
                                                status: widget
                                                    .productDetailModel!.status,
                                                checkType: widget
                                                    .productDetailModel!
                                                    .checkType,
                                                productOwnerID: widget
                                                    .productDetailModel!
                                                    .productOwnerID,
                                                rentalPrices: widget
                                                    .productDetailModel!
                                                    .rentalPrices,
                                                productAvt:
                                                    widget.productDetailModel!.productAvt,
                                                startDate: startDate,
                                                endDate: endDate,
                                                selectedRentPrice: selectedRenPrice);
                                            final rentalCartItem =
                                                RentalCartItemModel(
                                                    productOwnerID:
                                                        productOwnerModel
                                                            .productOwnerID,
                                                    productOwnerName:
                                                        productOwnerModel
                                                            .fullName,
                                                    productOwnerAddress:
                                                        productOwnerModel
                                                            .address,
                                                    productDetailModel: [
                                                  selectedProduct
                                                ]);
                                            rentalCartProvider.addToRentalCart(
                                                rentalCartItem);
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(SnackBar(
                                              backgroundColor: Colors.green,
                                              content: Text(
                                                  'Sản phẩm đã được thêm vào giỏ hàng.'),
                                            ));
                                          }
                                        } else if (productDetailModel.status ==
                                            "SOLD_OUT") {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                            backgroundColor: Colors.red,
                                            content: Text(
                                              'Sản phẩm đã hết hàng.',
                                            ),
                                          ));
                                        }
                                      } else {
                                        showCustomDialog(context, 'Lỗi',
                                            'Vui lòng chọn ngày thuê', true);
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
                                    onChanged: (value) {
                                      if (widget.productDetailModel!.term !=
                                          '') {
                                        if (isAccept) {
                                          toggleRenting(value);
                                        } else {
                                          showCustomDialog(
                                              context,
                                              'Lỗi',
                                              "Vui lòng đọc và đồng ý quy định mua",
                                              true);
                                        }
                                      } else {
                                        toggleRenting(value);
                                      }
                                    },
                                    // onChanged: toggleRenting
                                  ),
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
                                    onTap: () {
                                      final productAlreadyInCart =
                                          cartProvider.isProductInCart(
                                              productDetailModel.productID);
                                      if (productDetailModel.status ==
                                          "AVAILABLE") {
                                        if (productAlreadyInCart) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              backgroundColor: Colors.red,
                                              content: Text(
                                                  'Sản phẩm đã có trong giỏ hàng Mua'),
                                            ),
                                          );
                                        } else {
                                          final cartItem = CartItemModel(
                                            productOwnerID: productOwnerModel
                                                .productOwnerID,
                                            productOwnerName:
                                                productOwnerModel.fullName,
                                            productOwnerAddress:
                                                productOwnerModel.address,
                                            productDetailModel: [
                                              widget.productDetailModel!,
                                            ],
                                          );

                                          cartProvider.addToCart(cartItem);
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                            backgroundColor: Colors.green,
                                            content: Text(
                                                'Sản phẩm đã được thêm vào giỏ hàng.'),
                                          ));
                                        }
                                      } else if (productDetailModel.status ==
                                          "SOLD_OUT") {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                          backgroundColor: Colors.red,
                                          content: Text(
                                            'Sản phẩm đã hết hàng.',
                                          ),
                                        ));
                                      }
                                      // else if (productDetailModel.status ==
                                      //     "RENTING") {
                                      //   ScaffoldMessenger.of(context)
                                      //       .showSnackBar(SnackBar(
                                      //     backgroundColor: Colors.blue,
                                      //     content: Text(
                                      //       'Sản phẩm đang thuê.',
                                      //     ),
                                      //   ));
                                      // }
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
