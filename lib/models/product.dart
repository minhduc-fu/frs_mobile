class Product {
  String productName;
  double productPrice;
  String productImg;
  String productRating;
  String productBrand;
  String productCategory;

  Product({
    required this.productName,
    required this.productPrice,
    required this.productImg,
    required this.productRating,
    required this.productBrand,
    required this.productCategory,
  });

  String get _productName => productName;
  double get _productPrice => productPrice;
  String get _productImg => productImg;
  String get _productRating => productRating;
  String get _productBrand => productBrand;
  String get _productCategory => productCategory;
}
