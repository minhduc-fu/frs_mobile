class CustomerModel {
  int customerID;
  String fullName;
  String phone;
  bool sex;
  String avatarUrl;

  CustomerModel({
    required this.customerID,
    required this.fullName,
    required this.phone,
    required this.sex,
    required this.avatarUrl,
  });

  factory CustomerModel.fromJson(Map<dynamic, dynamic> json) {
    return CustomerModel(
      customerID: json['customerID'],
      fullName: json['fullName'],
      phone: json['phone'],
      sex: json['sex'],
      avatarUrl: json['avatarUrl'],
    );
  }

  Map<dynamic, dynamic> toJson() {
    return {
      'customerID': customerID,
      'fullName': fullName,
      'phone': phone,
      'sex': sex,
      'avatarUrl': avatarUrl,
    };
  }
}
