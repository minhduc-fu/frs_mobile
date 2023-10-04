import 'package:carousel_slider/carousel_slider.dart';
import 'package:demo_frs_app/core/constants/color_constants.dart';
import 'package:demo_frs_app/core/constants/dismension_constants.dart';
import 'package:demo_frs_app/core/constants/textstyle_constants.dart';
import 'package:demo_frs_app/core/helper/asset_helper.dart';
import 'package:demo_frs_app/core/helper/image_helper.dart';
import 'package:demo_frs_app/models/brand.dart';
import 'package:demo_frs_app/models/product.dart';
import 'package:demo_frs_app/models/search_result.dart';
import 'package:demo_frs_app/representation/screens/customer_main.dart';
import 'package:demo_frs_app/representation/screens/search_screen.dart';
import 'package:demo_frs_app/representation/widgets/app_bar_main.dart';
import 'package:demo_frs_app/representation/widgets/product_card.dart';
import 'package:flutter/cupertino.dart';

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
  int _currentIndexCategory = 0;
  String searchTerm = '';

  // final List<Widget> _bannerImages = [
  //   ImageHelper.loadFromAsset(AssetHelper.imageBanner1),
  //   ImageHelper.loadFromAsset(AssetHelper.imageBanner2),
  //   ImageHelper.loadFromAsset(AssetHelper.imageBanner3),
  // ];

  //
  List<String> brandList = [
    "DIOR",
    "CHANEL",
    "GUCCI",
    "LOUIS VUITTON",
    'PRADA',
    'VERSACE',
  ];
  List<String> categoryList = [
    'QUẦN',
    'ÁO',
    'TÚI',
    'KÍNH',
    'GIÀY',
    'ÁO KHOÁC',
  ];

  // List<Brand> brandList1 = [
  //   Brand(brandID: 1, brandName: 'DIOR'),
  //   Brand(brandID: 2, brandName: 'CHANEL'),
  //   Brand(brandID: 3, brandName: 'GUCCI'),
  //   Brand(brandID: 4, brandName: 'LOUIS VUITTON'),
  //   Brand(brandID: 5, brandName: 'PRADA'),
  //   Brand(brandID: 6, brandName: 'VERSACE'),
  // ];

  List<Product> allProducts = [
    Product(
        productName: 'Túi Dior',
        productPrice: 100000,
        productImg: AssetHelper.imageDior,
        productRating: '4.9',
        productBrand: 'DIOR',
        productCategory: 'TÚI'),
    Product(
        productName: 'Quần Versace',
        productPrice: 1100000,
        productImg: AssetHelper.imageQuanVersace,
        productRating: '4.1',
        productBrand: 'VERSACE',
        productCategory: 'QUẦN'),
    Product(
        productName: 'Kính Gucci',
        productPrice: 1000000,
        productImg: AssetHelper.imageKinhGucci,
        productRating: '4.1',
        productBrand: 'GUCCI',
        productCategory: 'KÍNH'),
    Product(
        productName: 'Áo khoác Gucci',
        productPrice: 900000,
        productImg: AssetHelper.imageAoKhoacGucci,
        productRating: '4.1',
        productBrand: 'GUCCI',
        productCategory: 'ÁO KHOÁC'),
    Product(
        productName: 'Áo Versace',
        productPrice: 800000,
        productImg: AssetHelper.imgaeAoVersace,
        productRating: '4.1',
        productBrand: 'VERSACE',
        productCategory: 'ÁO'),
    Product(
        productName: 'Túi Chanel',
        productPrice: 200000,
        productImg: AssetHelper.imageChanel,
        productRating: '4.2',
        productBrand: 'CHANEL',
        productCategory: 'TÚI'),
    Product(
        productName: 'Túi Gucci',
        productPrice: 300000,
        productImg: AssetHelper.imageGucci,
        productRating: '4.4',
        productBrand: 'GUCCI',
        productCategory: 'TÚI'),
    Product(
        productName: 'Túi Louis Vuitton',
        productPrice: 1200000,
        productImg: AssetHelper.imageLV,
        productRating: '4.1',
        productBrand: 'LOUIS VUITTON',
        productCategory: 'TÚI'),
  ];

  String selectedBrand = ""; // Không có thương hiệu nào được chọn ban đầu
  String selectedCategory = ""; // Không có thương hiệu nào được chọn ban đầu
  List<Product> filteredProducts = [];
  FocusNode _focusNode = FocusNode();
  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    filteredProducts = allProducts;
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  // Hàm lọc sản phẩm theo brand
  void filterProductByBrand(String brand) {
    setState(() {
      selectedBrand = brand;
      if (brand.isNotEmpty) {
        filteredProducts = allProducts
            .where((product) => product.productBrand == brand)
            .toList();
      } else {
        filteredProducts = allProducts;
      }
    });
  }

  // hàm lọc sản phẩm theo category
  void filterProductByCategory(String category) {
    setState(() {
      selectedCategory = category;
      if (category.isNotEmpty) {
        filteredProducts = allProducts
            .where((product) => product.productCategory == category)
            .toList();
      } else {
        filteredProducts = allProducts;
      }
    });
  }

  // khi Người dùng click vào thanh search thì nó sẽ truyền allProducts qua cho SearchScreen
  // push là nó sẽ đẩy thằng SearchScreen lên đầu tiên trong Stack
  // và nhận lại kết quả khi SearchScreen đóng qua pop
  // sử dụng async và await để khi push nó sẽ đợi SearchScreen đóng và trả về kết quả
  // rồi mới thực hiện tiếp mấy lệnh ở dưới push
  // nếu không dùng thì nó sẽ không chờ mà thay vào đó nó sẽ thực hiện mấy cái còn lại luôn
  void _handleSearchTap() async {
    if (_focusNode.hasFocus) {
      _focusNode.unfocus();
    }
    // final List<Product>? searchResults = await Navigator.of(context)
    //     .push(
    //   CupertinoPageRoute(
    //     builder: (context) => SearchScreen(allproducts: allProducts),
    //   ),
    // )
    //     .then((searchResults) {
    //   if (searchResults != null) {
    //     setState(() {
    //       filteredProducts = searchResults;
    //     });
    //   } else {
    //     setState(() {
    //       filteredProducts = allProducts;
    //     });
    //   }
    // });

    final result = await Navigator.of(context).push(CupertinoPageRoute(
        builder: (context) => SearchScreen(allproducts: allProducts)));
    if (result != null && result is SearchResults) {
      setState(() {
        searchTerm = result.searchTerm;
        filteredProducts = result.searchResults;
      });
    } else if (result == null) {
      setState(() {
        filteredProducts = allProducts;
        searchTerm = '';
      });
    }

    // final List<Product>? searchResults = await Navigator.push(
    //   context,
    //   CupertinoPageRoute(
    //     builder: (context) => SearchScreen(allproducts: allProducts),
    //   ),
    // );
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size; // get screen size
    return AppBarMain(
      leading: Builder(builder: (context) {
        return GestureDetector(
          onTap: () {
            _scaffoldKey.currentState?.openDrawer();
          },
          child: Icon(
            FontAwesomeIcons.bars,
            size: kDefaultIconSize,
            color: ColorPalette.primaryColor,
          ),
        );
      }),
      child: GestureDetector(
        onTap: () {
          if (_focusNode.hasFocus) {
            _focusNode.unfocus();
          }
        },
        child: Scaffold(
          key: _scaffoldKey,
          drawer: Drawer(
            elevation: 0,
            shape:
                const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
            backgroundColor: ColorPalette.backgroundScaffoldColor,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    // logo
                    DrawerHeader(
                        child: ImageHelper.loadFromAsset(
                            AssetHelper.imageLogoFRS)),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25),
                      child: ListTile(
                        leading: Icon(
                          FontAwesomeIcons.house,
                          size: kDefaultIconSize,
                          color: ColorPalette.primaryColor,
                        ),
                        title: Text(
                          'Trang chủ',
                          style: TextStyles.defaultStyle.setTextSize(18),
                        ),
                        onTap: () {
                          Navigator.of(context)
                              .pushNamed(CustomerMain.routeName);
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25),
                      child: ListTile(
                        leading: Icon(
                          FontAwesomeIcons.userShield,
                          size: kDefaultIconSize,
                          color: ColorPalette.primaryColor,
                        ),
                        title: Text(
                          'Chính sách bảo mật',
                          style: TextStyles.defaultStyle.setTextSize(18),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25),
                      child: ListTile(
                        leading: Icon(
                          FontAwesomeIcons.solidAddressBook,
                          size: kDefaultIconSize,
                          color: ColorPalette.primaryColor,
                        ),
                        title: Text(
                          'Điều khoản dịch vụ',
                          style: TextStyles.defaultStyle.setTextSize(18),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25),
                      child: ListTile(
                        leading: Icon(
                          FontAwesomeIcons.users,
                          size: kDefaultIconSize,
                          color: ColorPalette.primaryColor,
                        ),
                        title: Text(
                          'Về chúng tôi',
                          style: TextStyles.defaultStyle.setTextSize(18),
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: ListTile(
                    leading: Icon(
                      FontAwesomeIcons.rightFromBracket,
                      size: kDefaultIconSize,
                      color: ColorPalette.primaryColor,
                    ),
                    title: Text(
                      'Đăng xuất',
                      style: TextStyles.defaultStyle.setTextSize(18),
                    ),
                  ),
                ),
              ],
            ),
          ),
          extendBodyBehindAppBar: true,
          body: SingleChildScrollView(
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // banner
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
                        // Search
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller:
                                    TextEditingController(text: searchTerm),
                                focusNode: _focusNode,
                                onTap: _handleSearchTap,
                                decoration: InputDecoration(
                                  hintText: 'Bạn muốn tìm tên sản phẩm gì?',
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

                        // Text Thương hiệu
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
                                        .where((product) =>
                                            product.productBrand == brand)
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
                                            fontFamily:
                                                FontFamilyRoboto.roboto),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                        SizedBox(height: 10),

                        // category
                        Row(
                          children: [
                            Text(
                              'Loại sản phẩm',
                              style: TextStyles.defaultStyle.bold,
                            ),
                          ],
                        ),
                        SizedBox(height: 10),

                        //brand
                        Container(
                          height: 40,
                          child: ListView.builder(
                            itemCount: categoryList.length,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) {
                              String category = categoryList[index];
                              bool isSelectedCategory =
                                  index == _currentIndexCategory;
                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _currentIndexCategory == index;
                                    filteredProducts = allProducts
                                        .where((product) =>
                                            product.productCategory == category)
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
                                        color: isSelectedCategory
                                            ? ColorPalette.primaryColor
                                            : ColorPalette.hideColor,
                                        borderRadius: BorderRadius.circular(14),
                                      ),

                                      // Text của brand
                                      child: Text(
                                        category,
                                        style: TextStyle(
                                            color: isSelectedCategory
                                                ? Colors.white
                                                : ColorPalette.textColor,
                                            fontWeight: isSelectedCategory
                                                ? FontWeight.bold
                                                : FontWeight.normal,
                                            fontFamily:
                                                FontFamilyRoboto.roboto),
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
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio:
                                (MediaQuery.of(context).size.width - 30 - 15) /
                                    (2 * 260),
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
                                child: ProductCard(
                                    product: filteredProducts[index]),
                              );
                            }
                            return OverflowBox(
                              maxHeight: 260.0 + 70.0,
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
