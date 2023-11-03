import 'dart:convert';

import 'category.dart';
import 'rental_price_model.dart';

class ProductDetailModel {
  int productID;
  String productName;
  String productReceiptUrl;
  String? productAvt;
  String productCondition;
  String description;
  double price;
  String status;
  String checkType;
  CategoryModel category;
  int productOwnerID;
  Map<String, dynamic>? productSpecificationData;
  List<RentalPriceModel?>? rentalPrices;
  bool isChecked;

  ProductDetailModel({
    required this.productID,
    required this.productName,
    required this.productReceiptUrl,
    this.productAvt,
    required this.productCondition,
    required this.description,
    required this.price,
    required this.status,
    required this.checkType,
    required this.category,
    required this.productOwnerID,
    this.productSpecificationData,
    required this.rentalPrices,
    this.isChecked = false,
  });

  factory ProductDetailModel.fromJson(Map<String, dynamic> json) {
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
    return ProductDetailModel(
      productID: json['productID'],
      productName: json['productName'],
      productReceiptUrl: json['productReceiptUrl'],
      productAvt: json['productAvt'],
      productCondition: json['productCondition'],
      description: json['description'],
      price: json['price'].toDouble(),
      status: json['status'],
      checkType: json['checkType'],
      category: CategoryModel.fromJson(json['category']),
      productOwnerID: json['productOwnerID'],
      productSpecificationData: json['productSpecificationData'] != null
          ? jsonDecode(json['productSpecificationData'])
          : null,
      rentalPrices: rentalPrices,
    );
  }
}
// class ProductDetailModel {
//   int productID;
//   String productName;
//   String productReceiptUrl;
//   String? productAvt;
//   String productCondition;
//   String description;
//   double price;
//   String status;
//   String checkType;
//   CategoryModel category;
//   int productOwnerID;
//   Map<String, dynamic>? productSpecificationData;
//   RentalPriceModel? rentalPrice;

//   ProductDetailModel({
//     required this.productID,
//     required this.productName,
//     required this.productReceiptUrl,
//     this.productAvt,
//     required this.productCondition,
//     required this.description,
//     required this.price,
//     required this.status,
//     required this.checkType,
//     required this.category,
//     required this.productOwnerID,
//     this.productSpecificationData,
//     this.rentalPrice,
//   });

//   factory ProductDetailModel.fromJson(Map<String, dynamic> json) {
//     return ProductDetailModel(
//       productID: json['productID'],
//       productName: json['productName'],
//       productReceiptUrl: json['productReceiptUrl'],
//       productAvt: json['productAvt'],
//       productCondition: json['productCondition'],
//       description: json['description'],
//       price: json['price'].toDouble(),
//       status: json['status'],
//       checkType: json['checkType'],
//       category: CategoryModel.fromJson(json['category']),
//       productOwnerID: json['productOwnerID'],
//       productSpecificationData: json['productSpecificationData'] != null
//           ? jsonDecode(json['productSpecificationData'])
//           : null,
//       rentalPrice: json['productRentalPricesDTO'] != null
//           ? RentalPriceModel.fromJson(json['productRentalPricesDTO'])
//           : null,
//     );
//   }
// }
