import 'dart:typed_data';

import 'package:frs_mobile/representation/screens/customer/account/orderHistoryCustomer/buy_order_history/model/productDTO_model.dart';

class OrderRentDetailModel {
  int orderRentDetailID;
  double cocMoney;
  double rentPrice;
  DateTime startDate;
  DateTime endDate;
  int dayRemaining;
  // double price;
  ProductDTOModel productDTOModel;
  int orderRentID;
  double? ratingFeedback;
  String? descriptionFeedback;
  List<Uint8List>? imagesFeedback;

  OrderRentDetailModel({
    required this.orderRentDetailID,
    required this.cocMoney,
    required this.rentPrice,
    required this.startDate,
    required this.endDate,
    required this.dayRemaining,
    // required this.price,
    required this.productDTOModel,
    required this.orderRentID,
    this.ratingFeedback = 5.0,
    this.descriptionFeedback = 'Tuyệt vời',
    this.imagesFeedback,
  });

  factory OrderRentDetailModel.fromJson(Map<String, dynamic> json) {
    return OrderRentDetailModel(
      orderRentDetailID: json['orderRentDetailID'],
      cocMoney: json['cocMoney'].toDouble(),
      rentPrice: json['rentPrice'].toDouble(),
      startDate: DateTime(
        json['startDate'][0],
        json['startDate'][1],
        json['startDate'][2],
      ),
      endDate: DateTime(
        json['endDate'][0],
        json['endDate'][1],
        json['endDate'][2],
      ),
      dayRemaining: json['dayRemaining'],
      // price: json['price'].toDouble(),
      productDTOModel: ProductDTOModel.fromJson(json['productDTO']),
      orderRentID: json['orderRentID'],
    );
  }
}
