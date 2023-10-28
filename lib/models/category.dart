class CategoryModel {
  int categoryID;
  String categoryName;

  CategoryModel({
    required this.categoryID,
    required this.categoryName,
  });
  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      categoryID: json['categoryID'],
      categoryName: json['categoryName'],
    );
  }
}
