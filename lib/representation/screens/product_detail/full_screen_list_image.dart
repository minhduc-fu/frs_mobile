import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:frs_mobile/models/product_image_model.dart';
import 'package:photo_view/photo_view.dart';
import '../../../core/constants/color_constants.dart';
import '../../../core/constants/dismension_constants.dart';

class FullScreenImage extends StatefulWidget {
  final List<ProductImageModel> productImageModel;
  final int initialIndex;
  const FullScreenImage(
      {super.key, required this.productImageModel, required this.initialIndex});

  @override
  State<FullScreenImage> createState() => _FullScreenImageState();
}

class _FullScreenImageState extends State<FullScreenImage> {
  int _currentIndex = 0;
  PageController? _pageController;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: widget.initialIndex);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Container(
            color: Colors.black,
            child: Icon(
              color: Colors.white,
              FontAwesomeIcons.angleLeft,
              size: kDefaultIconSize18,
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              itemCount: widget.productImageModel.length,
              itemBuilder: (context, index) {
                return PhotoView(
                  imageProvider:
                      NetworkImage(widget.productImageModel[index].imgUrl),
                  minScale: PhotoViewComputedScale.contained,
                  maxScale: PhotoViewComputedScale.covered,
                  initialScale: PhotoViewComputedScale.contained * 0.8,
                );
              },
              onPageChanged: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
            ),
          ),
          Center(
            child: Container(
              height: 8,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: widget.productImageModel.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return buildIndicatorFullScreen(index == _currentIndex, size);
                },
              ),
            ),
          ),
          SizedBox(height: 10)
        ],
      ),
    );
  }
}

Widget buildIndicatorFullScreen(bool isActive, Size size) {
  return AnimatedContainer(
    duration: Duration(milliseconds: 300),
    curve: Curves.bounceInOut,
    margin: EdgeInsets.symmetric(horizontal: 10), // cách từng cục item
    width: isActive ? 20 : 10,
    decoration: BoxDecoration(
      color: isActive ? Colors.white : ColorPalette.textHide,
      borderRadius: BorderRadius.circular(5),
    ),
  );
}
