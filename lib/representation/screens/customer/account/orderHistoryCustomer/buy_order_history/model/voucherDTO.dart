class VoucherDTO {
  int voucherID;
  String voucherCode;
  String voucherName;

  VoucherDTO({
    required this.voucherID,
    required this.voucherCode,
    required this.voucherName,
  });

  factory VoucherDTO.fromJson(Map<String, dynamic> json) {
    return VoucherDTO(
      voucherID: json['voucherID'],
      voucherCode: json['voucherCode'],
      voucherName: json['voucherName'],
    );
  }
}
