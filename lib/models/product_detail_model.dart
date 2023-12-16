import 'dart:convert';
import 'package:frs_mobile/models/detail_item.dart';
import 'category.dart';
import 'rental_price_model.dart';

class ProductDetailModel {
  int productID;
  String productName;
  String productReceiptUrl;
  String? productAvt;
  String productCondition;
  String description;
  String term;
  String? serialNumber;
  double price;
  String status;
  String checkType;
  CategoryModel? category;
  int productOwnerID;
  Map<String, dynamic>? productSpecificationData;
  List<RentalPriceModel?>? rentalPrices;
  bool isChecked;
  DateTime? startDate;
  DateTime? endDate;
  double? selectedRentPrice;
  List<DetailItem>? details;

  ProductDetailModel({
    required this.productID,
    required this.productName,
    required this.productReceiptUrl,
    this.productAvt,
    required this.productCondition,
    required this.description,
    required this.term,
    this.serialNumber,
    required this.price,
    required this.status,
    required this.checkType,
    this.category,
    required this.productOwnerID,
    this.productSpecificationData,
    required this.rentalPrices,
    this.isChecked = false,
    this.endDate,
    this.startDate,
    this.selectedRentPrice,
    this.details,
  });
  String getBrandName() {
    switch (category!.categoryID) {
      case 1: // Watch
        return productSpecificationData?['brandNameWatch'] ?? "N/A";
      case 2: // Hat
        return productSpecificationData?['brandNameHat'] ?? "N/A";
      case 3: // Jewelry
        return productSpecificationData?['brandNameJewelry'] ?? "N/A";
      case 4: // Bag
        return productSpecificationData?['brandNameBag'] ?? "N/A";
      case 5: // Sunglasses
        return productSpecificationData?['brandNameGlasses'] ?? "N/A";
      case 6: // Shoe
        return productSpecificationData?['brandNameShoe'] ?? "N/A";
      default:
        return "N/A";
    }
  }

  String getMadeOf() {
    switch (category!.categoryID) {
      case 1: // Watch
        return productSpecificationData?['strapMaterialWatch'] ?? "N/A";
      case 2: // Hat
        return productSpecificationData?['materialHat'] ?? "N/A";
      case 3: // Jewelry
        return productSpecificationData?['occasion'] ?? "N/A";
      case 4: // Bag
        return productSpecificationData?['typeSkinBag'] ?? "N/A";
      case 5: // Sunglasses
        return productSpecificationData?['glassMaterial'] ?? "N/A";
      case 6: // Shoe
        return productSpecificationData?['typeSkinShoe'] ?? "N/A";
      default:
        return "N/A";
    }
  }

  String getOrigin() {
    switch (category!.categoryID) {
      case 1: // Watch
        return productSpecificationData?['originWatch'] ?? "N/A";
      case 2: // Hat
        return productSpecificationData?['originHat'] ?? "N/A";
      case 3: // Jewelry
        return productSpecificationData?['originJewelry'] ?? "N/A";
      case 4: // Bag
        return productSpecificationData?['originBag'] ?? "N/A";
      case 5: // Sunglasses
        return productSpecificationData?['glassShape'] ?? "N/A";
      case 6: // Shoe
        return productSpecificationData?['originShoe'] ?? "N/A";
      default:
        return "N/A";
    }
  }

  String getType() {
    switch (category!.categoryID) {
      case 1: // Watch
        return productSpecificationData?['clockFaceWatch'] ?? "N/A";
      case 2: // Hat
        return productSpecificationData?['typeHat'] ?? "N/A";
      case 3: // Jewelry
        return productSpecificationData?['typeJewelrys'] ?? "N/A";
      case 4: // Bag
        return productSpecificationData?['skinTexture'] ?? "N/A";
      case 5: // Sunglasses
        return productSpecificationData?['typeLensGlasses'] ?? "N/A";
      case 6: // Shoe
        return productSpecificationData?['outsideSkin'] ?? "N/A";
      default:
        return "N/A";
    }
  }

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

    final List<dynamic>? detailsJson = json['details'];
    List<DetailItem> productDetails = [];
    if (detailsJson != null) {
      productDetails = detailsJson.map((detail) {
        return DetailItem(
          productDetailID: detail['productDetailID'],
          detailName: detail['detailName'],
          value: detail['value'],
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
      term: json['term'] != null ? json['term'] : '',
      serialNumber: json['serialNumber'],
      price: json['price'].toDouble(),
      status: json['status'],
      checkType: json['checkType'],
      category: CategoryModel.fromJson(json['category']),
      productOwnerID: json['productOwnerID'],
      productSpecificationData: json['productSpecificationData'] != null
          ? jsonDecode(json['productSpecificationData'])
          : null,
      rentalPrices: rentalPrices,
      startDate: null,
      endDate: null,
      details: productDetails,
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
