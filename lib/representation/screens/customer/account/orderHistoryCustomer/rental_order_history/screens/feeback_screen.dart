import 'dart:typed_data';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:frs_mobile/core/constants/color_constants.dart';
import 'package:frs_mobile/core/constants/dismension_constants.dart';
import 'package:frs_mobile/core/constants/my_textformfield.dart';
import 'package:frs_mobile/core/constants/textstyle_constants.dart';
import 'package:frs_mobile/models/productOwner_model.dart';
import 'package:frs_mobile/representation/screens/customer/account/orderHistoryCustomer/rental_order_history/models/order_rent_detail_model.dart';
import 'package:frs_mobile/representation/screens/customer/account/orderHistoryCustomer/rental_order_history/models/order_rent_model.dart';
import 'package:frs_mobile/representation/screens/customer/account/orderHistoryCustomer/rental_order_history/services/api_order_rent_history.dart';
import 'package:frs_mobile/representation/screens/product_detail/services/api_product_detail.dart';
import 'package:frs_mobile/representation/widgets/button_widget.dart';
import 'package:frs_mobile/services/add_image_cloud.dart';
import 'package:frs_mobile/services/authentication_service.dart';
import 'package:frs_mobile/services/authprovider.dart';
import 'package:frs_mobile/utils/dialog_helper.dart';
import 'package:frs_mobile/utils/image_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:like_button/like_button.dart';

class FeedbackScreen extends StatefulWidget {
  final OrderRentModel order;
  const FeedbackScreen({super.key, required this.order});

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  List<OrderRentDetailModel>? orderDetails;
  ProductOwnerModel? productOwnerModel;

  bool isPO = true;
  bool showListView = false;
  List<bool> showListViewList = [];

  List<List<Uint8List>> imagesList = [];

  void selectImage(int orderDetailIndex) async {
    if (imagesList[orderDetailIndex].length < 3) {
      Uint8List? img = await pickAImage(ImageSource.gallery);
      if (img != null && img.isNotEmpty) {
        setState(() {
          imagesList[orderDetailIndex].add(img);
          if (imagesList[orderDetailIndex].length == 3) {
            showListViewList[orderDetailIndex] = true;
          }
        });
        orderDetails![orderDetailIndex].imagesFeedback =
            imagesList[orderDetailIndex];
        if (imagesList[orderDetailIndex].length == 3) {
          print("${orderDetails![orderDetailIndex].imagesFeedback}");
        }
      }
    }
  }

  void retakeImage(int orderDetailIndex, int imageIndex) async {
    Uint8List img = await pickAImage(ImageSource.gallery);
    if (img.isNotEmpty) {
      setState(() {
        imagesList[orderDetailIndex][imageIndex] = img;
      });
      orderDetails![orderDetailIndex].imagesFeedback =
          imagesList[orderDetailIndex];
    }
  }

  String getRatingDescription(double rating) {
    if (rating == 5) {
      return "Tuyệt vời";
    } else if (rating == 4) {
      return "Hài lòng";
    } else if (rating == 3) {
      return "Bình thường";
    } else if (rating == 2) {
      return "Không hài lòng";
    } else {
      return "Tệ";
    }
  }

  @override
  void initState() {
    super.initState();
    fetchData();
    fetchPO();
  }

  List<TextEditingController> descriptionControllers = [];

  Future<void> fetchData() async {
    orderDetails = await ApiOderRentHistory.getAllOrderRentDetailByOrderRentID(
      widget.order.orderRentID,
    );
    setState(() {
      if (orderDetails != null) {
        imagesList = List.generate(orderDetails!.length, (index) => []);
        showListViewList =
            List.generate(orderDetails!.length, (index) => false);
      }
    });
  }

  Future<void> fetchPO() async {
    productOwnerModel = await AuthenticationService.getProductOwnerByID(
        widget.order.productownerID);
    setState(() {
      setState(() {});
    });
  }

