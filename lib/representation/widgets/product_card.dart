import 'package:demo_frs_app/core/constants/color_constants.dart';
import 'package:demo_frs_app/core/helper/image_helper.dart';
import 'package:demo_frs_app/models/product.dart';
import 'package:flutter/material.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: Container(
        color: Colors.amber,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 16 / 9,
              child: ImageHelper.loadFromAsset(product.imagePath,
                  fit: BoxFit.cover),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(product.name),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(product.brand),
            ),
            Row(
              children: [
                Text(product.price),
                Text(product.rating),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
