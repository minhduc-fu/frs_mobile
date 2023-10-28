import 'package:demo_frs_app/models/rental_price_model.dart';

class ProductDetailModel {
  int productID;
  String productName;
  String productReceiptUrl;
  String description;
  double price;
  String status;
  String checkType;
  String categoryID;
  String categoryName;
  int productOwnerID;
  String productOwnerName;
  String productOwnerPhone;
  String productOwnerAvatar;
  Map<String, dynamic> productSpecificationData;
  RentalPriceModel? rentalPrice;

  ProductDetailModel({
    required this.productID,
    required this.productName,
    required this.productReceiptUrl,
    required this.description,
    required this.price,
    required this.status,
    required this.checkType,
    required this.categoryID,
    required this.categoryName,
    required this.productOwnerID,
    required this.productOwnerName,
    required this.productOwnerPhone,
    required this.productOwnerAvatar,
    required this.productSpecificationData,
    this.rentalPrice,
  });

  factory ProductDetailModel.fromJson(Map<String, dynamic> json) {
    return ProductDetailModel(
      productID: json['productID'],
      productName: json['productName'],
      productReceiptUrl: json['productReceiptUrl'],
      description: json['description'],
      price: json['price'],
      status: json['status'],
      checkType: json['checkType'],
      categoryID: json['category']['categoryID'],
      categoryName: json['category']['categoryName'],
      productOwnerID: json['productOwnerID'],
      productOwnerName: json['productOwnerName'],
      productOwnerPhone: json['productOwnerPhone'],
      productOwnerAvatar: json['productOwnerAvatar'],
      productSpecificationData: json['productSpecificationData'],
      rentalPrice: json['productRentalPricesDTO'] != null
          ? RentalPriceModel.fromJson(json['productRentalPricesDTO'])
          : null,
    );
  }
}