  Future<void> sendFeedback() async {
    bool allOrderDetailsValid = true;
    for (int i = 0; i < orderDetails!.length; i++) {
      if (imagesList[i].isEmpty) {
        showCustomDialog(context, 'Lỗi', 'Vui lòng gửi ít nhất một ảnh.', true);
        allOrderDetailsValid = false;
        break;
      } else if (descriptionControllers[i].text.isEmpty) {
        showCustomDialog(context, 'Lỗi', 'Vui lòng nhập đầy đủ mô tả.', true);
        allOrderDetailsValid = false;
        break;
      }
    }

    if (allOrderDetailsValid) {
      showDialog(
        context: context,
        builder: (context) {
          return Center(
            child: CircularProgressIndicator(
              color: ColorPalette.primaryColor,
            ),
          );
        },
      );
      try {
        for (int i = 0; i < orderDetails!.length; i++) {
          var product = orderDetails![i];
          int productID = product.productDTOModel.productID;
          int customerID = AuthProvider.userModel!.customer!.customerID;
          String descriptionFeedback = descriptionControllers[i].text;
          int ratingPoint = product.ratingFeedback!.toInt();
          int feedBackID = await ApiProductDetail.createFeedbackProduct(
            customerID,
            descriptionFeedback,
            productID,
            ratingPoint,
          );
          print('Feedback ID: $feedBackID');
          List<String> imageUrls = await AddImageCloud()
              .uploadListImageFeedbackToStorage('imagesFeedback', imagesList[i],
                  widget.order.orderRentID, feedBackID);
          await ApiProductDetail.createFeedBackImg(feedBackID, imageUrls);
          if (isPO) {
            await ApiProductDetail.votePOReputation(
                widget.order.productownerID);
          } else {
            await ApiProductDetail.unVoteReputation(
                widget.order.productownerID);
          }
          Navigator.pop(context);
        }
      } catch (e) {
        showCustomDialog(context, "Lỗi", e.toString(), true);
        return;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (orderDetails == null) {
      return Center(child: CircularProgressIndicator());
    }

    if (orderDetails!.isNotEmpty) {
      for (int i = 0; i < orderDetails!.length; i++) {
        if (descriptionControllers.isEmpty) {
          descriptionControllers = List.generate(
            orderDetails!.length,
            (index) => TextEditingController(
                text: orderDetails![i].descriptionFeedback),
          );
        }
      }
    }

    if (productOwnerModel == null) {
      return Center(child: CircularProgressIndicator());
    }

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
          'Đánh giá sản phẩm',
          style: TextStyles.defaultStyle.bold.setTextSize(19),
        ),
        backgroundColor: ColorPalette.backgroundScaffoldColor,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Sản phẩm',
                style: TextStyles.h5.bold,
              ),
              ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                itemCount: orderDetails!.length,
                shrinkWrap: true,
                itemBuilder: (BuildContext context, int index) {
                  var product = orderDetails![index];

                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: ColorPalette.textHide),
                        borderRadius: BorderRadius.circular(kDefaultCircle14),
                      ),
                      child: Column(
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.circular(kDefaultCircle14),
                                    border: Border.all(
                                        color: ColorPalette.primaryColor)),
                                child: ClipRRect(
                                  borderRadius:
                                      BorderRadius.circular(kDefaultCircle14),
                                  child: Image.network(
                                    cacheHeight: 40,
                                    cacheWidth: 40,
                                    product.productDTOModel.productAvt,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              SizedBox(width: 10),
                              // productName, price
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    width: 230,
                                    child: AutoSizeText(
                                      product.productDTOModel.productName,
                                      minFontSize: 16,
                                      style: TextStyles.h5.bold,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  Text(
                                    '${DateFormat('dd/MM/yyyy').format(product.startDate)} - ${DateFormat('dd/MM/yyyy').format(product.endDate)}',
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Divider(
                            thickness: 0.5,
                            color: ColorPalette.primaryColor,
                          ),
                          Row(
                            children: [
                              Text('Chất lượng sản phẩm',
                                  style: TextStyles.defaultStyle.bold),
                              SizedBox(width: 10),
                              RatingBar(
                                itemSize: 18,
                                // initialRating: ratingProduct,
                                initialRating: product.ratingFeedback!,
                                minRating: 1,
                                direction: Axis.horizontal,
                                allowHalfRating: false,
                                itemCount: 5,
                                itemPadding:
                                    EdgeInsets.symmetric(horizontal: 2.0),
                                ratingWidget: RatingWidget(
                                  full: Icon(
                                    FontAwesomeIcons.solidStar,
                                    color: Colors.amber,
                                    size: 18,
                                  ),
                                  half: Icon(FontAwesomeIcons.solidStar),
                                  empty: Icon(
                                    FontAwesomeIcons.star,
                                    color: Colors.amber,
                                    size: 18,
                                  ),
                                ),
                                onRatingUpdate: (rating) {
                                  setState(() {
                                    // productRatings[index] = rating;
                                    product.ratingFeedback = rating;
                                  });
                                  print(
                                      "${product.productDTOModel.productID}, ${product.ratingFeedback}");
                                },
                              ),
                              SizedBox(width: 10),
                              // Text(getRatingDescription(productRatings[index])),
                              Text(getRatingDescription(
                                  product.ratingFeedback!)),
                            ],
                          ),
                          SizedBox(height: 10),
                          imagesList[index].isNotEmpty
                              ? Row(
                                  children: [
                                    Container(
                                      height: 80,
                                      child: ListView.builder(
                                        physics: NeverScrollableScrollPhysics(),
                                        shrinkWrap: true,
                                        scrollDirection: Axis.horizontal,
                                        itemCount: imagesList[index].length,
                                        itemBuilder: (BuildContext context,
                                            int imgIndex) {
                                          return GestureDetector(
                                            onTap: () {
                                              retakeImage(index, imgIndex);
                                            },
                                            child: Container(
                                              margin: showListViewList[index]
                                                  ? EdgeInsets.symmetric(
                                                      horizontal: 21)
                                                  : EdgeInsets.only(right: 10),
                                              decoration: BoxDecoration(
                                                  border: Border.all(
                                                      color: Colors.grey),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          14)),
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(14),
                                                child: Image.memory(
                                                  imagesList[index][imgIndex],
                                                  // _images[imgIndex],
                                                  cacheHeight: 80,
                                                  cacheWidth: 80,
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                    showListViewList[index]
                                        ? SizedBox()
                                        : GestureDetector(
                                            onTap: () {
                                              selectImage(index);
                                            },
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(14),
                                                  border: Border.all(
                                                    color: Colors.grey,
                                                  )),
                                              height: 80,
                                              width: 80,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Icon(FontAwesomeIcons.camera,
                                                      size: 20),
                                                  Text(
                                                      '${3 - imagesList[index].length}/3'),
                                                ],
                                              ),
                                            ),
                                          )
                                  ],
                                )
                              : GestureDetector(
                                  onTap: () {
                                    selectImage(index);
                                  },
                                  child: Container(
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.grey),
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                    height: 80,
                                    width: double.infinity,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(FontAwesomeIcons.camera, size: 20),
                                        SizedBox(height: 10),
                                        Text('Thêm Hình ảnh'),
                                      ],
                                    ),
                                  ),
                                ),
                          SizedBox(height: 10),
                          MyTextFormField(
                              controller: descriptionControllers[index],
                              hintText:
                                  "Hãy chia sẽ nhận xét cho sản phẩm này bạn nhé!"),
                        ],
                      ),
                    ),
                  );
                },
              ),
              Text('Chủ sản phẩm', style: TextStyles.h5.bold),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: ColorPalette.textHide),
                    borderRadius: BorderRadius.circular(kDefaultCircle14),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.circular(kDefaultCircle14),
                                border: Border.all(
                                    color: ColorPalette.primaryColor)),
                            child: ClipRRect(
                              borderRadius:
                                  BorderRadius.circular(kDefaultCircle14),
                              child: Image.network(
                                cacheHeight: 40,
                                cacheWidth: 40,
                                productOwnerModel!.avatarUrl,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          SizedBox(width: 10),
                          Text(
                            widget.order.productOwnerName,
                            style: TextStyles.h5.bold,
                          )
                        ],
                      ),
                      Divider(
                        thickness: 0.5,
                        color: ColorPalette.primaryColor,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Độ tin cậy của Chủ sản phẩm',
                              style: TextStyles.defaultStyle.bold),
                          LikeButton(
                            bubblesSize: 100,
                            bubblesColor: BubblesColor(
                                dotPrimaryColor: Colors.blueAccent,
                                dotSecondaryColor: Colors.black),
                            isLiked: isPO,
                            size: 60,
                            onTap: (bool isLiked) {
                              setState(() {
                                isPO = !isLiked;
                              });
                              print('${isPO}');
                              return Future.value(!isLiked);
                            },
                            likeBuilder: (isLiked) {
                              return isLiked
                                  ? Row(
                                      children: [
                                        Icon(
                                          FontAwesomeIcons.solidHeart,
                                          color: Colors.redAccent,
                                        ),
                                        SizedBox(width: 10),
                                        Text(
                                          'Cao',
                                          style: TextStyles.defaultStyle
                                              .setColor(Colors.redAccent),
                                        )
                                      ],
                                    )
                                  : Row(
                                      children: [
                                        Icon(
                                          FontAwesomeIcons.heart,
                                          color: ColorPalette.primaryColor,
                                        ),
                                        SizedBox(width: 10),
                                        Text(
                                          'Cao',
                                          style: TextStyles.defaultStyle,
                                        )
                                      ],
                                    );
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 10),
              ButtonWidget(
                onTap: () {
                  sendFeedback();
                },
                title: 'Gửi',
                size: 18,
                height: 70,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
