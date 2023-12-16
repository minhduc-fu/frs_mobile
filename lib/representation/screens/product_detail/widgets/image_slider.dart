import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../../../../core/constants/dismension_constants.dart';
import '../../../../core/constants/textstyle_constants.dart';
import '../../../../models/product_image_model.dart';
import '../full_screen_list_image.dart';

class ImageSlider extends StatelessWidget {
  final List<ProductImageModel> productImages;
  final int currentImage;
  final Function(int) onPageChanged;
  final CarouselController carouselController;

  ImageSlider({
    required this.productImages,
    required this.currentImage,
    required this.onPageChanged,
    required this.carouselController,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          CupertinoPageRoute(
            builder: (context) => FullScreenImage(
              productImageModel: productImages,
              initialIndex: currentImage,
            ),
          ),
        );
      },
      child: CarouselSlider.builder(
        carouselController: carouselController,
        itemCount: productImages.length,
        itemBuilder: (BuildContext context, int index, int realIndex) {
          return Container(
            margin: EdgeInsets.all(5.0),
            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(kDefaultCircle14)),
              child: Stack(
                children: <Widget>[
                  Image.network(
                    productImages[index].imgUrl,
                    fit: BoxFit.cover,
                    width: 1000.0,
                  ),
                  Positioned(
                    // top: 0.0,
                    // bottom: 0.0,
                    left: 0.0,
                    right: 0.0,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Color.fromARGB(200, 0, 0, 0),
                            Color.fromARGB(0, 0, 0, 0),
                          ],
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                        ),
                      ),
                      padding: EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 20.0),
                      child: Text(
                        'No. ${index + 1} image',
                        style: TextStyles.defaultStyle
                            .setTextSize(20)
                            .bold
                            .setColor(Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
        options: CarouselOptions(
          autoPlay: false,
          enlargeCenterPage: true, // phóng to trung tâm trang
          aspectRatio: 16 / 9,
          onPageChanged: (index, _) {
            onPageChanged(index);
          },
        ),
      ),
    );
  }
}
