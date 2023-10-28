import 'customer_model.dart';
import 'productOwner_model.dart';
import 'role_model.dart';

class UserModel {
  int accountID;
  String email;
  String password;
  String status;
  RoleModel role;
  CustomerModel? customer;
  ProductOwnerModel? productOwner;

  UserModel({
    required this.accountID,
    required this.password,
    required this.email,
    required this.role,
    required this.status,
    this.customer,
    this.productOwner,
  });

  factory UserModel.fromJson(Map<dynamic, dynamic> json) {
    return UserModel(
      accountID: json['accountID'],
      password: json['password'],
      email: json['email'],
      role: RoleModel.fromJson(json['role']),
      status: json['status'],
      customer: json['customer'] != null
          ? CustomerModel.fromJson(json['customer'])
          : null,
      productOwner: json['productowner'] != null
          ? ProductOwnerModel.fromJson(json['productowner'])
          : null,
    );
  }

  Map<dynamic, dynamic> toJson() {
    return {
      'accountID': accountID,
      'password': password,
      'email': email,
      'status': status,
      'role': role.toJson(),
      'customer': customer?.toJson(),
      'productowner': productOwner?.toJson(),
    };
  }

  UserModel copyWith({
    int? accountID,
    String? password,
    String? email,
    String? status,
    RoleModel? role,
    CustomerModel? customer,
    ProductOwnerModel? productOwner,
  }) {
    return UserModel(
      accountID: accountID ?? this.accountID,
      password: password ?? this.password,
      email: email ?? this.email,
      status: status ?? this.status,
      role: role ?? this.role,
      customer: customer ?? this.customer,
      productOwner: productOwner ?? this.productOwner,
    );
  }
}
