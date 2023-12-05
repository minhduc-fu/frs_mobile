import 'package:flutter/material.dart';
import 'package:frs_mobile/models/product_detail_model.dart';
import 'package:frs_mobile/models/rental_cart_item_model.dart';

class RentalCartProvider with ChangeNotifier {
  List<RentalCartItemModel> _rentalCartItems = [];

  List<RentalCartItemModel> get rentalCartItems => _rentalCartItems;

  void notifyListeners() {
    super.notifyListeners();
  }

  void removeFromCartAndCheckOut() {
    _rentalCartItems.forEach((rentalCartItem) {
      rentalCartItem.productDetailModel
          .removeWhere((product) => product.isChecked);
    });
    _rentalCartItems.removeWhere(
        (rentalCartItem) => rentalCartItem.productDetailModel.isEmpty);

    notifyListeners();
  }

  void removeProductFromCart(ProductDetailModel product) {
    _rentalCartItems.forEach((cartItem) {
      cartItem.productDetailModel.remove(product);
    });
    _rentalCartItems
        .removeWhere((cartItem) => cartItem.productDetailModel.isEmpty);

    notifyListeners();
  }

  void addToRentalCart(RentalCartItemModel item) {
    final existingCartItem = _rentalCartItems.firstWhere(
      (rentalCartItem) => rentalCartItem.productOwnerID == item.productOwnerID,
      orElse: () => RentalCartItemModel(
        productOwnerID: item.productOwnerID,
        productOwnerName: item.productOwnerName,
        productOwnerAddress: item.productOwnerAddress,
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

  bool areSelectedProductsSameDate() {
    final selectedProductsMap = <int, List<ProductDetailModel>>{};

    for (var cartItem in _rentalCartItems) {
      for (var product in cartItem.productDetailModel) {
        if (product.isChecked) {
          final ownerID = cartItem.productOwnerID;

          if (!selectedProductsMap.containsKey(ownerID)) {
            selectedProductsMap[ownerID] = [];
          }

          selectedProductsMap[ownerID]!.add(product);
        }
      }
    }

    return selectedProductsMap.values.every(
      (selectedProducts) {
        final startDate = selectedProducts.first.startDate;
        final endDate = selectedProducts.first.endDate;

        return selectedProducts.every(
          (product) =>
              product.startDate == startDate && product.endDate == endDate,
        );
      },
    );
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
