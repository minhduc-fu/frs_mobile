import 'dart:convert';

import 'package:http/http.dart' as http;

class GHNApiService {
  static const String baseUrl =
      'https://online-gateway.ghn.vn/shiip/public-api';
  static const String token = '667cedf4-7eb1-11ee-a59f-a260851ba65c';
  static const String shopId = '4685019';

  static Future<List<Map<String, dynamic>>> getProvinces() async {
    final url = Uri.parse('$baseUrl/master-data/province');
    final response = await http.get(
      url,
      headers: {'Content-Type': 'application/json', 'Token': token},
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['data'];
      return List<Map<String, dynamic>>.from(data);
    } else {
      throw Exception('Failed to load provinces');
    }
  }

  static Future<List<Map<String, dynamic>>> getDistricts(int provinceId) async {
    final url = Uri.parse('$baseUrl/master-data/district');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json', 'Token': token},
      body: json.encode({'province_id': provinceId}),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['data'];
      return List<Map<String, dynamic>>.from(data);
    } else {
      throw Exception('Failed to load districts');
    }
  }

  static Future<List<Map<String, dynamic>>> getWards(int districtId) async {
    final url = Uri.parse('$baseUrl/master-data/ward?district_id');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json', 'Token': token},
      body: json.encode({'district_id': districtId}),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['data'];
      return List<Map<String, dynamic>>.from(data);
    } else {
      throw Exception('Failed to load wards');
    }
  }

  static Future<int> calculateShippingFee({
    required int fromDistrictId,
    required int toDistrictId,
    required String toWardCode,
    int height = 15,
    int length = 15,
    int weight = 1000,
    int width = 15,
  }) async {
    final url = Uri.parse('$baseUrl/v2/shipping-order/fee');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Token': token,
        'ShopId': shopId,
      },
      body: json.encode({
        'service_type_id': 2,
        'from_district_id': fromDistrictId,
        'to_district_id': toDistrictId,
        'to_ward_code': toWardCode,
        'height': height,
        'length': length,
        'weight': weight,
        'width': width,
      }),
    );

    if (response.statusCode == 200) {
      final dynamic data = json.decode(response.body)['data'];
      final int serviceFee = data['service_fee'];
      return serviceFee;
    } else {
      throw Exception('Failed to calculate shipping fee');
    }
  }
}
