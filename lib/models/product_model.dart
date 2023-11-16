import 'dart:convert';
import 'category.dart';
import 'rental_price_model.dart';

class ProductModel {
  int productID;
  String productName;
  String productCondition;
  String? productAvt;
  double price;
  String checkType;
  String status;
  String productOwnerName;
  List<RentalPriceModel?>? rentalPrice;
  Map<String, dynamic>? productSpecifications;
  CategoryModel category;

  ProductModel({
    required this.productID,
    required this.productName,
    required this.productCondition,
    this.productAvt,
    required this.price,
    required this.checkType,
    required this.status,
    required this.productOwnerName,
    this.rentalPrice,
    this.productSpecifications,
    required this.category,
  });

  String getBrandName() {
    switch (category.categoryID) {
      case 1: // Watch
        return productSpecifications?['brandNameWatch'] ?? "N/A";
      case 2: // Hat
        return productSpecifications?['brandNameHat'] ?? "N/A";
      case 3: // Jewelry
        return productSpecifications?['brandNameJewelry'] ?? "N/A";
      case 4: // Bag
        return productSpecifications?['brandNameBag'] ?? "N/A";
      case 5: // Sunglasses
        return productSpecifications?['brandNameGlasses'] ?? "N/A";
      case 6: // Shoe
        return productSpecifications?['brandNameShoe'] ?? "N/A";
      default:
        return "N/A";
    }
  }

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    final List<dynamic>? rentPricesJson = json['rentprices'];
    List<RentalPriceModel> rentalPrices = [];
    if (rentPricesJson != null) {
      rentalPrices = rentPricesJson.map((rentPrice) {
        return RentalPriceModel(
          productRentalPricesID: rentPrice['productRentalPricesID'],
          mockDay: rentPrice['mockDay'],
          rentPrice: rentPrice['rentPrice'].toDouble(),
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
      status: json['status'],
      productOwnerName: json['productOwnerName'],
      rentalPrice: rentalPrices,
      productSpecifications: json['productSpecifications'] != null
          ? jsonDecode(json['productSpecifications'])
          : null,
      category: CategoryModel.fromJson(json['categoryDTO']),
    );
    // jsonDecode thằng productSpecifications vì nó không phải là kiểu dữ liệu Map truyền thống với các key-value
    // mà nó truyền dưới dạng chuỗi JSON
    // cần phải jsonDeconde nó thành object Map trong Dart
  }
}
