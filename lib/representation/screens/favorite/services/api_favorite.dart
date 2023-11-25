import 'dart:convert';

import 'package:http/http.dart' as http;

class ApiFavorite {
  static Future<void> createFavoriteProduct(
      int customerID, int productID) async {
    final url = Uri.parse('http://fashionrental.online:8080/favoriteproduct');
    final Map<String, dynamic> requestData = {
      'customerID': customerID,
      'productID': productID,
    };

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(requestData),
      );

      if (response.statusCode == 200) {
        print('Gọi API createFavoriteProduct thành công');
      } else {
        throw Exception('Failed to create favorite product');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  static Future<void> unmarkFavoriteStatus(int favoriteproductID) async {
    final url = Uri.parse(
        'http://fashionrental.online:8080/favoriteproduct?favoriteproductID=$favoriteproductID');

    try {
      final response = await http.put(url);

      if (response.statusCode == 200) {
        print('Gọi API unmarkFavoriteStatus thành công');
      } else {
        throw Exception('Failed to unmark favorite status');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  static Future<List<Map<String, dynamic>>?> getFavoriteByCusID(
      int customerID) async {
    final url = Uri.parse(
        'http://fashionrental.online:8080/favoriteproduct/$customerID');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        if (response != []) {
          List<dynamic> data = json.decode(response.body);
          List<Map<String, dynamic>> favorites =
              data.map((json) => json as Map<String, dynamic>).toList();
          return favorites;
        } else {
          return [];
        }
      } else {
        throw Exception('Failed to load favorite products');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}
