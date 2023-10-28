import 'dart:convert';

import 'package:demo_frs_app/core/constants/color_constants.dart';
import 'package:demo_frs_app/core/constants/dismension_constants.dart';
import 'package:demo_frs_app/core/constants/textstyle_constants.dart';
import 'package:demo_frs_app/models/product_model.dart';
import 'package:demo_frs_app/utils/asset_helper.dart';
import 'package:demo_frs_app/utils/image_helper.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

class ProductCardDemo extends StatelessWidget {
  final ProductModel product;
  const ProductCardDemo({
    super.key,
    required this.product,
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
              aspectRatio: 16 / 9,
              child: product.productAvt == null
                  ? ImageHelper.loadFromAsset(AssetHelper.imageKinhGucci,
                      fit: BoxFit.cover)
                  : Image.network(product.productAvt!, fit: BoxFit.cover),
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
                  SizedBox(height: 5),
                  // ProductName
                  Text(
                    product.productOwnerName,
                  ),
                  SizedBox(height: 5),
                  Text(
                    'Thương hiệu: ${product.productSpecifications != null ? (product.productSpecifications?['brandName'] ?? "N/A") : "N/A"}',
                  ),

                  //Price
                  if (isForSale || isForSaleAndRent)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Mua: ${NumberFormat.currency(locale: 'vi_VN', symbol: 'vnđ').format(product.price)}',
                        ),
                        // Row(
                        //   children: [
                        //     Expanded(
                        //       child: Divider(
                        //         thickness: 1,
                        //         color: ColorPalette.textColor,
                        //         // color: ColorPalette.white1,
                        //       ),
                        //     ),
                        //     SizedBox(width: 40),
                        //   ],
                        // ),
                      ],
                    )
                  else
                    SizedBox.shrink(),
                  SizedBox(height: 5),
                  if (isForRent || isForSaleAndRent)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Thuê: ${NumberFormat.currency(locale: 'vi_VN', symbol: 'vnđ').format(product.rentalPrice?.rentPrice1)}',
                        ),
                      ],
                    )
                  else
                    SizedBox.shrink(),
                  SizedBox(height: 5),
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
