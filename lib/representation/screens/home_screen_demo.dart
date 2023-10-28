import 'package:carousel_slider/carousel_slider.dart';
import 'package:demo_frs_app/core/constants/color_constants.dart';
import 'package:demo_frs_app/core/constants/dismension_constants.dart';
import 'package:demo_frs_app/core/constants/textstyle_constants.dart';
import 'package:demo_frs_app/models/product_model.dart';
import 'package:demo_frs_app/representation/widgets/app_bar_main.dart';
import 'package:demo_frs_app/representation/widgets/indicator_widget.dart';
import 'package:demo_frs_app/representation/widgets/product_cart_demo.dart';
import 'package:demo_frs_app/services/authentication_service.dart';
import 'package:demo_frs_app/utils/asset_helper.dart';
import 'package:demo_frs_app/utils/image_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HomeScreenDemo extends StatefulWidget {
  const HomeScreenDemo({
    super.key,
  });

  static const String routeName = '/home_screen_demo';

  @override
  State<HomeScreenDemo> createState() => _HomeScreenDemoState();
}

class _HomeScreenDemoState extends State<HomeScreenDemo> {
  Future<List<ProductModel>?> fetchProducts() async {
    return AuthenticationService.getAllProduct();
  }

  int _currentIndexCategory = 0;
  int _currentIndexBrand = 0;
  String searchTerm = '';
  final CarouselController _controller = CarouselController();
  int _currentIndexBanner = 0;
  final List<Widget> _bannerImages = [
    ImageHelper.loadFromAsset(AssetHelper.imageBanner1),
    ImageHelper.loadFromAsset(AssetHelper.imageBanner2),
    ImageHelper.loadFromAsset(AssetHelper.imageBanner3),
  ];
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

  String selectedBrand = ""; // Không có thương hiệu nào được chọn ban đầu
  String selectedCategory = ""; // Không có thương hiệu nào được chọn ban đầu
  FocusNode _focusNode = FocusNode();
  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  // khi Người dùng click vào thanh search thì nó sẽ truyền allProducts qua cho SearchScreen
  // push là nó sẽ đẩy thằng SearchScreen lên đầu tiên trong Stack
  // và nhận lại kết quả khi SearchScreen đóng qua pop
  // sử dụng async và await để khi push nó sẽ đợi SearchScreen đóng và trả về kết quả
  // rồi mới thực hiện tiếp mấy lệnh ở dưới push
  // nếu không dùng thì nó sẽ không chờ mà thay vào đó nó sẽ thực hiện mấy cái còn lại luôn
  // void _handleSearchTap() async {
  //   if (_focusNode.hasFocus) {
  //     _focusNode.unfocus();
  //   }
  //   final result = await Navigator.of(context).push(CupertinoPageRoute(
  //       builder: (context) => SearchScreen(allproducts: allProducts)));
  //   if (result != null && result is SearchResults) {
  //     setState(() {
  //       searchTerm = result.searchTerm;
  //       filteredProducts = result.searchResults;
  //     });
  //   } else if (result == null) {
  //     setState(() {
  //       filteredProducts = allProducts;
  //       searchTerm = '';
  //     });
  //   }
  // }

  final GlobalKey<ScaffoldState> _scaffoldKey =
      GlobalKey<ScaffoldState>(); // để gọi Drawer

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return AppBarMain(
      leading: Builder(builder: (context) {
        return GestureDetector(
          onTap: () {
            _scaffoldKey.currentState?.openDrawer();
          },
          child: Icon(
            FontAwesomeIcons.bars,
            size: kDefaultIconSize18,
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
                          size: kDefaultIconSize18,
                          color: ColorPalette.primaryColor,
                        ),
                        title: Text(
                          'Trang chủ',
                          style: TextStyles.defaultStyle.setTextSize(18),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25),
                      child: ListTile(
                        leading: Icon(
                          FontAwesomeIcons.userShield,
                          size: kDefaultIconSize18,
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
                          size: kDefaultIconSize18,
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
                          size: kDefaultIconSize18,
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
                      size: kDefaultIconSize18,
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
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  //search
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: TextEditingController(text: searchTerm),
                          focusNode: _focusNode,
                          // onTap: _handleSearchTap,
                          onTap: () {},
                          decoration: InputDecoration(
                            hintText: 'Bạn muốn tìm tên sản phẩm gì?',
                            hintStyle: TextStyles.defaultStyle,
                            prefixIcon: Padding(
                              padding: EdgeInsets.all(kTopPadding8),
                              child: Icon(
                                FontAwesomeIcons.magnifyingGlass,
                                color: ColorPalette.primaryColor,
                                size: kDefaultIconSize18,
                              ),
                            ),
                            filled: true,
                            fillColor: ColorPalette.hideColor,
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: ColorPalette.primaryColor),
                              borderRadius:
                                  BorderRadius.circular(kDefaultCircle14),
                            ),
                            border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius:
                                  BorderRadius.circular(kDefaultCircle14),
                            ),
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: kItemPadding10),
                          ),
                        ),
                      ),
                      SizedBox(width: 10),

