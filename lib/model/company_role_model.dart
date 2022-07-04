import 'dart:convert';

CompanyRoleModel companyRoleModelFromJson(String str) =>
    CompanyRoleModel.fromJson(json.decode(str));

String companyRoleModelToJson(CompanyRoleModel data) =>
    json.encode(data.toJson());

class CompanyRoleModel {
  CompanyRoleModel({
    this.data,
    this.success,
    this.message,
  });

  List<CompanyRole>? data;
  bool? success;
  String? message;

  factory CompanyRoleModel.fromJson(Map<String, dynamic> json) =>
      CompanyRoleModel(
        data: List<CompanyRole>.from(
            json["data"].map((x) => CompanyRole.fromJson(x))),
        success: json["success"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data!.map((x) => x.toJson())),
        "success": success,
        "message": message,
      };
}

class CompanyRole {
  CompanyRole({
    this.id,
    this.role,
    this.deletedAt,
    this.createdAt,
    this.updatedAt,
  });

  int? id;
  String? role;
  dynamic deletedAt;
  dynamic createdAt;
  dynamic updatedAt;

  factory CompanyRole.fromJson(Map<String, dynamic> json) => CompanyRole(
        id: json["id"],
        role: json["role"],
        deletedAt: json["deleted_at"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "role": role,
        "deleted_at": deletedAt,
        "created_at": createdAt,
        "updated_at": updatedAt,
      };
}
