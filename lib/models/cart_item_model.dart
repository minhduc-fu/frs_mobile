import 'product_detail_model.dart';

class CartItemModel {
  final int productOwnerID;
  final String productOwnerName;
  List<ProductDetailModel> productDetailModel;

  CartItemModel(
      {required this.productOwnerID,
      required this.productOwnerName,
      required this.productDetailModel});
}
