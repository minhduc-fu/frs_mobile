import 'dart:convert';
import 'rental_price_model.dart';

class ProductModel {
  int productID;
  String productName;
  String productCondition;
  String? productAvt;
  double price;
  String checkType;
  String productOwnerName;
  List<RentalPriceModel?>? rentalPrice;
  Map<String, dynamic>? productSpecifications;

  ProductModel({
    required this.productID,
    required this.productName,
    required this.productCondition,
    this.productAvt,
    required this.price,
    required this.checkType,
    required this.productOwnerName,
    this.rentalPrice,
    this.productSpecifications,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    final List<dynamic>? rentPricesJson = json['rentprices'];
    List<RentalPriceModel> rentalPrices = [];
    if (rentPricesJson != null) {
      rentalPrices = rentPricesJson.map((rentPrice) {
        return RentalPriceModel(
          productRentalPricesID: rentPrice['productRentalPricesID'],
          mockDay: rentPrice['mockDay'],
          rentPrice: rentPrice['rentPrice'],
        );
      }).toList();
    }
    return ProductModel(
      productID: json['productID'],
      productName: json['productName'],
      productCondition: json['productCondition'],
      productAvt: json['productAvt'],
      price: json['price'],
      checkType: json['checkType'],
      productOwnerName: json['productOwnerName'],
      rentalPrice: rentalPrices,
      productSpecifications: json['productSpecifications'] != null
          ? jsonDecode(json['productSpecifications'])
          : null,
    );
    // jsonDecode thằng productSpecifications vì nó không phải là kiểu dữ liệu Map truyền thống với các key-value
    // mà nó truyền dưới dạng chuỗi JSON
    // cần phải jsonDeconde nó thành object Map trong Dart
  }
}
