import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:photo_view/photo_view.dart';

import '../../../core/constants/dismension_constants.dart';

class FullScreenReceipt extends StatelessWidget {
  final String productReceiptUrl;
  const FullScreenReceipt({super.key, required this.productReceiptUrl});

  @override
  Widget build(BuildContext context) {
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
      body: Container(
        child: PhotoView(
          imageProvider: NetworkImage(productReceiptUrl),
          minScale: PhotoViewComputedScale.contained,
          maxScale: PhotoViewComputedScale.covered,
          initialScale: PhotoViewComputedScale.contained * 0.8,
        ),
      ),
    );
  }
}
