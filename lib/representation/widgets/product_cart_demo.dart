import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

import '../../core/constants/color_constants.dart';
import '../../core/constants/dismension_constants.dart';
import '../../core/constants/textstyle_constants.dart';
import '../../models/product_model.dart';
import '../../utils/asset_helper.dart';
import '../../utils/image_helper.dart';

class ProductCardDemo extends StatelessWidget {
  final ProductModel product;
  // final double aspectRatio;

  const ProductCardDemo({
    super.key,
    required this.product,
    // required this.aspectRatio,
  });

  @override
  Widget build(BuildContext context) {
    final bool isForSale = product.checkType.contains('SALE');
    final bool isForRent = product.checkType.contains('RENT');
    final bool isForSaleAndRent = product.checkType.contains('SALE_RENT');

    return ClipRRect(
      borderRadius: BorderRadius.circular(kDefaultCircle14),
      child: Container(
        color: ColorPalette.hideColor,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //img
            AspectRatio(
              // aspectRatio: aspectRatio,
              aspectRatio: 16 / 9,
              child: product.productAvt == null
                  ? ImageHelper.loadFromAsset(AssetHelper.imageKinhGucci,
                      fit: BoxFit.contain)
                  : Image.network(product.productAvt!, fit: BoxFit.cover),
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
                      product.productName,
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
                                    '${product.productSpecifications != null ? (product.getBrandName()) : "N/A"}',
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
                                    '${product.productCondition != null ? (product.productCondition) : "N/A"}%',
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
                                  '${NumberFormat.currency(locale: 'vi_VN', symbol: 'vnđ').format(product.price)}',
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
                                text: product.rentalPrice!.isNotEmpty
                                    ? '${NumberFormat.currency(locale: 'vi_VN', symbol: 'vnđ').format(product.rentalPrice![0]!.rentPrice)}/${product.rentalPrice![0]!.mockDay} ngày'
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
                  if (product.status == "SOLD_OUT")
                    Text(
                      "HẾT HÀNG",
                      style: TextStyles.h5.bold.setColor(Colors.red),
                    ),
                  if (product.status == "BLOCKED")
                    Text(
                      "BỊ KHÓA",
                      style: TextStyles.h5.bold.setColor(Colors.red),
                    ),
                  if (product.status == "WAITING")
                    Text(
                      "ĐANG CHỜ",
                      style: TextStyles.h5.bold.setColor(Colors.red),
                    ),
                  if (product.status == "AVAILABLE")
                    Text(
                      "CÓ SẴN",
                      style: TextStyles.h5.bold.setColor(Colors.green),
                    ),
                  if (product.status == "RENTING")
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
