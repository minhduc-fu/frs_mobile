import 'package:flutter/material.dart';
import '../models/cart_item_model.dart';

class CartProvider with ChangeNotifier {
  List<CartItemModel> _cartItems = [];

  List<CartItemModel> get cartItems => _cartItems;

  void addToCart(CartItemModel item) {
    final existingCartItem = _cartItems.firstWhere(
      (cartItem) => cartItem.productOwnerID == item.productOwnerID,
      orElse: () => CartItemModel(
        productOwnerID: 0,
        productOwnerName: '',
        productDetailModel: [],
      ),
    );
    if (existingCartItem.productOwnerID == 0) {
      // Nếu `productOwnerID` chưa tồn tại, thêm một `CartItemModel` mới.
      _cartItems.add(item);
    } else {
      // Nếu `productOwnerID` đã tồn tại, thêm sản phẩm vào danh sách sản phẩm của chủ sở hữu đó.
      existingCartItem.productDetailModel.addAll(item.productDetailModel);
    }
    notifyListeners();
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
