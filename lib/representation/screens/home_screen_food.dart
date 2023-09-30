import 'package:carousel_slider/carousel_slider.dart';
import 'package:demo_frs_app/core/constants/color_constants.dart';
import 'package:demo_frs_app/core/constants/dismension_constants.dart';
import 'package:demo_frs_app/core/constants/textstyle_constants.dart';
import 'package:demo_frs_app/core/helper/asset_helper.dart';

import 'package:demo_frs_app/models/product.dart';
import 'package:demo_frs_app/representation/widgets/app_bar_main.dart';
import 'package:demo_frs_app/representation/widgets/product_card.dart';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
  });

  static const String routeName = '/home_screen';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final CarouselController _controller = CarouselController();
  int _currentIndexBanner = 0;
  int _currentIndexBrand = 0;

  // final List<Widget> _bannerImages = [
  //   ImageHelper.loadFromAsset(AssetHelper.imageBanner1),
  //   ImageHelper.loadFromAsset(AssetHelper.imageBanner2),
  //   ImageHelper.loadFromAsset(AssetHelper.imageBanner3),
  // ];

  //
  List<String> brandList = [
    "Dior",
    "Chanel",
    "Gucci",
    "Louis Vuitton",
    'ahihi',
    'ahuhu',
  ];

  List<Product> allProducts = [
    Product(
        name: 'Túi Dior',
        price: '100.000',
        imagePath: AssetHelper.imageDior,
        rating: '4.9',
        brand: 'Dior'),
    Product(
        name: 'Túi Chanel',
        price: '200.000',
        imagePath: AssetHelper.imageChanel,
        rating: '4.2',
        brand: 'Chanel'),
    Product(
        name: 'Túi Gucci',
        price: '300.000',
        imagePath: AssetHelper.imageGucci,
        rating: '4.4',
        brand: 'Gucci'),
    Product(
        name: 'Túi Louis Vuitton',
        price: '1.200.000',
        imagePath: AssetHelper.imageLV,
        rating: '4.1',
        brand: 'Louis Vuitton'),
    Product(
        name: 'Túi Louis Vuitton',
        price: '1.100.000',
        imagePath: AssetHelper.imageLV,
        rating: '4.1',
        brand: 'Louis Vuitton'),
    Product(
        name: 'Túi Louis Vuitton',
        price: '1.000.000',
        imagePath: AssetHelper.imageLV,
        rating: '4.1',
        brand: 'Louis Vuitton'),
    Product(
        name: 'Túi Louis Vuitton',
        price: '900.000',
        imagePath: AssetHelper.imageLV,
        rating: '4.1',
        brand: 'Louis Vuitton'),
    Product(
        name: 'Túi Louis Vuitton',
        price: '800.000',
        imagePath: AssetHelper.imageLV,
        rating: '4.1',
        brand: 'Louis Vuitton'),
    Product(
        name: 'Túi Louis Vuitton',
        price: '700.000',
        imagePath: AssetHelper.imageLV,
        rating: '4.1',
        brand: 'Louis Vuitton'),
    Product(
        name: 'Túi Louis Vuitton',
        price: '500.000',
        imagePath: AssetHelper.imageLV,
        rating: '4.1',
        brand: 'Louis Vuitton'),
    Product(
        name: 'Túi Louis Vuitton',
        price: '600.000',
        imagePath: AssetHelper.imageLV,
        rating: '4.1',
        brand: 'Louis Vuitton'),
  ];

  String selectedBrand = ""; // Không có thương hiệu nào được chọn ban đầu
  List<Product> filteredProducts = [];

  void filterProductByBrand(String brand) {
    setState(() {
      selectedBrand = brand;
      if (brand.isNotEmpty) {
        filteredProducts =
            allProducts.where((product) => product.brand == brand).toList();
      } else {
        filteredProducts = allProducts;
      }
    });
  }

  @override
  void initState() {
    super.initState();
    filteredProducts = allProducts;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size; // get screen size
    return AppBarMain(
      isBack: false,
      child: Scaffold(
        extendBodyBehindAppBar: true,
        body: SingleChildScrollView(
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // CarouselSlider.builder(
                  //   carouselController: _controller,
                  //   itemCount: _bannerImages.length,
                  //   itemBuilder:
                  //       (BuildContext context, int index, int realIndex) {
                  //     return _bannerImages[index];
                  //   },
                  //   options: CarouselOptions(
                  //     autoPlay: false,
                  //     enlargeCenterPage: true, // phóng to trung tâm trang
                  //     // height: 200,
                  //     aspectRatio: 16 / 9,
                  //     onPageChanged: (index, reason) {
                  //       setState(() {
                  //         _currentIndexBanner = index;
                  //       });
                  //     },
                  //   ),
                  // ),
                  // Container(
                  //   height: 8,
                  //   // margin: EdgeInsets.symmetric(vertical: 13, horizontal: 30), //
                  //   child: ListView.builder(
                  //     // nằm giữa hay không là nó nằm ở shrinWrap này nè
                  //     shrinkWrap:
                  //         true, // Cho phép ListView.builder co lại theo nội dung
                  //     itemCount: _bannerImages.length,
                  //     scrollDirection: Axis.horizontal,
                  //     itemBuilder: (context, index) {
                  //       return buildIndicator(
                  //           index == _currentIndexBanner, size);
                  //     },
                  //   ),
                  // ),
                  Column(
                    children: [
                      // SizedBox(
                      //   height: 10,
                      // ),

                      // Search
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              decoration: InputDecoration(
                                hintText: 'Tìm kiếm',
                                hintStyle: TextStyles.defaultStyle,
                                prefixIcon: Padding(
                                  padding: EdgeInsets.all(kTopPadding),
                                  child: Icon(
                                    FontAwesomeIcons.magnifyingGlass,
                                    color: ColorPalette.primaryColor,
                                    size: kDefaultIconSize,
                                  ),
                                ),
                                filled: true,
                                fillColor: ColorPalette.hideColor,
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: ColorPalette.primaryColor),
                                    borderRadius: BorderRadius.circular(14)),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: kItemPadding),
                              ),
                            ),
                          ),
                          SizedBox(width: 10),

                          // filter category
                          GestureDetector(
                            child: Icon(
                              FontAwesomeIcons.sliders,
                              size: kDefaultIconSize,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Text(
                            'Thương hiệu',
                            style: TextStyles.defaultStyle.bold,
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      //brand
                      Container(
                        height: 40,
                        child: ListView.builder(
                          itemCount: brandList.length,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            String brand = brandList[index];
                            bool isSelected = index == _currentIndexBrand;
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  _currentIndexBrand == index;

                                  filteredProducts = allProducts
                                      .where(
                                          (product) => product.brand == brand)
                                      .toList();
                                });
                              },
                              // cục hiển thị cho các brand
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 5),
                                    margin: EdgeInsets.only(right: 10),
                                    decoration: BoxDecoration(
                                      color: isSelected
                                          ? ColorPalette.primaryColor
                                          : ColorPalette.hideColor,
                                      borderRadius: BorderRadius.circular(14),
                                    ),

                                    // Text của brand
                                    child: Text(
                                      brand,
                                      style: TextStyle(
                                          color: isSelected
                                              ? Colors.white
                                              : ColorPalette.textColor,
                                          fontWeight: isSelected
                                              ? FontWeight.bold
                                              : FontWeight.normal,
                                          fontFamily: FontFamilyRoboto.roboto),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Text(
                            'Sản phẩm',
                            style: TextStyles.defaultStyle.bold,
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      // load sản phẩm
                      GridView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        scrollDirection: Axis.vertical,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio:
                              (MediaQuery.of(context).size.width - 30 - 15) /
                                  (2 * 290),
                          mainAxisSpacing: 10,
                          crossAxisSpacing: 10,
                        ),
                        shrinkWrap: true,
                        itemCount: filteredProducts.length,
                        itemBuilder: ((context, index) {
                          if (index % 2 == 0) {
                            return GestureDetector(
                              onTap: () {
                                print('aaaa');
                              },
                              child:
                                  ProductCard(product: filteredProducts[index]),
                            );
                          }
                          return OverflowBox(
                            maxHeight: 290.0 + 70.0,
                            child: GestureDetector(
                                onTap: () {
                                  print('object');
                                },
                                child: Container(
                                  margin: EdgeInsets.only(top: 70),
                                  child: ProductCard(
                                      product: filteredProducts[index]),
                                )),
                          );
                        }),
                      ),

                      // những sản phẩm
                      // ListView.builder(
                      //   shrinkWrap: true,
                      //   itemCount: filteredProducts.length,
                      //   itemBuilder: (context, index) {
                      //     return ListTile(
                      //       title: Text(filteredProducts[index].name),
                      //     );
                      //   },
                      // )
                    ],
                  ),
                  // ListView.builder(
                  //   shrinkWrap: true,
                  //   itemCount: brandList.length,
                  //   scrollDirection: Axis.horizontal,
                  //   itemBuilder: (context, index) {
                  //     return ListTile(
                  //       title: Text(brandList[index]),
                  //     );
                  //   },
                  // ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

Widget buildIndicator(bool isActive, Size size) {
  return AnimatedContainer(
    duration: Duration(milliseconds: 300),
    curve: Curves.bounceInOut,
    margin: EdgeInsets.symmetric(horizontal: 10), // cách từng cục item
    width: isActive ? 20 : 10,
    decoration: BoxDecoration(
      color: isActive ? Colors.black : Colors.grey,
      borderRadius: BorderRadius.circular(5),
      // boxShadow: [
      //   BoxShadow(color: Colors.black38, offset: Offset(3, 6), blurRadius: 3),
      // ],
    ),
  );
}
