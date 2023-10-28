class ProductImageModel {
  final int productImgID;
  final String imgUrl;
  final int productID;

  ProductImageModel({
    required this.productImgID,
    required this.imgUrl,
    required this.productID,
  });

  factory ProductImageModel.fromJson(Map<String, dynamic> json) {
    return ProductImageModel(
      productImgID: json['productImgID'],
      imgUrl: json['imgUrl'],
      productID: json['productID'],
    );
  }
}
