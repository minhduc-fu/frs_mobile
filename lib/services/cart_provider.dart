import 'package:flutter/material.dart';

import '../models/cart_item_model.dart';

class CartProvider with ChangeNotifier {
  List<CartItemModel> _cartItems = [];

  List<CartItemModel> get cartItems => _cartItems;
  void notifyListeners() {
    super.notifyListeners();
  }

  void addToCart(CartItemModel item) {
    final existingCartItem = _cartItems.firstWhere(
      (cartItem) => cartItem.productOwnerID == item.productOwnerID,
      orElse: () => CartItemModel(
        productOwnerID: item.productOwnerID,
        productOwnerName: item.productOwnerName,
        productDetailModel: [],
      ),
    );
    if (existingCartItem.productDetailModel.isEmpty) {
      // Nếu danh sách sản phẩm của chủ sở hữu là rỗng, cập nhật trạng thái chọn của chủ sở hữu
      // existingCartItem.isSelected = true;
      _cartItems.add(item);
    }
    existingCartItem.productDetailModel.addAll(item.productDetailModel);
    notifyListeners();
  }

  bool isProductInCart(int productId) {
    return _cartItems.any((cartItem) {
      return cartItem.productDetailModel.any((product) {
        return product.productID == productId;
      });
    });
  }

  void removeFromCart(CartItemModel item) {
    _cartItems.remove(item);
    notifyListeners();
  }

  void clearCart() {
    _cartItems.clear();
    notifyListeners();
  }

  // void calculateServiceFee(int index) async {
  //   final cartItem = _cartItems[index];
  //   try {
  //     // Thực hiện các bước tính toán service_fee tương tự fetchProvincesID
  //     // Ví dụ:
  //     final provinceID = await getProvinceID(cartItem.productOwnerAddress);
  //     final districtID = await getDistrictID(
  //         cartItem.productOwnerAddress, provinceID);
  //     final wardCode = await getWardCode(cartItem.productOwnerAddress, districtID);
  //     final serviceFee = await GHNApiService.calculateShippingFee(
  //         fromDistrictId: districtID,
  //         toDistrictId: cartItem.customerDistrictID,
  //         toWardCode: wardCode);

  //     // Cập nhật giá trị service_fee trong CartItemModel
  //     cartItem.serviceFee = serviceFee;

  //     // Thông báo về sự thay đổi trong trạng thái
  //     notifyListeners();
  //   } catch (e) {
  //     // Xử lý lỗi nếu cần thiết
  //     print('Lỗi tính toán service_fee: $e');
  //   }}
  //   Future<int> getProvinceID(String address) async {
  //   final provinces = await GHNApiService.getProvinces();

  //   // Giả sử địa chỉ có dạng "Tên đường, Phường/Xã, Quận/Huyện, Tỉnh/Thành phố"
  //   List<String> addressComponents = address.split(', ');
  //   // String province = addressComponents.last;
  //   String province = addressComponents.last.toLowerCase();
  //   print(province);
  //   for (final provinceData in provinces) {
  //     // Change dynamic to List<dynamic> and handle dynamic elements
  //     List<dynamic> nameExtensionsDynamic = provinceData['NameExtension'];
  //     List<String> nameExtensions = nameExtensionsDynamic
  //         .map((e) => e.toString().toLowerCase())
  //         .toList(); // Convert dynamic elements to String

  //     if (nameExtensions.contains(province)) {
  //       print(provinceData['ProvinceID']);
  //       return provinceData['ProvinceID'];
  //     }
  //   }

  //   throw Exception('Province not found for address: $address');
  // }
}
