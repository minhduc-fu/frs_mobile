import 'package:frs_mobile/models/rental_price_model.dart';

class ProductDTOModel {
  int productID;
  String productName;
  String productAvt;
  double price;
  List<RentalPriceModel?>? rentalPrices;

  ProductDTOModel({
    required this.productID,
    required this.productName,
    required this.productAvt,
    required this.price,
    this.rentalPrices,
  });

  factory ProductDTOModel.fromJson(Map<String, dynamic> json) {
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
    return ProductDTOModel(
      productID: json['productID'],
      productName: json['productName'],
      productAvt: json['productAvt'],
      price: json['price'].toDouble(),
      rentalPrices: rentalPrices,
    );
  }
}
