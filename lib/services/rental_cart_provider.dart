import 'package:flutter/material.dart';
import 'package:frs_mobile/models/rental_cart_item_model.dart';

class RentalCartProvider with ChangeNotifier {
  List<RentalCartItemModel> _rentalCartItems = [];

  List<RentalCartItemModel> get rentalCartItems => _rentalCartItems;

  void notifyListeners() {
    super.notifyListeners();
  }

  void removeFromCartAndCheckOut() {
    // Lọc và xóa sản phẩm có isChecked == true
    _rentalCartItems.forEach((rentalCartItem) {
      rentalCartItem.productDetailModel
          .removeWhere((product) => product.isChecked);
    });

    // Loại bỏ các CartItemModel không chứa sản phẩm
    _rentalCartItems.removeWhere(
        (rentalCartItem) => rentalCartItem.productDetailModel.isEmpty);

    notifyListeners();
  }

  void addToRentalCart(RentalCartItemModel item) {
    final existingCartItem = _rentalCartItems.firstWhere(
      (rentalCartItem) => rentalCartItem.productOwnerID == item.productOwnerID,
      orElse: () => RentalCartItemModel(
        productOwnerID: item.productOwnerID,
        productOwnerName: item.productOwnerName,
        productDetailModel: [],
      ),
    );
    if (existingCartItem.productDetailModel.isEmpty) {
      // Nếu danh sách sản phẩm của chủ sở hữu là rỗng, cập nhật trạng thái chọn của chủ sở hữu
      // existingCartItem.isSelected = true;
      _rentalCartItems.add(item);
    }
    existingCartItem.productDetailModel.addAll(item.productDetailModel);
    notifyListeners();
  }

  bool isProductInRentalCart(int productId) {
    return _rentalCartItems.any((rentalCartItem) {
      return rentalCartItem.productDetailModel.any((product) {
        return product.productID == productId;
      });
    });
  }

  void removeFromCart(RentalCartItemModel item) {
    _rentalCartItems.remove(item);
    notifyListeners();
  }

  void clearCart() {
    _rentalCartItems.clear();
    notifyListeners();
  }
}
