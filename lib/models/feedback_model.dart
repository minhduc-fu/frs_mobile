import 'package:frs_mobile/models/customer_model.dart';
import 'package:frs_mobile/models/img_feedback_dto.dart';

class FeedbackModel {
  int feedBackID;
  int ratingPoint;
  String description;
  DateTime createdDate;
  CustomerModel customerDTO;
  List<ImgFeedbackDTO> imgDTOs;

  FeedbackModel({
    required this.feedBackID,
    required this.ratingPoint,
    required this.description,
    required this.createdDate,
    required this.customerDTO,
    required this.imgDTOs,
  });

  factory FeedbackModel.fromJson(Map<String, dynamic> json) {
    List<ImgFeedbackDTO> imgDTOs = [];
    if (json['imgDTOs'] != null) {
      imgDTOs = List<ImgFeedbackDTO>.from(
          json['imgDTOs'].map((imgJson) => ImgFeedbackDTO.fromJson(imgJson)));
    }

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
      imgDTOs: imgDTOs,
    );
  }
}
