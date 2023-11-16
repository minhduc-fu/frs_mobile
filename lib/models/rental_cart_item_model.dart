import 'product_detail_model.dart';

class RentalCartItemModel {
  final int productOwnerID;
  final String productOwnerName;
  List<ProductDetailModel> productDetailModel;
  bool isChecked;
  int productOwnerProvinceID;
  int serviceFee;
  //  int selectedRentalPeriod;
  // int selectedMockday;
  // String dateSelected;

  RentalCartItemModel({
    required this.productOwnerID,
    required this.productOwnerName,
    required this.productDetailModel,
    this.isChecked = false,
    this.productOwnerProvinceID = 0,
    this.serviceFee = 0,
    // this.selectedRentalPeriod = 0,
    // this.selectedMockday = 0,
    // this.dateSelected = '',
  });
  void removeCheckedProducts() {
    productDetailModel.removeWhere((product) => product.isChecked == true);
  }

  int get selectedProductCount {
    return productDetailModel.where((product) => product.isChecked).length;
  }

  double calculateTotalPrice() {
    return productDetailModel
        .where((product) => product.isChecked == true)
        .fold<double>(0, (total, product) => total + product.price);
  }

  double calculateTotalRentPrice() {
    return productDetailModel
        .where((product) => product.isChecked == true)
        .fold<double>(
            0, (total, product) => total + product.selectedRentPrice!);
  }

  // double calculateTotalRentalPrice() {
  //   final selectedRentalPrice =
  //       productDetailModel[selectedRentalPeriod - 1].rentalPrices![0].rentPrice;
  //   return selectedRentalPrice.toDouble();
  // }
}
