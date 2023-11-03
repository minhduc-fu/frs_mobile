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
                  : Image.network(product.productAvt!, fit: BoxFit.contain),
            ),
            SizedBox(height: 5),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.productName,
                    style: TextStyles.h5.bold,
                  ),
                  // SizedBox(height: 2),
                  // ProductName
                  Text(
                    product.productOwnerName,
                    style: TextStyles.defaultStyle.bold,
                  ),
                  // SizedBox(height: 2),
                  Row(
                    children: [
                      Text(
                        'Thương hiệu: ${product.productSpecifications != null ? (product.productSpecifications?['brandName'] ?? "N/A") : "N/A"}',
                      ),
                    ],
                  ),
                  // SizedBox(height: 2),
                  Row(
                    children: [
                      Text(
                        'Tình trạng: ',
                        style: TextStyles.defaultStyle.bold,
                      ),
                      Text(
                        product.productCondition,
                      ),
                    ],
                  ),
                  // SizedBox(height: 2),

                  //Price
                  if (isForSale || isForSaleAndRent)
                    Text(
                      'Mua: ${NumberFormat.currency(locale: 'vi_VN', symbol: 'vnđ').format(product.price)}',
                    )
                  // Row(
                  //   children: [
                  //     // Text(
                  //     //   'Mua: ',
                  //     //   style: TextStyles.defaultStyle.bold,
                  //     // ),
                  //     Text(
                  //       'Mua: ${NumberFormat.currency(locale: 'vi_VN', symbol: 'vnđ').format(product.price)}',
                  //     ),
                  //   ],
                  // )
                  else
                    SizedBox.shrink(),
                  // SizedBox(height: 5),
                  if (isForRent || isForSaleAndRent)
                    Row(
                      children: [
                        Text(
                          'Thuê: ',
                          style: TextStyles.defaultStyle.bold,
                        ),
                        Text(
                          '${NumberFormat.currency(locale: 'vi_VN', symbol: 'vnđ').format(0.0)}',
                          // '${NumberFormat.currency(locale: 'vi_VN', symbol: 'vnđ').format(product.rentalPrice != null ? product.rentalPrice?.rentPrice1 : 0.0)}',
                        ),
                      ],
                    )
                  else
                    SizedBox.shrink(),
                  // SizedBox(height: 5),
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
