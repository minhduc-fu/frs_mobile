class OrderBuyModel {
  int orderBuyID;
  double total;
  double shippingFee;
  double totalBuyPriceProduct;
  String customerAddress;
  String status;
  DateTime dateOrder;
  int customerID;
  int productownerID;
  String customerName;
  String productOwnerName;

  OrderBuyModel({
    required this.orderBuyID,
    required this.total,
    required this.shippingFee,
    required this.totalBuyPriceProduct,
    required this.customerAddress,
    required this.status,
    required this.dateOrder,
    required this.customerID,
    required this.productownerID,
    required this.customerName,
    required this.productOwnerName,
  });

  factory OrderBuyModel.fromJson(Map<String, dynamic> json) {
    return OrderBuyModel(
      orderBuyID: json['orderBuyID'],
      total: json['total'].toDouble(),
      shippingFee: json['shippingFee'].toDouble(),
      totalBuyPriceProduct: json['totalBuyPriceProduct'].toDouble(),
      customerAddress: json['customerAddress'],
      status: json['status'],
      dateOrder: DateTime(
        json['dateOrder'][0],
        json['dateOrder'][1],
        json['dateOrder'][2],
      ),
      customerID: json['customerID'],
      productownerID: json['productownerID'],
      customerName: json['customerName'],
      productOwnerName: json['productOwnerName'],
    );
  }
}
