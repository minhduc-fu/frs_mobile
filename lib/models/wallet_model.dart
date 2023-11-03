class WalletModel {
  int walletID;
  double balance;
  DateTime createdDate;
  int accountID;

  WalletModel({
    required this.walletID,
    required this.balance,
    required this.createdDate,
    required this.accountID,
  });

  factory WalletModel.fromJson(Map<String, dynamic> json) {
    return WalletModel(
      walletID: json['walletID'],
      balance: json['balance'].toDouble(), // Chuyển đổi thành kiểu double
      createdDate: DateTime.utc(
        json['createdDate'][0], // Năm
        json['createdDate'][1], // Tháng
        json['createdDate'][2], // Ngày
      ),
      accountID: json['accountID'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'walletID': walletID,
      'balance': balance,
      'createdDate': [
        createdDate.year,
        createdDate.month,
        createdDate.day,
      ],
      'accountID': accountID,
    };
  }
}
