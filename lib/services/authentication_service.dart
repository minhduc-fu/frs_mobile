import 'dart:convert'; // để encode và decode JSON
import 'package:http/http.dart' as http;

import '../models/product_model.dart';

class AuthenticationService {
  //Trả về Future chứa Map<key, value>
  static Future<Map<String, dynamic>?> logIn(
      String email, String password) async {
    // chuyển URL thành Uri được sử dụng để gửi request đến server
    final url = Uri.parse(
        'http://fashionrental.online:8080/account/login?email=${email!}&password=${password!}');

    // thực hiện request POST để gửi data tới URL ở trên
    final response = await http.post(
      url,
      headers: {
        // cho server biết content của request là object JSON
        'Content-Type': 'application/json',
      },
      // chuyển đổi Map<email, password> thành chuỗi JSON
      // và gửi nó đến body của request POST
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      // chuyển đổi response.body thành object
      return json.decode(response.body);
    } else {
      return null;
    }
  }

  static Future<Map<String, dynamic>?> createAccount(
      String email, String password, int roleID) async {
    final url = Uri.parse(
        'http://fashionrental.online:8080/account/create?email=${email!}&password=${password!}&roleID=${roleID}');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body:
          jsonEncode({'email': email, 'password': password, 'roleID': roleID}),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      return null;
    }
  }

  static Future<Map<String, dynamic>?> createCustomer(
    int accountID,
    String fullName,
    String phone,
    bool sex,
    String avatarUrl,
  ) async {
    final url = Uri.parse(
        'http://fashionrental.online:8080/customer/sign-up?accountID=${accountID}&fullName=${fullName}&phone=${phone}&sex=${sex}&avatarUrl=${avatarUrl}');

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'accountID': accountID,
        'avatarUrl': avatarUrl,
        'fullName': fullName,
        'phone': phone,
        'sex': sex,
      }),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      return null;
    }
  }

  static Future<Map<String, dynamic>?> updateStatus(
      int accountID, String status) async {
    final url = Uri.parse(
        'http://fashionrental.online:8080/account/updatestatus?accountID=${accountID}&status=${status}');
    final response = await http.put(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'accountID': accountID,
        'status': status,
      }),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Cập nhật status không thành công');
    }
  }

  static Future<Map<String, dynamic>?> updateCustomer(
    int customerID,
    String avatarUrl,
    String fullName,
    String phone,
    bool sex,
  ) async {
    final url = Uri.parse(
        "http://fashionrental.online:8080/customer?customerID=${customerID}");
    final Map<String, dynamic> requestPayload = {
      'avatarUrl': avatarUrl,
      'fullName': fullName,
      'phone': phone,
      'sex': sex,
    };

    final response = await http.put(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(requestPayload),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Cập nhật không thành công');
    }
  }

  // static Future<List<ProductModel>?> getAllProduct() async {
  //   final url = Uri.parse('http://fashionrental.online:8080/product/getall');

  //   final response = await http.get(url);
  //   if (response.statusCode == 200) {
  //     List<dynamic> data = json.decode(response.body);
  //     List<ProductModel> products =
  //         data.map((json) => ProductModel.fromJson(json)).toList();
  //     return products;
  //   } else {
  //     return null;
  //   }
  // }

  static Future<List<ProductModel>?> getAllProduct() async {
    final url = Uri.parse('http://fashionrental.online:8080/product/getall');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        List<ProductModel> products =
            data.map((json) => ProductModel.fromJson(json)).toList();
        return products;
      } else {
        throw Exception('Failed to load products');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}
