import 'dart:convert';

TaskCategoryModel taskCategoryModelFromJson(String str) =>
    TaskCategoryModel.fromJson(json.decode(str));

String taskCategoryModelToJson(TaskCategoryModel data) =>
    json.encode(data.toJson());

class TaskCategoryModel {
  TaskCategoryModel({
    this.data,
    this.success,
    this.message,
  });

  List<TaskCategoryData>? data;
  bool? success;
  String? message;

  factory TaskCategoryModel.fromJson(Map<String, dynamic> json) =>
      TaskCategoryModel(
        data: List<TaskCategoryData>.from(
            json["data"].map((x) => TaskCategoryData.fromJson(x))),
        success: json["success"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data!.map((x) => x.toJson())),
        "success": success,
        "message": message,
      };
}

class TaskCategoryData {
  TaskCategoryData({
    this.id,
    this.title,
    this.registerUserId,
    this.deletedAt,
    this.createdAt,
    this.updatedAt,
  });

  int? id;
  String? title;
  dynamic registerUserId;
  dynamic deletedAt;
  dynamic createdAt;
  dynamic updatedAt;

  factory TaskCategoryData.fromJson(Map<String, dynamic> json) =>
      TaskCategoryData(
        id: json["id"],
        title: json["title"],
        registerUserId: json["registerUserId"],
        deletedAt: json["deleted_at"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "registerUserId": registerUserId,
        "deleted_at": deletedAt,
        "created_at": createdAt,
        "updated_at": updatedAt,
      };
}
