import 'dart:convert';

UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));

String userModelToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
  UserModel({
    this.data,
    this.success,
    this.message,
  });

  UserData? data;
  bool? success;
  String? message;

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        data: UserData.fromJson(json["data"]),
        success: json["success"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "data": data?.toJson(),
        "success": success,
        "message": message,
      };
}

class UserData {
  UserData({
    this.id,
    this.name,
    this.countryCode,
    this.mobile,
    this.accessToken,
    this.companyName,
    this.currentRoleId,
    this.image,
    this.basePath,
  });

  int? id;
  String? image;
  String? companyName;
  int? currentRoleId;
  dynamic name;
  String? countryCode;
  String? mobile;
  String? accessToken;
  String? basePath;

  factory UserData.fromJson(Map<String, dynamic> json) => UserData(
      id: json["id"],
      name: json["name"],
      countryCode: json["countryCode"],
      mobile: json["mobile"],
      accessToken: json["access_token"],
      companyName: json["companyName"],
      image: json["image"],
      currentRoleId: json["currentRoleId"],
      basePath: json["basePath"]);

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "countryCode": countryCode,
        "mobile": mobile,
        "access_token": accessToken,
        "companyName": companyName,
        "image": image,
        "currentRoleId": currentRoleId,
        "basePath": basePath
      };
}
