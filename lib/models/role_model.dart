class RoleModel {
  int roleID;
  String roleName;

  RoleModel({
    required this.roleID,
    required this.roleName,
  });

  factory RoleModel.fromJson(Map<dynamic, dynamic> json) {
    return RoleModel(
      roleID: json['roleID'],
      roleName: json['roleName'],
    );
  }

  Map<dynamic, dynamic> toJson() {
    return {
      'roleID': roleID,
      'roleName': roleName,
    };
  }
}
