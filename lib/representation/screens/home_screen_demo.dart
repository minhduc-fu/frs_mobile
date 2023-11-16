import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:frs_mobile/models/category.dart';
import 'package:frs_mobile/models/product_detail_model.dart';
import 'package:frs_mobile/models/product_image_model.dart';
import 'package:frs_mobile/representation/screens/product_detail/product_detail_demo.dart';

import '../../core/constants/color_constants.dart';
import '../../core/constants/dismension_constants.dart';
import '../../core/constants/textstyle_constants.dart';
import '../../models/productOwner_model.dart';
import '../../models/product_model.dart';
import '../../services/authentication_service.dart';
import '../../utils/asset_helper.dart';
import '../../utils/image_helper.dart';
import '../widgets/app_bar_main.dart';
import '../widgets/indicator_widget.dart';
import '../widgets/product_cart_demo.dart';

class HomeScreenDemo extends StatefulWidget {
  const HomeScreenDemo({
    super.key,
  });

  static const String routeName = '/home_screen_demo';

  @override
  State<HomeScreenDemo> createState() => _HomeScreenDemoState();
}

class _HomeScreenDemoState extends State<HomeScreenDemo> {
  List<CategoryModel> categories = [];
  CategoryModel? selectedCategory;
  int selectedAllProduct = 0;
//   0 All
// 1 categoryName
// 2 onAvailable
// 3 onSoldOut
// 4 onRent
// 5 onSale
  Future<List<ProductModel>?> fetchProducts() async {
    switch (selectedAllProduct) {
      case 0:
        return await AuthenticationService.getAllProduct();
      case 1:
        if (selectedCategory != null)
          return await AuthenticationService.getAllProductByCategoryName(
              selectedCategory!.categoryName);
      case 2:
        return await AuthenticationService.getAllProductOnAvailable();
      case 3:
        return await AuthenticationService.getAllProductOnSoldOut();
      case 4:
        return await AuthenticationService.getAllProductOnRent();
      case 5:
        return await AuthenticationService.getAllProductOnSale();
    }
  }

  Future<void> _loadCategories() async {
    try {
      List<CategoryModel>? fetchedCategories =
          await AuthenticationService.getAllCategory();
      setState(() {
        if (fetchedCategories != null) {
          categories = fetchedCategories;
        }
      });
    } catch (e) {
      print('Error loading categories: $e');
    }
  }

  String searchTerm = '';
  final CarouselController _controller = CarouselController();
  int _currentIndexBanner = 0;
  final List<Widget> _bannerImages = [
    ImageHelper.loadFromAsset(AssetHelper.imageBanner1, fit: BoxFit.cover),
    ImageHelper.loadFromAsset(AssetHelper.imageBanner2, fit: BoxFit.cover),
    ImageHelper.loadFromAsset(AssetHelper.imageBanner3, fit: BoxFit.cover),
  ];

  String selectedBrand = ""; // Không có thương hiệu nào được chọn ban đầu
  FocusNode _focusNode = FocusNode();
  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _loadCategories();
    selectedAllProduct = 0;
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

