import 'package:demo_frs_app/models/food.dart';
import 'package:demo_frs_app/utils/asset_helper.dart';
import 'package:flutter/material.dart';

class Shop extends ChangeNotifier {
  // food menu

  final List<Food> _foodMenu = [
    Food(
        name: 'Salmon Sushi',
        price: '21.00',
        imagePath: AssetHelper.imageSushi2,
        rating: '4.9'),
    Food(
        name: 'Tuna Sushi',
        price: '23.00',
        imagePath: AssetHelper.imageSushi3,
        rating: '4.5'),
  ];

  // customer cart
  List<Food> _cart = [];

  //getter methods
  List<Food> get foodMenu => _foodMenu;
  List<Food> get cart => _cart;
  // add to cart
  void addToCart(Food foodItem, int quantity) {
    for (int i = 0; i < quantity; i++) {
      _cart.add(foodItem);
    }
    notifyListeners();
  }

  // remove form cart
  void removeFormCart(Food food) {
    _cart.remove(food);
    notifyListeners();
  }
}
