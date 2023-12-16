import 'dart:convert'; // để encode và decode JSON
import 'package:frs_mobile/models/address_model.dart';
import 'package:frs_mobile/models/category.dart';
import 'package:frs_mobile/models/product_image_model.dart';
import 'package:frs_mobile/models/voucher_model.dart';
import 'package:frs_mobile/models/wallet_model.dart';
import 'package:http/http.dart' as http;

import '../models/productOwner_model.dart';
import '../models/product_detail_model.dart';
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

  static Future<List<ProductModel>?> getAllProductByCategoryName(
      String categoryName) async {
    final url = Uri.parse(
        'http://fashionrental.online:8080/product/getallbycategory/$categoryName');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        List<ProductModel> products =
            data.map((json) => ProductModel.fromJson(json)).toList();

        return products;
      } else {
        throw Exception('Failed to load product by categoryName');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  static Future<List<ProductModel>?> getAllProductByProductName(
      String productName) async {
    final url = Uri.parse(
        'http://fashionrental.online:8080/product/getallbyproductname/$productName');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        List<ProductModel> products =
            data.map((json) => ProductModel.fromJson(json)).toList();

        return products;
      } else {
        throw Exception('Failed to load product by productName');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  static Future<List<ProductModel>?> getAllProductOnAvailable() async {
    final url =
        Uri.parse('http://fashionrental.online:8080/product/onavailable');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        List<ProductModel> products =
            data.map((json) => ProductModel.fromJson(json)).toList();

        return products;
      } else {
        throw Exception('Failed to load product Available');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  static Future<List<ProductModel>?> getAllProductOnRent() async {
    final url = Uri.parse('http://fashionrental.online:8080/product/onrent');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        List<ProductModel> products =
            data.map((json) => ProductModel.fromJson(json)).toList();

        return products;
      } else {
        throw Exception('Failed to load product Rent');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  static Future<List<ProductModel>?> getAllProductOnSale() async {
    final url = Uri.parse('http://fashionrental.online:8080/product/onsale');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        List<ProductModel> products =
            data.map((json) => ProductModel.fromJson(json)).toList();

        return products;
      } else {
        throw Exception('Failed to load product Rent');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  static Future<List<ProductModel>?> getAllProductOnSoldOut() async {
    final url = Uri.parse('http://fashionrental.online:8080/product/onsoldout');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        List<ProductModel> products =
            data.map((json) => ProductModel.fromJson(json)).toList();

        return products;
      } else {
        throw Exception('Failed to load product Rent');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

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

  static Future<List<CategoryModel>?> getAllCategory() async {
    final url = Uri.parse('http://fashionrental.online:8080/category/getall');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        List<CategoryModel> categories =
            data.map((json) => CategoryModel.fromJson(json)).toList();
        return categories;
      } else {
        throw Exception('Failed to load category');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  static Future<ProductDetailModel?> getProductByID(int productID) async {
    final url =
        Uri.parse('http://fashionrental.online:8080/product/$productID');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        Map<String, dynamic> data = json.decode(response.body);
        ProductDetailModel productDetail = ProductDetailModel.fromJson(data);
        return productDetail;
      } else {
        throw Exception('Failed to load product detail');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  static Future<ProductOwnerModel?> getProductOwnerByID(
      int productOwnerID) async {
    final url =
        Uri.parse('http://fashionrental.online:8080/po/$productOwnerID');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        Map<String, dynamic> data = json.decode(response.body);
        ProductOwnerModel productOwnerModel = ProductOwnerModel.fromJson(data);
        return productOwnerModel;
      } else {
        throw Exception('Failed to load product owner');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  static Future<List<ProductImageModel>?> getAllProductImgByProductID(
      int productID) async {
    final url = Uri.parse(
        'http://fashionrental.online:8080/productimg?productID=$productID');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        List<ProductImageModel> productImages =
            data.map((json) => ProductImageModel.fromJson(json)).toList();
        return productImages;
      } else {
        throw Exception('Failed to load All Product Image');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  static Future<Map<String, dynamic>?> createWallet(
      int accountID, double balance) async {
    final url = Uri.parse('http://fashionrental.online:8080/wallet');
    final Map<String, dynamic> requestData = {
      'accountID': accountID,
      'balance': balance,
    };
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(requestData),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      return null;
    }
  }

  static Future<WalletModel?> getWalletByAccountID(int accountID) async {
    final url = Uri.parse('http://fashionrental.online:8080/wallet/$accountID');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return WalletModel.fromJson(data);
      } else {
        throw Exception('Truy xuất thông tin ví không thành công.');
      }
    } catch (e) {
      throw Exception('Lỗi $e');
    }
  }

  static Future<WalletModel?> updateBalance(
      double balance, int walletID) async {
    final url = Uri.parse(
        'http://fashionrental.online:8080/wallet?balance=$balance&walletID=$walletID');
    try {
      final response = await http.put(url);
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return WalletModel.fromJson(data);
      } else {
        throw Exception('Cập nhật số dư không thành công.');
      }
    } catch (e) {
      throw Exception('Lỗi $e');
    }
  }

  static Future<String> submitOrder(
      int accountID, int amount, String orderInfo) async {
    final url = Uri.parse(
        'http://fashionrental.online:8080/VNPaycontroller/submitOrder?accountID=$accountID&amount=$amount&orderInfo=$orderInfo');
    try {
      final response = await http.post(url);

      if (response.statusCode == 200) {
        print(response.body);
        return response.body;
      } else {
        throw Exception('Submit Order không thành công.');
      }
    } catch (e) {
      throw Exception('Lỗi $e');
    }
  }

  static Future<void> callGetMapping() async {
    final url = Uri.parse(
        'http://fashionrental.online:8080/VNPaycontroller/vnpay-payment');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      print('Response: ${response.body}');
    } else {
      print('Failed to call GET API');
    }
  }

  static Future<Map<String, dynamic>?> createNewAddress(
    String addressDescription,
    int customerID,
  ) async {
    final url = Uri.parse('http://fashionrental.online:8080/address');
    final Map<String, dynamic> requestData = {
      'addressDescription': addressDescription,
      'customerID': customerID,
    };
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(requestData),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      return null;
    }
  }

  static Future<List<AddressModel>?> getAllAddressByCustomerID(
      int customerID) async {
    final url =
        Uri.parse('http://fashionrental.online:8080/address/$customerID');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        final List<AddressModel> addresses = data
            .map((json) => AddressModel.fromJson(json as Map<String, dynamic>))
            .toList();
        return addresses;
      } else if (response.statusCode == 204) {
        // Return an empty list when there are no addresses.
        return [];
      } else {
        throw Exception('Tải địa chỉ lên thất bại.');
      }
    } catch (e) {
      throw Exception('Lỗi: $e');
    }
  }

  static Future<Map<String, dynamic>?> deleteAddress(int addressID) async {
    final url = Uri.parse(
        'http://fashionrental.online:8080/address?addressID=$addressID');
    final response = await http.delete(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      return null;
    }
  }

  static Future<List<dynamic>?> createOrderBuyAndOrderBuyDetail(
      List<Map<String, dynamic>> orderData) async {
    final url = Uri.parse('http://fashionrental.online:8080/orderbuy');

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(orderData),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      return null;
    }
  }

  static Future<List<dynamic>?> createOrderRentAndOrderRentDetail(
      List<Map<String, dynamic>> orderData) async {
    final url = Uri.parse('http://fashionrental.online:8080/orderrent');

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(orderData),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      return null;
    }
  }

  static Future<List<dynamic>?> getAllTransactionByAccountID(
      int accountID) async {
    final url = Uri.parse('http://fashionrental.online:8080/trans/$accountID');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Lấy danh sách giao dịch thất bại.');
      }
    } catch (e) {
      throw Exception('Lỗi: $e');
    }
  }

  static Future<List<VoucherModel>> getVoucherByProrductOwnerIDNotExpired(
      int productOwnerID) async {
    final response = await http.get(
      Uri.parse('http://fashionrental.online:8080/voucher/$productOwnerID'),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      if (data.isEmpty) {
        return [];
      } else {
        return data.map((json) => VoucherModel.fromJson(json)).toList();
      }
    } else {
      throw Exception('Failed to load vouchers');
    }
  }

  static Future<void> useVoucher(String voucherCode) async {
    final response = await http.post(
      Uri.parse('http://fashionrental.online:8080/voucher/$voucherCode'),
    );

    if (response.statusCode == 200) {
      print('Gọi api useVoucher thành công');
    } else {
      throw Exception('Failed to load vouchers');
    }
  }
}
