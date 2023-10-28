import 'package:flutter/cupertino.dart';

import '../models/customer_model.dart';
import '../models/productOwner_model.dart';
import '../models/user_model.dart';

class AuthProvider with ChangeNotifier {
  bool isLoggedIn = false;
  static UserModel? userModel;

  void setUser(UserModel user) {
    userModel = user;
    isLoggedIn = true;
    if (user.role.roleName == 'Customer') {
      customer = user.customer;
    } else if (user.role.roleName == 'ProductOwner') {
      productOwner = user.productOwner;
    }
    // LocalStorageHelper.setValue('isLoggedIn', true);
    // LocalStorageHelper.setValue('userModel', json.encode(user.toJson()));
    notifyListeners();
  }

  void clearUser() {
    userModel = null;
    isLoggedIn = false;
    notifyListeners();
  }

  CustomerModel? customer; // Thông tin người dùng kiểu CustomerModel
  ProductOwnerModel?
      productOwner; // Thông tin người dùng kiểu ProductOwnerModel
}
