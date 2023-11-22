class VoucherModel {
  int voucherID;
  String voucherCode;
  String voucherName;
  DateTime createdDate;
  DateTime startDate;
  DateTime endDate;
  String description;
  int maxDiscount;
  int quantity;
  int discountAmount;
  int voucherTypeID;
  int productOwnerID;
  String status;

  VoucherModel({
    required this.voucherID,
    required this.voucherCode,
    required this.voucherName,
    required this.createdDate,
    required this.startDate,
    required this.endDate,
    required this.description,
    required this.maxDiscount,
    required this.quantity,
    required this.discountAmount,
    required this.voucherTypeID,
    required this.productOwnerID,
    required this.status,
  });

  factory VoucherModel.fromJson(Map<String, dynamic> json) {
    return VoucherModel(
      voucherID: json['voucherID'],
      voucherCode: json['voucherCode'],
      voucherName: json['voucherName'],
      createdDate: DateTime(json['createdDate'][0], json['createdDate'][1],
          json['createdDate'][2]),
      startDate: DateTime(
          json['startDate'][0], json['startDate'][1], json['startDate'][2]),
      endDate:
          DateTime(json['endDate'][0], json['endDate'][1], json['endDate'][2]),
      description: json['description'],
      maxDiscount: json['maxDiscount'],
      quantity: json['quantity'],
      discountAmount: json['discountAmount'],
      voucherTypeID: json['voucherTypeID'],
      productOwnerID: json['productOwnerID'],
      status: json['status'],
    );
  }
}
