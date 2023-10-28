class ProductOwnerModel {
  int productOwnerID;
  String fullName;
  String phone;
  String avatarUrl;
  String address;

  ProductOwnerModel({
    required this.productOwnerID,
    required this.fullName,
    required this.phone,
    required this.avatarUrl,
    required this.address,
  });

  factory ProductOwnerModel.fromJson(Map<dynamic, dynamic> json) {
    return ProductOwnerModel(
      productOwnerID: json['productownerID'],
      fullName: json['fullName'],
      phone: json['phone'],
      avatarUrl: json['avatarUrl'],
      address: json['address'],
    );
  }
  Map<dynamic, dynamic> toJson() {
    return {
      'productownerID': productOwnerID,
      'fullName': fullName,
      'phone': phone,
      'avatarUrl': avatarUrl,
      'address': address,
    };
  }
}
