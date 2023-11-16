import 'package:frs_mobile/representation/screens/customer/account/orderHistoryCustomer/buy_order_history/model/productDTO_model.dart';

class OrderBuyDetailModel {
  int orderBuyDetailID;
  double price;
  ProductDTOModel productDTOModel;
  int orderBuyID;

  OrderBuyDetailModel({
    required this.orderBuyDetailID,
    required this.price,
    required this.productDTOModel,
    required this.orderBuyID,
  });

  factory OrderBuyDetailModel.fromJson(Map<String, dynamic> json) {
    return OrderBuyDetailModel(
      orderBuyDetailID: json['orderBuyDetailID'],
      price: json['price'].toDouble(),
      productDTOModel: ProductDTOModel.fromJson(json['productDTO']),
      orderBuyID: json['orderBuyID'],
    );
  }
}
