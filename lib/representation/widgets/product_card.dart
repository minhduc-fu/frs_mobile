import 'package:demo_frs_app/core/constants/color_constants.dart';
import 'package:demo_frs_app/core/constants/dismension_constants.dart';
import 'package:demo_frs_app/core/constants/textstyle_constants.dart';
import 'package:demo_frs_app/models/product.dart';
import 'package:demo_frs_app/models/product_owner.dart';
import 'package:demo_frs_app/utils/image_helper.dart';
import 'package:demo_frs_app/utils/product_utils.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

class ProductCard extends StatelessWidget {
  final List<ProductOwner> allProductOwners;
  final Product product;
  const ProductCard({
    super.key,
    required this.product,
    required this.allProductOwners,
  });

  @override
  Widget build(BuildContext context) {
    ProductOwner owner = getOwnerOfProduct(product, allProductOwners);
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
              child: ImageHelper.loadFromAsset(product.productImg,
                  fit: BoxFit.cover),
            ),
            SizedBox(height: 5),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    owner.fullName,
                    // getProductOwnerFullName(
                    //     product.productOwnerID, allProductOwners),
                    style: TextStyles.h5.bold,
                  ),
                  SizedBox(height: 5),

                  // ProductName
                  Text(
                    product.productName,
                    style: TextStyles.defaultStyle,
                  ),
                  SizedBox(height: 5),

                  //Brand
                  Text(
                    product.productBrand,
                    style: TextStyles.defaultStyle,
                  ),
                  SizedBox(height: 5),

                  //Price
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Thuê: ${NumberFormat.currency(locale: 'vi_VN', symbol: 'đ').format(product.productPrice)}',
                        style: TextStyles.defaultStyle,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Divider(
                              thickness: 1,
                              color: ColorPalette.textColor,
                              // color: ColorPalette.white1,
                            ),
                          ),
                          SizedBox(width: 40),
                        ],
                      ),
                      Text(
                        'Mua: 20.000.000đ',
                        style: TextStyles.defaultStyle,
                      )
                    ],
                  ),
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
                        product.productRating,
                        style: TextStyles.defaultStyle,
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