  void _openshowModalBottomSheet() {
    showModalBottomSheet(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(kDefaultCircle14)),
        backgroundColor: ColorPalette.backgroundScaffoldColor,
        context: context,
        builder: (BuildContext context) {
          return Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Text(
                            'Loại sản phẩm',
                            style: TextStyles.h5.bold,
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Container(
                        height: 40,
                        child: ListView.builder(
                          itemCount: categories.length,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            final category = categories[index];
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    Navigator.pop(context);
                                    setState(() {
                                      selectedCategory = category;
                                      selectedAllProduct = 1;
                                    });
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 5),
                                    margin: EdgeInsets.only(right: 10),
                                    decoration: BoxDecoration(
                                      color: ColorPalette.primaryColor,
                                      borderRadius: BorderRadius.circular(
                                          kDefaultCircle14),
                                    ),
                                    child: Text(
                                      category.categoryName,
                                      style: TextStyles
                                          .defaultStyle.whiteTextColor,
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Text(
                            'Khác',
                            style: TextStyles.h5.bold,
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedAllProduct = 0;
                              });
                              Navigator.pop(context);
                            },
                            child: Container(
                              margin: EdgeInsets.only(right: 10),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              decoration: BoxDecoration(
                                  color: ColorPalette.primaryColor,
                                  borderRadius:
                                      BorderRadius.circular(kDefaultCircle14)),
                              child: Text(
                                'Tất cả sản phẩm',
                                style: TextStyles.defaultStyle.whiteTextColor,
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedAllProduct = 2;
                              });
                              Navigator.pop(context);
                            },
                            child: Container(
                              margin: EdgeInsets.only(right: 10),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              decoration: BoxDecoration(
                                  color: ColorPalette.primaryColor,
                                  borderRadius:
                                      BorderRadius.circular(kDefaultCircle14)),
                              child: Text(
                                'Có sẵn',
                                style: TextStyles.defaultStyle.whiteTextColor,
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedAllProduct = 3;
                              });
                              Navigator.pop(context);
                            },
                            child: Container(
                              margin: EdgeInsets.only(right: 10),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              decoration: BoxDecoration(
                                  color: ColorPalette.primaryColor,
                                  borderRadius:
                                      BorderRadius.circular(kDefaultCircle14)),
                              child: Text(
                                'Hết hàng',
                                style: TextStyles.defaultStyle.whiteTextColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedAllProduct = 4;
                              });
                              Navigator.pop(context);
                            },
                            child: Container(
                              margin: EdgeInsets.only(right: 10),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              decoration: BoxDecoration(
                                  color: ColorPalette.primaryColor,
                                  borderRadius:
                                      BorderRadius.circular(kDefaultCircle14)),
                              child: Text(
                                'Thuê',
                                style: TextStyles.defaultStyle.whiteTextColor,
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedAllProduct = 5;
                              });
                              Navigator.pop(context);
                            },
                            child: Container(
                              margin: EdgeInsets.only(right: 10),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              decoration: BoxDecoration(
                                  color: ColorPalette.primaryColor,
                                  borderRadius:
                                      BorderRadius.circular(kDefaultCircle14)),
                              child: Text(
                                'Mua',
                                style: TextStyles.defaultStyle.whiteTextColor,
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          );
        });
  }

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
                        onTap: _openshowModalBottomSheet,
                        child: Icon(
                          FontAwesomeIcons.sliders,
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
                      return Container(
                        margin: EdgeInsets.all(5.0),
                        child: ClipRRect(
                            borderRadius: BorderRadius.all(
                                Radius.circular(kDefaultCircle14)),
                            child: Stack(
                              children: <Widget>[
                                _bannerImages[index],
                                // Image.network(product, fit: BoxFit.cover, width: 1000.0),
                                Positioned(
                                  bottom: 0.0,
                                  left: 0.0,
                                  right: 0.0,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          Color.fromARGB(200, 0, 0, 0),
                                          Color.fromARGB(0, 0, 0, 0)
                                        ],
                                        begin: Alignment.bottomCenter,
                                        end: Alignment.topCenter,
                                      ),
                                    ),
                                    padding: EdgeInsets.symmetric(
                                        vertical: 10.0, horizontal: 20.0),
                                    child: Text(
                                      'No. ${index} image',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            )),
                      );
                    },
                    options: CarouselOptions(
                      autoPlayInterval: Duration(
                          seconds: 3), // xác định thời gian mỗi lần tự động
                      autoPlayCurve: Curves.fastOutSlowIn,
                      // autoPlay: true,
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
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Text(
                        'Sản phẩm',
                        style: TextStyles.h5.bold,
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
                            mainAxisExtent: 280,
                            // tỷ lệ giữa chiều rộng và chiều cao
                            // childAspectRatio: 1 / 2,
                            // (MediaQuery.of(context).size.width - 20 - 10) /
                            //     (2 * 260),
                            mainAxisSpacing: 20,
                            crossAxisSpacing: 10,
                          ),
                          shrinkWrap: true,
                          itemCount: products.length,
                          itemBuilder: ((context, index) {
                            // double aspectRatio = index.isEven ? 1.5 : 1.0;
                            // return ProductCardDemo(
                            //   product: products[index],
                            //   aspectRatio: aspectRatio,
                            // );

                            return Transform.translate(
                              offset: Offset(0, index.isOdd ? 50.0 : 0.0),
                              child: GestureDetector(
                                onTap: () async {
                                  ProductDetailModel? productDetail =
                                      await AuthenticationService
                                          .getProductByID(
                                              products[index].productID);
                                  int productOwnerID =
                                      productDetail!.productOwnerID;
                                  ProductOwnerModel? productOwnerModel =
                                      await AuthenticationService
                                          .getProductOwnerByID(productOwnerID);

                                  List<ProductImageModel>? productImages =
                                      await AuthenticationService
                                          .getAllProductImgByProductID(
                                              products[index].productID);

                                  Navigator.of(context).push(
                                    CupertinoPageRoute(
                                      builder: (context) => ProductDetailDemo(
                                        productImageModel: productImages!,
                                        productOwnerModel: productOwnerModel,
                                        productDetailModel: productDetail,
                                      ),
                                    ),
                                  );
                                  print(products[index].productID);
                                },
                                child: ProductCardDemo(
                                  product: products[index],
                                  // aspectRatio: aspectRatio,
                                ),
                              ),
                            );
                            // double aspectRatio = index.isEven ? 1.5 : 1.0;
                            // if (index % 2 == 0) {
                            //   return GestureDetector(
                            //     onTap: () {},
                            //     child: ProductCardDemo(
                            //       aspectRatio: aspectRatio,
                            //       product: products[index],
                            //     ),
                            //   );
                            // }
                            // return OverflowBox(
                            //   // maxHeight: 260.0 + 70,
                            //   maxHeight: 400,
                            //   child: GestureDetector(
                            //     onTap: () {},
                            //     child: Container(
                            //       margin: EdgeInsets.only(top: 70),
                            //       child: ProductCardDemo(
                            //         aspectRatio: aspectRatio,
                            //         product: products[index],
                            //       ),
                            //     ),
                            //   ),
                            // );
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
