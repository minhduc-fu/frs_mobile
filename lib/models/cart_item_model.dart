import 'product_detail_model.dart';

class CartItemModel {
  final int productOwnerID;
  final String productOwnerName;
  List<ProductDetailModel> productDetailModel;
  bool isChecked;
  int productOwnerProvinceID;
  int serviceFee = 0;

  CartItemModel({
    required this.productOwnerID,
    required this.productOwnerName,
    required this.productDetailModel,
    this.isChecked = false,
    this.productOwnerProvinceID = 0,
  });

  int get selectedProductCount {
    return productDetailModel.where((product) => product.isChecked).length;
  }

  double calculateTotalPrice() {
    return productDetailModel
        .where((product) => product.isChecked == true)
        .fold<double>(0, (total, product) => total + product.price);
  }
}
