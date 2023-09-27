import 'dart:async';

import 'package:demo_frs_app/core/constants/dismension_constants.dart';
import 'package:demo_frs_app/core/constants/textstyle_constants.dart';
import 'package:demo_frs_app/core/helper/asset_helper.dart';
import 'package:demo_frs_app/core/helper/image_helper.dart';
import 'package:demo_frs_app/representation/screens/login_or_register/auth_screen.dart';

import 'package:demo_frs_app/representation/widgets/button_widget.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({super.key});

  static const String routeName = 'intro_screen';

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  final StreamController<int> _pageStreamController =
      StreamController<int>.broadcast();
  final PageController _pageController = PageController();
  @override
  void initState() {
    super.initState();
    // PageController là 1 dạng stream.
    // Mỗi khi người dùng lướt sang page khác, thêm thằng _pageController vào addListener. output 0 đến 1 đến 2
    _pageController.addListener(() {
      // khi mà nó chuyển sang 1 page khác rồi thì add nó vào luồng stream = giá trị của nó
      _pageStreamController.add(_pageController.page!.toInt());
    });
  }

  Widget _buildItemIntroScreen(
      String image, String title, String description, Alignment alignment) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Image
        Container(
          alignment: alignment,
          child: ImageHelper.loadFromAsset(image,
              height: 400, fit: BoxFit.fitHeight),
        ),
        SizedBox(
          height: kMediumPadding * 2,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: kMediumPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // title
              Text(
                title,
                style: TextStyles.defaultStyle.bold,
              ),
              SizedBox(
                height: kMediumPadding,
              ),

              // description
              Text(
                description,
                style: TextStyles.defaultStyle,
              )
            ],
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: _pageController,
            children: [
              _buildItemIntroScreen(AssetHelper.imageIntro1, 'title',
                  'description', Alignment.centerRight),
              _buildItemIntroScreen(AssetHelper.imageIntro1, 'title',
                  'description', Alignment.center),
              _buildItemIntroScreen(AssetHelper.imageIntro1, 'title',
                  'description', Alignment.centerLeft),
            ],
          ),
          Positioned(
            child: Row(
              children: [
                Expanded(
                  flex: 6,
                  child: SmoothPageIndicator(
                    controller: _pageController,
                    count: 3,
                    effect: ExpandingDotsEffect(
                        dotWidth: kMinPadding,
                        dotHeight: kMinPadding,
                        activeDotColor: Colors.black),
                  ),
                ),
                StreamBuilder<int>(
                  initialData: 0,
                  stream: _pageStreamController.stream,
                  builder: (context, snapshot) {
                    return Expanded(
                      flex: 4,
                      child: ButtonWidget(
                        onTap: () {
                          if (_pageController.page != 2) {
                            _pageController.nextPage(
                                duration: Duration(milliseconds: 100),
                                curve: Curves.easeIn);
                          } else {
                            Navigator.of(context)
                                .pushNamed(AuthScreen.routeName);
                          }
                        },
                        height: 40,
                        title: snapshot.data != 2 ? 'Next' : ' Get started',
                        size: 18,
                      ),
                    );
                  },
                )
              ],
            ),
            left: kMediumPadding,
            right: kMediumPadding,
            bottom: kMediumPadding * 3,
          )
        ],
      ),
    );
  }
}
