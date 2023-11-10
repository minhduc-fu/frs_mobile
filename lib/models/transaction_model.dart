class TransactionModel {
  final int transactionHistoryID;
  final String transactionType;
  final double amount;
  final String description;
  final DateTime transactionDate;

  TransactionModel({
    required this.transactionHistoryID,
    required this.transactionType,
    required this.amount,
    required this.description,
    required this.transactionDate,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      transactionHistoryID: json['transactionHistoryID'],
      transactionType: json['transactionType'],
      amount: json['amount'],
      description: json['description'],
      transactionDate: DateTime(
        json['transactionDate'][0],
        json['transactionDate'][1],
        json['transactionDate'][2],
      ),
    );
  }
}
