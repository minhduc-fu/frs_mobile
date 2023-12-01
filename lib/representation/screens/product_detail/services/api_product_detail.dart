import 'package:frs_mobile/models/feedback_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiProductDetail {
  static Future<List<FeedbackModel>> getFeedbackByProductID(
      int productID) async {
    final url =
        Uri.parse('http://fashionrental.online:8080/feedback/$productID');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        List<FeedbackModel> feedbackList = data
            .map((feedbackJson) => FeedbackModel.fromJson(feedbackJson))
            .toList();
        return feedbackList;
      } else {
        print('Error: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}
