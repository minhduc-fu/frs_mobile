import 'package:frs_mobile/models/product_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class APIProductOwner {
  static Future<List<ProductModel>?> getProductByProductOwnerIDForCus(
      int productOwnerID) async {
    final url = Uri.parse(
        'http://fashionrental.online:8080/product/getproductsforcus/$productOwnerID');
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
      throw Exception('Lỗi: $e');
    }
  }

  static Future<List<ProductModel>?> getProductOnSaleByProductOwnerIDForCus(
      int productOwnerID) async {
    final url = Uri.parse(
        'http://fashionrental.online:8080/product/getproductsonsale/$productOwnerID');
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
      throw Exception('Lỗi: $e');
    }
  }

  static Future<List<ProductModel>?> getProductOnRentByProductOwnerIDForCus(
      int productOwnerID) async {
    final url = Uri.parse(
        'http://fashionrental.online:8080/product/getproductsonrent/$productOwnerID');
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
      throw Exception('Lỗi: $e');
    }
  }
}
