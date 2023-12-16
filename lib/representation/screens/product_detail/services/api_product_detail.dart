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

  static Future<int> createFeedbackProduct(int customerID, String description,
      int orderRentID, int productID, int ratingPoint) async {
    final url = Uri.parse('http://fashionrental.online:8080/feedback');
    final Map<String, dynamic> requestData = {
      'customerID': customerID,
      'description': description,
      'orderRentID': orderRentID,
      'productID': productID,
      'ratingPoint': ratingPoint,
    };
    final response = await http.post(url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(requestData));
    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      final int feedBackID = responseData['feedBackID'] as int;
      return feedBackID;
      // print('OK');
    } else {
      print('Not OK');
      throw Exception('Failed to create feedback');
    }
  }

  static Future<void> createFeedBackImg(
      int feedBackID, List<String> imgUrls) async {
    final url = Uri.parse('http://fashionrental.online:8080/feedbackimg');
    final Map<String, dynamic> requestData = {
      'feedBackID': feedBackID,
      'imgUrl': imgUrls,
    };
    final response = await http.post(url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(requestData));
    if (response.statusCode == 200) {
      print('Create feedback image success');
    } else {
      print('Create feedback image failed');
    }
  }

  static Future<Map<String, List<int>>>
      getOrderRentDetailByProductIDAndOrderRentStatusRenting(
          int productID) async {
    final url = Uri.parse(
        'http://fashionrental.online:8080/orderrentdetail/$productID/date');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        Map<String, dynamic> data = json.decode(response.body);

        if (data.containsKey("startDate") && data.containsKey("endDate")) {
          List<int> startDate = List<int>.from(data["startDate"]);
          List<int> endDate = List<int>.from(data["endDate"]);
          return {"startDate": startDate, "endDate": endDate};
        } else {
          // Handle the case when the response structure is not as expected
          return {};
        }
      } else {
        print('Error: ${response.statusCode}');
        return {};
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // static Future<void> createFeedbackImg(int feedBackID, ){

  // }

  static Future<void> votePOReputation(int productownerID) async {
    final url = Uri.parse(
        'http://fashionrental.online:8080/po/votereputation?productownerID=${productownerID}');
    final response = await http.put(url);
    if (response.statusCode == 200) {
      print('vote success');
    } else {
      print('vote faild');
    }
  }

  static Future<void> unVoteReputation(int productownerID) async {
    final url = Uri.parse(
        'http://fashionrental.online:8080/po/unvotereputation?productownerID=${productownerID}');
    final response = await http.put(url);
    if (response.statusCode == 200) {
      print('unVote success');
    } else {
      print('unVote faild');
    }
  }
}
