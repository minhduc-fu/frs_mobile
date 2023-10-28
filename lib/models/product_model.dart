import 'dart:convert';

import 'package:demo_frs_app/models/rental_price_model.dart';

class ProductModel {
  int productID;
  String productName;
  String? productAvt;
  double price;
  String checkType;
  String productOwnerName;
  RentalPriceModel? rentalPrice;
  Map<String, dynamic>? productSpecifications;

  ProductModel({
    required this.productID,
    required this.productName,
    this.productAvt,
    required this.price,
    required this.checkType,
    required this.productOwnerName,
    this.rentalPrice,
    this.productSpecifications,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      productID: json['productID'],
      productName: json['productName'],
      productAvt: json['productAvt'],
      price: json['price'],
      checkType: json['checkType'],
      productOwnerName: json['productOwnerName'],
      rentalPrice: json['productRentalPricesDTO'] != null
          ? RentalPriceModel.fromJson(json['productRentalPricesDTO'])
          : null,
      productSpecifications: json['productSpecifications'] != null
          ? jsonDecode(json['productSpecifications'])
          : null,
    );
    // jsonDecode thằng productSpecifications vì nó không phải là kiểu dữ liệu Map truyền thống với các key-value
    // mà nó truyền dưới dạng chuỗi JSON
    // cần phải jsonDeconde nó thành object Map trong Dart
  }
}
