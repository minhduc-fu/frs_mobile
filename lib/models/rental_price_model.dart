class RentalPriceModel {
  int productRentalPricesID;
  double rentPrice1;
  double rentPrice4;
  double rentPrice7;
  double rentPrice10;
  double rentPrice14;

  RentalPriceModel({
    required this.productRentalPricesID,
    required this.rentPrice1,
    required this.rentPrice4,
    required this.rentPrice7,
    required this.rentPrice10,
    required this.rentPrice14,
  });

  factory RentalPriceModel.fromJson(Map<String, dynamic> json) {
    return RentalPriceModel(
      productRentalPricesID: json['productRentalPricesID'],
      rentPrice1: json['rentPrice1'],
      rentPrice4: json['rentPrice4'],
      rentPrice7: json['rentPrice7'],
      rentPrice10: json['rentPrice10'],
      rentPrice14: json['rentPrice14'],
    );
  }
}
