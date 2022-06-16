import 'dart:convert';

UnitModel unitModelFromJson(String str) => UnitModel.fromJson(json.decode(str));

String unitModelToJson(UnitModel data) => json.encode(data.toJson());

class UnitModel {
  UnitModel({
    this.data,
    this.success,
    this.message,
  });

  List<UnitData>? data;
  bool? success;
  String? message;

  factory UnitModel.fromJson(Map<String, dynamic> json) => UnitModel(
        data:
            List<UnitData>.from(json["data"].map((x) => UnitData.fromJson(x))),
        success: json["success"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data!.map((x) => x.toJson())),
        "success": success,
        "message": message,
      };
}

class UnitData {
  UnitData({
    this.id,
    this.title,
    this.measurementType,
    this.deletedAt,
    this.createdAt,
    this.updatedAt,
  });

  int? id;
  String? title;
  int? measurementType;
  dynamic deletedAt;
  dynamic createdAt;
  dynamic updatedAt;

  factory UnitData.fromJson(Map<String, dynamic> json) => UnitData(
        id: json["id"],
        title: json["title"],
        measurementType: json["measurementType"],
        deletedAt: json["deleted_at"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "measurementType": measurementType,
        "deleted_at": deletedAt,
        "created_at": createdAt,
        "updated_at": updatedAt,
      };
}
