import 'package:flutter/material.dart';
import 'package:frs_mobile/models/product_detail_model.dart';

import '../models/cart_item_model.dart';

class CartProvider with ChangeNotifier {
  List<CartItemModel> _cartItems = [];

  List<CartItemModel> get cartItems => _cartItems;
  void notifyListeners() {
    super.notifyListeners();
  }

  void removeFromCartAndCheckOut() {
    // Lọc và xóa sản phẩm có isChecked == true
    _cartItems.forEach((cartItem) {
      cartItem.productDetailModel.removeWhere((product) => product.isChecked);
    });

    // Loại bỏ các CartItemModel không chứa sản phẩm
    _cartItems.removeWhere((cartItem) => cartItem.productDetailModel.isEmpty);

    notifyListeners();
  }

  void removeProductFromCart(ProductDetailModel product) {
    // Lọc và xóa sản phẩm có isChecked == true
    _cartItems.forEach((cartItem) {
      cartItem.productDetailModel.remove(product);
    });

    // Loại bỏ các CartItemModel không chứa sản phẩm
    _cartItems.removeWhere((cartItem) => cartItem.productDetailModel.isEmpty);

    notifyListeners();
  }

  void addToCart(CartItemModel item) {
    final existingCartItem = _cartItems.firstWhere(
      (cartItem) => cartItem.productOwnerID == item.productOwnerID,
      orElse: () => CartItemModel(
        productOwnerID: item.productOwnerID,
        productOwnerName: item.productOwnerName,
        productOwnerAddress: item.productOwnerAddress,
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
}
