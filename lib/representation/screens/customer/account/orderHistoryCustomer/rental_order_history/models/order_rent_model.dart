class OrderRentModel {
  int orderRentID;
  double totalRentPriceProduct;
  double shippingFee;
  double total;
  String customerAddress;
  double cocMoneyTotal;
  String status;
  DateTime dateOrder;
  String productOwnerName;
  String customerName;
  int customerID;
  int productownerID;

  OrderRentModel({
    required this.orderRentID,
    required this.totalRentPriceProduct,
    required this.shippingFee,
    required this.total,
    required this.customerAddress,
    required this.cocMoneyTotal,
    required this.status,
    required this.dateOrder,
    required this.productOwnerName,
    required this.customerName,
    required this.customerID,
    required this.productownerID,
  });

  factory OrderRentModel.fromJson(Map<String, dynamic> json) {
    return OrderRentModel(
      orderRentID: json['orderRentID'],
      totalRentPriceProduct: json['totalRentPriceProduct'].toDouble(),
      shippingFee: json['shippingFee'].toDouble(),
      total: json['total'].toDouble(),
      customerAddress: json['customerAddress'],
      cocMoneyTotal: json['cocMoneyTotal'].toDouble(),
      status: json['status'],
      dateOrder: DateTime(
        json['dateOrder'][0],
        json['dateOrder'][1],
        json['dateOrder'][2],
      ),
      productOwnerName: json['productownerName'],
      customerName: json['customerName'],
      customerID: json['customerID'],
      productownerID: json['productownerID'],
      // customerName: json['customerName'],
      // productOwnerName: json['productOwnerName'],
    );
  }
}
