import 'product_detail_model.dart';

class CartItemModel {
  final int productOwnerID;
  final String productOwnerName;
  List<ProductDetailModel> productDetailModel;
  bool isChecked;
  int productOwnerProvinceID;
  int serviceFee;
  double voucherDiscount;
  String slectedDiscountText;
  String voucherCode;

  CartItemModel({
    required this.productOwnerID,
    required this.productOwnerName,
    required this.productDetailModel,
    this.isChecked = false,
    this.productOwnerProvinceID = 0,
    this.serviceFee = 0,
    this.voucherDiscount = 0,
    this.slectedDiscountText = 'Chọn voucher',
    this.voucherCode = '',
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
}
