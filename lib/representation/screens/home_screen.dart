import 'package:carousel_slider/carousel_slider.dart';
import 'package:demo_frs_app/core/helper/asset_helper.dart';
import 'package:demo_frs_app/core/helper/image_helper.dart';
import 'package:demo_frs_app/representation/widgets/app_bar_container.dart';
import 'package:flutter/material.dart';

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
  int _currentIndex = 0;

  final List<Widget> _bannerImages = [
    ImageHelper.loadFromAsset(AssetHelper.imageBanner1),
    ImageHelper.loadFromAsset(AssetHelper.imageBanner2),
    ImageHelper.loadFromAsset(AssetHelper.imageBanner3),
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size; // get screen size
    return AppBarContainer(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                child: CarouselSlider.builder(
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
                        _currentIndex = index;
                      });
                    },
                  ),
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
                    return buildIndicator(index == _currentIndex, size);
                  },
                ),
              ),
            ],
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
