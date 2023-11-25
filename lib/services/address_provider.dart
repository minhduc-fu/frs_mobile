import 'package:flutter/material.dart';
import 'package:frs_mobile/models/address_model.dart';

class AddressProvider with ChangeNotifier {
  List<AddressModel> _addresses = [];
  AddressModel? _selectedAddress;

  AddressModel? get selectedAddress => _selectedAddress;
  List<AddressModel> get addresses => _addresses;
  void selectAddress(AddressModel address) {
    _selectedAddress = address;
    notifyListeners();
  }

  void notifyListeners() {
    super.notifyListeners();
  }

  void setAddresses(List<AddressModel> addresses) {
    _addresses = addresses;
    notifyListeners();
  }

// Thêm địa chỉ mới vào danh sách
  void addAddress(AddressModel address) {
    _addresses.add(address);
    notifyListeners();
  }

  // Xóa địa chỉ khỏi danh sách
  void deleteAddress(int addressID) {
    _addresses.removeWhere((address) => address.addressID == addressID);
    notifyListeners();
  }

  void clearSelectedAddress() {
    _selectedAddress = null;
    notifyListeners();
  }
}
