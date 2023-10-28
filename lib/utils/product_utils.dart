import '../models/product.dart';
import '../models/product_owner.dart';

String getProductOwnerFullName(
    int productOwnerID, List<ProductOwner> allProductOwners) {
  // allProductOwners.firstWhere...  tìm ProductOwner trong allProductOwners mà có productOwnerID trùng
  // với giá trị được truyền vào.
  // nếu không tìm thấy orElse sẽ được hiển thị
  final productOwner = allProductOwners.firstWhere(
      (owner) => owner.productOwnerID == productOwnerID,
      orElse: () =>
          ProductOwner(fullName: 'Unknown', phone: '', productOwnerID: -1));
  return productOwner.fullName;
}

ProductOwner getOwnerOfProduct(Product product, List<ProductOwner> owners) {
  final owner = owners.firstWhere(
      (owner) => owner.productOwnerID == product.productOwnerID,
      orElse: () => ProductOwner(
          productOwnerID: -1, fullName: 'UnKnown', phone: 'UnKnown'));
  return owner;
}
