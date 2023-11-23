import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:like_button/like_button.dart';

import '../../core/constants/color_constants.dart';
import '../../core/constants/dismension_constants.dart';
import '../../core/constants/textstyle_constants.dart';
import '../../models/product_model.dart';
import '../../utils/asset_helper.dart';
import '../../utils/image_helper.dart';

class ProductCardDemo extends StatefulWidget {
  final ProductModel product;
  // final double aspectRatio;

  const ProductCardDemo({
    super.key,
    required this.product,
    // required this.aspectRatio,
  });

  @override
  State<ProductCardDemo> createState() => _ProductCardDemoState();
}

class _ProductCardDemoState extends State<ProductCardDemo> {
  @override
  Widget build(BuildContext context) {
    final bool isForSale = widget.product.checkType.contains('SALE');
    final bool isForRent = widget.product.checkType.contains('RENT');
    final bool isForSaleAndRent =
        widget.product.checkType.contains('SALE_RENT');

    return ClipRRect(
      borderRadius: BorderRadius.circular(kDefaultCircle14),
      child: Container(
        color: ColorPalette.hideColor,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //img
            Stack(
              children: [
                AspectRatio(
                  // aspectRatio: aspectRatio,
                  aspectRatio: 14 / 9,
                  child: widget.product.productAvt == null
                      ? ImageHelper.loadFromAsset(AssetHelper.imageKinhGucci,
                          fit: BoxFit.contain)
                      : Image.network(widget.product.productAvt!,
                          fit: BoxFit.cover),
                ),
                Positioned(
                  right: 1,
                  top: 1,
                  child: LikeButton(
                    bubblesSize: 100,
                    bubblesColor: BubblesColor(
                        dotPrimaryColor: Colors.red,
                        dotSecondaryColor: Colors.black),
                    isLiked: widget.product.isFavorite,
                    onTap: (bool isLiked) async {
                      setState(() {
                        widget.product.isFavorite = !widget.product.isFavorite;
                      });
                      return widget.product.isFavorite;
                    },
                    size: 38,
                    likeBuilder: (isLiked) {
                      return isLiked
                          ? Icon(FontAwesomeIcons.solidHeart)
                          : Icon(
                              FontAwesomeIcons.heart,
                              // color: isLiked ? Colors.red : Colors.amber,
                            );
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: 5),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 160,
                    child: AutoSizeText(
                      overflow: TextOverflow.ellipsis,
                      minFontSize: 16,
                      maxLines: 1,
                      widget.product.productName,
                      style: TextStyles.h5.bold,
                    ),
                  ),
                  SizedBox(height: 2),
                  Row(
                    children: [
                      Container(
                        width: 160,
                        child: AutoSizeText.rich(
                          minFontSize: 14,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          TextSpan(
                            children: [
                              TextSpan(
                                  text: 'Thương hiệu: ',
                                  style: TextStyles.defaultStyle.bold),
                              TextSpan(
                                text:
                                    '${widget.product.productSpecifications != null ? (widget.product.getBrandName()) : "N/A"}',
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 2),
                  Row(
                    children: [
                      Container(
                        width: 160,
                        child: AutoSizeText.rich(
                          maxLines: 1,
                          TextSpan(
                            children: [
                              TextSpan(
                                  text: 'Tình trạng: ',
                                  style: TextStyles.defaultStyle.bold),
                              TextSpan(
                                text:
                                    '${widget.product.productCondition != null ? (widget.product.productCondition) : "N/A"}%',
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 2),

                  //Price
                  if (isForSale || isForSaleAndRent)
                    Container(
                      width: 160,
                      child: AutoSizeText.rich(
                        maxLines: 1,
                        TextSpan(
                          children: [
                            TextSpan(
                                text: 'Mua: ',
                                style: TextStyles.defaultStyle.bold),
                            TextSpan(
                              text:
                                  '${NumberFormat.currency(locale: 'vi_VN', symbol: 'vnđ').format(widget.product.price)}',
                            ),
                          ],
                        ),
                      ),
                    )
                  else
                    SizedBox.shrink(),
                  // SizedBox(height: 5),
                  if (isForRent || isForSaleAndRent)
                    Container(
                      width: 160,
                      child: AutoSizeText.rich(
                        maxLines: 1,
                        TextSpan(
                          children: [
                            TextSpan(
                                text: 'Thuê: ',
                                style: TextStyles.defaultStyle.bold),
                            TextSpan(
                                text: widget.product.rentalPrice!.isNotEmpty
                                    ? '${NumberFormat.currency(locale: 'vi_VN', symbol: 'vnđ').format(widget.product.rentalPrice![0]!.rentPrice)}/${widget.product.rentalPrice![0]!.mockDay} ngày'
                                    : 'N/A'),
                          ],
                        ),
                      ),
                    )
                  else
                    SizedBox.shrink(),
                  SizedBox(height: 2),
                  Row(
                    children: [
                      Icon(
                        FontAwesomeIcons.solidStar,
                        size: kDefaultCircle14,
                        color: Colors.amber,
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      Text(
                        '5.0',
                      ),
                    ],
                  ),
                  SizedBox(height: 2),
                  if (widget.product.status == "SOLD_OUT")
                    Text(
                      "HẾT HÀNG",
                      style: TextStyles.h5.bold.setColor(Colors.red),
                    ),
                  if (widget.product.status == "BLOCKED")
                    Text(
                      "BỊ KHÓA",
                      style: TextStyles.h5.bold.setColor(Colors.red),
                    ),
                  if (widget.product.status == "WAITING")
                    Text(
                      "ĐANG CHỜ",
                      style: TextStyles.h5.bold.setColor(Colors.red),
                    ),
                  if (widget.product.status == "AVAILABLE")
                    Text(
                      "CÓ SẴN",
                      style: TextStyles.h5.bold.setColor(Colors.green),
                    ),
                  if (widget.product.status == "RENTING")
                    Text(
                      "ĐANG THUÊ",
                      style: TextStyles.h5.bold.setColor(Colors.blue),
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
