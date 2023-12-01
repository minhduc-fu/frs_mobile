import 'package:frs_mobile/models/customer_model.dart';

class FeedbackModel {
  int feedBackID;
  int ratingPoint;
  String description;
  DateTime createdDate;
  CustomerModel customerDTO;

  FeedbackModel({
    required this.feedBackID,
    required this.ratingPoint,
    required this.description,
    required this.createdDate,
    required this.customerDTO,
  });

  factory FeedbackModel.fromJson(Map<String, dynamic> json) {
    return FeedbackModel(
      feedBackID: json['feedBackID'],
      ratingPoint: json['ratingPoint'],
      description: json['description'],
      createdDate: DateTime(
        json['createdtDate'][0],
        json['createdtDate'][1],
        json['createdtDate'][2],
      ),
      customerDTO: CustomerModel.fromJson(json['customerDTO']),
    );
  }
}
