class AddressModel {
  int addressID;
  String addressDescription;
  int customerID;

  AddressModel({
    required this.addressID,
    required this.addressDescription,
    required this.customerID,
  });

  factory AddressModel.fromJson(Map<String, dynamic> json) {
    return AddressModel(
      addressID: json['addressID'],
      addressDescription: json['addressDescription'],
      customerID: json['customerDTO']['customerID'],
    );
  }
}
