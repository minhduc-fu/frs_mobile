import 'dart:convert';
import 'package:frs_mobile/representation/screens/customer/account/orderHistoryCustomer/buy_order_history/model/order_buy_detail_model.dart';
import 'package:frs_mobile/representation/screens/customer/account/orderHistoryCustomer/buy_order_history/model/order_buy_model.dart';
import 'package:http/http.dart' as http;

class ApiBuyOderHistory {
  static Future<List<OrderBuyModel>?> getAllPendingOrderBuyByCustomerID(
      int customerID) async {
    final url = Uri.parse(
        'http://fashionrental.online:8080/orderbuy/customer/pending/$customerID');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);
        if (jsonList.isEmpty) {
          return null;
        } else {
          return jsonList.map((json) => OrderBuyModel.fromJson(json)).toList();
        }
      } else {
        throw Exception('Lấy danh sách order pending thất bại.');
      }
    } catch (e) {
      throw Exception('Lỗi: $e');
    }
  }

  static Future<List<OrderBuyModel>?> getAllPrepareOrderBuyByCustomerID(
      int customerID) async {
    final url = Uri.parse(
        'http://fashionrental.online:8080/orderbuy/customer/prepare/$customerID');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);
        if (jsonList.isEmpty) {
          return null;
        } else {
          return jsonList.map((json) => OrderBuyModel.fromJson(json)).toList();
        }
      } else {
        throw Exception('Lấy danh sách order prepare thất bại.');
      }
    } catch (e) {
      throw Exception('Lỗi: $e');
    }
  }

  static Future<List<OrderBuyModel>?> getAllRejectingOrderBuyByCustomerID(
      int customerID) async {
    final url = Uri.parse(
        'http://fashionrental.online:8080/orderbuy/customer/rejecting/$customerID');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);
        if (jsonList.isEmpty) {
          return null;
        } else {
          return jsonList.map((json) => OrderBuyModel.fromJson(json)).toList();
        }
      } else {
        throw Exception('Lấy danh sách order rejecting thất bại.');
      }
    } catch (e) {
      throw Exception('Lỗi: $e');
    }
  }

  static Future<List<OrderBuyModel>?> getAllReadyPickUpOrderBuyByCustomerID(
      int customerID) async {
    final url = Uri.parse(
        'http://fashionrental.online:8080/orderbuy/customer/delivery/$customerID');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);
        if (jsonList.isEmpty) {
          return null;
        } else {
          return jsonList.map((json) => OrderBuyModel.fromJson(json)).toList();
        }
      } else {
        throw Exception('Lấy danh sách order ready_pickup thất bại.');
      }
    } catch (e) {
      throw Exception('Lỗi: $e');
    }
  }

  static Future<List<OrderBuyModel>?> getAllCompletedOrderBuyByCustomerID(
      int customerID) async {
    final url = Uri.parse(
        'http://fashionrental.online:8080/orderbuy/customer/completed/$customerID');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);
        if (jsonList.isEmpty) {
          return null;
        } else {
          return jsonList.map((json) => OrderBuyModel.fromJson(json)).toList();
        }
      } else {
        throw Exception('Lấy danh sách order completed thất bại.');
      }
    } catch (e) {
      throw Exception('Lỗi: $e');
    }
  }

  static Future<List<OrderBuyModel>?> getAllConfirmOrderBuyByCustomerID(
      int customerID) async {
    final url = Uri.parse(
        'http://fashionrental.online:8080/orderbuy/customer/confirm/$customerID');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);
        if (jsonList.isEmpty) {
          return null;
        } else {
          return jsonList.map((json) => OrderBuyModel.fromJson(json)).toList();
        }
      } else {
        throw Exception('Lấy danh sách order confirm thất bại.');
      }
    } catch (e) {
      throw Exception('Lỗi: $e');
    }
  }

  static Future<List<OrderBuyModel>?> getAllCanceledOrderBuyByCustomerID(
      int customerID) async {
    final url = Uri.parse(
        'http://fashionrental.online:8080/orderbuy/customer/canceled/$customerID');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);
        if (jsonList.isEmpty) {
          return null;
        } else {
          return jsonList.map((json) => OrderBuyModel.fromJson(json)).toList();
        }
      } else {
        throw Exception('Lấy danh sách order canceled thất bại.');
      }
    } catch (e) {
      throw Exception('Lỗi: $e');
    }
  }

  static Future<List<OrderBuyDetailModel>?> getAllOrderBuyDetailByOrderBuyID(
      int orderBuyID) async {
    final url = Uri.parse(
        'http://fashionrental.online:8080/orderbuydetail/$orderBuyID');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);
        if (jsonList.isEmpty) {
          return null;
        } else {
          return jsonList
              .map((json) => OrderBuyDetailModel.fromJson(json))
              .toList();
        }
      } else {
        throw Exception('Lấy chi tiết đơn hàng thất bại.');
      }
    } catch (e) {
      throw Exception('Lỗi: $e');
    }
  }

  static Future<void> updateStatusOrder(int orderBuyID, String status) async {
    final url = Uri.parse(
        'http://fashionrental.online:8080/orderbuy?orderBuyID=${orderBuyID}&status=${status}');

    try {
      final response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'orderBuyID': orderBuyID,
          'status': status,
        }),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Cập nhật status không thành công');
      }
    } catch (e) {
      throw Exception('Lỗi: $e');
    }
  }
}
