import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:frs_mobile/core/constants/color_constants.dart';
import 'package:frs_mobile/core/constants/dismension_constants.dart';
import 'package:frs_mobile/core/constants/textstyle_constants.dart';
import 'package:frs_mobile/models/productOwner_model.dart';
import 'package:frs_mobile/models/product_detail_model.dart';
import 'package:frs_mobile/models/product_image_model.dart';
import 'package:frs_mobile/representation/screens/favorite/services/api_favorite.dart';
import 'package:frs_mobile/representation/screens/product_detail/product_detail_demo.dart';
import 'package:frs_mobile/services/authentication_service.dart';
import 'package:frs_mobile/services/authprovider.dart';
import 'package:intl/intl.dart';
import '../../../utils/asset_helper.dart';
import '../../../utils/image_helper.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});
  static const String routeName = '/favorite_screen';
  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  @override
  void initState() {
    super.initState();
  }

  Future<List<Map<String, dynamic>>?> fetchFavoriteProducts() async {
    return await ApiFavorite.getFavoriteByCusID(
        AuthProvider.userModel!.customer!.customerID);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorPalette.backgroundScaffoldColor,
        leading: ImageHelper.loadFromAsset(AssetHelper.imageLogoFRS),
        title: Center(
          child: Text('Yêu thích'),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: FutureBuilder<List<Map<String, dynamic>>?>(
          future: fetchFavoriteProducts(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Text('Lỗi: ${snapshot.error}');
            } else if (snapshot.hasData) {
              final products = snapshot.data;
              if (products!.isEmpty) {
                return Center(
                  child: Text('Không có sản phẩm yêu thích.'),
                );
              }
              return GridView.builder(
                physics: ScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisExtent: 300,
                  mainAxisSpacing: 20,
                  crossAxisSpacing: 10,
                ),
                shrinkWrap: true,
                itemCount: products.length,
                itemBuilder: ((context, index) {
                  return Transform.translate(
                    offset: Offset(0, index.isOdd ? 50.0 : 0.0),
                    child: GestureDetector(
                      onTap: () async {
                        ProductDetailModel? productDetail =
                            await AuthenticationService.getProductByID(
                                products[index]['productDTO']['productID']);
                        int productOwnerID = productDetail!.productOwnerID;
                        ProductOwnerModel? productOwnerModel =
                            await AuthenticationService.getProductOwnerByID(
                                productOwnerID);
                        List<ProductImageModel>? productImages =
                            await AuthenticationService
                                .getAllProductImgByProductID(
                                    products[index]['productDTO']['productID']);

                        await Navigator.of(context).push(
                          CupertinoPageRoute(
                            builder: (context) => ProductDetailDemo(
                              productImageModel: productImages!,
                              productOwnerModel: productOwnerModel,
                              productDetailModel: productDetail,
                            ),
                          ),
                        );
                        setState(() {});
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(kDefaultCircle14),
                        child: Container(
                          color: ColorPalette.hideColor,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Stack(
                                children: [
                                  AspectRatio(
                                    aspectRatio: 14 / 9,
                                    child: Image.network(
                                        products[index]['productDTO']
                                            ['productAvt'],
                                        fit: BoxFit.cover),
                                  ),
                                  Positioned(
                                    right: 5,
                                    top: 5,
                                    child: GestureDetector(
                                      onTap: () async {
                                        await ApiFavorite.unmarkFavoriteStatus(
                                            products[index]
                                                ['favoriteProductID']);
                                        setState(() {
                                          products.removeWhere((product) =>
                                              product['favoriteProductID'] ==
                                              products[index]
                                                  ['favoriteProductID']);
                                        });
                                      },
                                      child: Icon(
                                        FontAwesomeIcons.solidHeart,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 5),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: 160,
                                      child: AutoSizeText(
                                        overflow: TextOverflow.ellipsis,
                                        minFontSize: 16,
                                        maxLines: 1,
                                        '${products[index]['productDTO']['productName']}',
                                        style: TextStyles.h5.bold,
                                      ),
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
                                                    style: TextStyles
                                                        .defaultStyle.bold),
                                                TextSpan(
                                                  text:
                                                      '${products[index]['productDTO']['productCondition'] != null ? (products[index]['productDTO']['productCondition']) : "N/A"}%',
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 2),
                                    if (products[index]['productDTO']
                                                ['checkType'] ==
                                            "SALE" ||
                                        products[index]['productDTO']
                                                ['checkType'] ==
                                            "SALE_RENT")
                                      Container(
                                        width: 160,
                                        child: AutoSizeText.rich(
                                          maxLines: 1,
                                          TextSpan(
                                            children: [
                                              TextSpan(
                                                  text: 'Mua: ',
                                                  style: TextStyles
                                                      .defaultStyle.bold),
                                              TextSpan(
                                                text:
                                                    '${NumberFormat.currency(locale: 'vi_VN', symbol: 'vnđ').format(products[index]['productDTO']['price'])}',
                                              ),
                                            ],
                                          ),
                                        ),
                                      )
                                    else
                                      SizedBox.shrink(),
                                    // SizedBox(height: 5),
                                    if (products[index]['productDTO']
                                                ['checkType'] ==
                                            "RENT" ||
                                        products[index]['productDTO']
                                                ['checkType'] ==
                                            "SALE_RENT")
                                      Container(
                                        width: 160,
                                        child: AutoSizeText.rich(
                                          maxLines: 1,
                                          TextSpan(
                                            children: [
                                              TextSpan(
                                                  text: 'Thuê: ',
                                                  style: TextStyles
                                                      .defaultStyle.bold),
                                              TextSpan(
                                                  text: products[index]
                                                                  ['productDTO']
                                                              ['rentprices']
                                                          .isNotEmpty
                                                      ? '${NumberFormat.currency(locale: 'vi_VN', symbol: 'vnđ').format(products[index]['productDTO']['rentprices'][0]['rentPrice'])}/${products[index]['productDTO']['rentprices'][0]['mockDay']} ngày'
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
                                    if (products[index]['productDTO']
                                            ['status'] ==
                                        "SOLD_OUT")
                                      Text(
                                        "HẾT HÀNG",
                                        style: TextStyles.h5.bold
                                            .setColor(Colors.red),
                                      ),
                                    if (products[index]['productDTO']
                                            ['status'] ==
                                        "AVAILABLE")
                                      Text(
                                        "CÓ SẴN",
                                        style: TextStyles.h5.bold
                                            .setColor(Colors.green),
                                      ),
                                    if (products[index]['productDTO']
                                            ['status'] ==
                                        "RENTING")
                                      Text(
                                        "ĐANG THUÊ",
                                        style: TextStyles.h5.bold
                                            .setColor(Colors.blue),
                                      ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              );
            } else {
              return Text('Không có dữ liệu sản phẩm');
            }
          },
        ),
      ),
    );
  }
}