                      // filter category
                      GestureDetector(
                        child: Icon(
                          FontAwesomeIcons.sliders,
                          size: kDefaultIconSize18,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),

                  CarouselSlider.builder(
                    carouselController: _controller,
                    itemCount: _bannerImages.length,
                    itemBuilder:
                        (BuildContext context, int index, int realIndex) {
                      return _bannerImages[index];
                    },
                    options: CarouselOptions(
                      autoPlay: false,
                      enlargeCenterPage: true, // phóng to trung tâm trang
                      // height: 200,
                      aspectRatio: 16 / 9,
                      onPageChanged: (index, reason) {
                        setState(() {
                          _currentIndexBanner = index;
                        });
                      },
                    ),
                  ),
                  Container(
                    height: 8,
                    // margin: EdgeInsets.symmetric(vertical: 13, horizontal: 30), //
                    child: ListView.builder(
                      // nằm giữa hay không là nó nằm ở shrinWrap này nè
                      shrinkWrap:
                          true, // Cho phép ListView.builder co lại theo nội dung
                      itemCount: _bannerImages.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        return buildIndicator(
                            index == _currentIndexBanner, size);
                      },
                    ),
                  ),
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
                  Container(
                    height: 40,
                    child: ListView.builder(
                      itemCount: brandList.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        String brand = brandList[index];
                        bool isSelected = index == _currentIndexBrand;
                        return GestureDetector(
                          onTap: () {},
                          // cục hiển thị cho các brand
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 5),
                                margin: EdgeInsets.only(right: 10),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? ColorPalette.primaryColor
                                      : ColorPalette.hideColor,
                                  borderRadius:
                                      BorderRadius.circular(kDefaultCircle14),
                                ),

                                // Text của brand
                                child: Text(
                                  brand,
                                  style: TextStyle(
                                      color: isSelected
                                          ? Colors.white
                                          : ColorPalette.textHide,
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
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Text(
                        'Loại sản phẩm',
                        style: TextStyles.defaultStyle.bold,
                      ),
                    ],
                  ),
                  SizedBox(height: 10),

                  //category
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
                          onTap: () {},

                          // cục hiển thị cho các brand
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 5),
                                margin: EdgeInsets.only(right: 10),
                                decoration: BoxDecoration(
                                  color: isSelectedCategory
                                      ? ColorPalette.primaryColor
                                      : ColorPalette.hideColor,
                                  borderRadius:
                                      BorderRadius.circular(kDefaultCircle14),
                                ),

                                // Text của brand
                                child: Text(
                                  category,
                                  style: TextStyle(
                                      color: isSelectedCategory
                                          ? Colors.white
                                          : ColorPalette.textHide,
                                      fontWeight: isSelectedCategory
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
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Text(
                        'Tất cả sản phẩm',
                        style: TextStyles.defaultStyle.bold,
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  FutureBuilder<List<ProductModel>?>(
                    future: fetchProducts(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return Text('Lỗi: ${snapshot.error}');
                      } else if (snapshot.hasData) {
                        List<ProductModel> products = snapshot.data ?? [];
                        return GridView.builder(
                          physics: ScrollPhysics(),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio:
                                (MediaQuery.of(context).size.width - 30 - 15) /
                                    (2 * 260),
                            mainAxisSpacing: 20,
                            crossAxisSpacing: 10,
                          ),
                          shrinkWrap: true,
                          itemCount: products.length,
                          itemBuilder: ((context, index) {
                            if (index % 2 == 0) {
                              return GestureDetector(
                                onTap: () {
                                  // selectedProduct = filteredProducts[index];
                                },
                                child: ProductCardDemo(
                                  product: products[index],
                                ),
                              );
                            }
                            return OverflowBox(
                              maxHeight: 260.0 + 70.0,
                              child: GestureDetector(
                                onTap: () {},
                                child: Container(
                                  margin: EdgeInsets.only(top: 70),
                                  child: ProductCardDemo(
                                    product: products[index],
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
