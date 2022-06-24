// To parse this JSON data, do
//
//     final taskImageModel = taskImageModelFromJson(jsonString);

import 'dart:convert';

TaskImageModel taskImageModelFromJson(String str) =>
    TaskImageModel.fromJson(json.decode(str));

String taskImageModelToJson(TaskImageModel data) => json.encode(data.toJson());

class TaskImageModel {
  TaskImageModel({
    this.data,
    this.success,
    this.message,
  });

  List<TaskImageData>? data;
  bool? success;
  String? message;

  factory TaskImageModel.fromJson(Map<String, dynamic> json) => TaskImageModel(
        data: List<TaskImageData>.from(
            json["data"].map((x) => TaskImageData.fromJson(x))),
        success: json["success"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data!.map((x) => x.toJson())),
        "success": success,
        "message": message,
      };
}

class TaskImageData {
  TaskImageData({
    this.id,
    this.registerUserId,
    this.projectId,
    this.taskId,
    this.issueId,
    this.image,
    this.deletedAt,
    this.createdAt,
    this.updatedAt,
  });

  int? id;
  int? registerUserId;
  int? projectId;
  int? taskId;
  int? issueId;
  String? image;
  dynamic deletedAt;
  dynamic createdAt;
  dynamic updatedAt;

  factory TaskImageData.fromJson(Map<String, dynamic> json) => TaskImageData(
        id: json["id"],
        registerUserId: json["registerUserId"],
        projectId: json["projectId"],
        taskId: json["taskId"],
        issueId: json["issueId"],
        image: json["image"] == null ? null : json["image"],
        deletedAt: json["deleted_at"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "registerUserId": registerUserId,
        "projectId": projectId,
        "taskId": taskId,
        "issueId": issueId,
        "image": image == null ? null : image,
        "deleted_at": deletedAt,
        "created_at": createdAt,
        "updated_at": updatedAt,
      };
}
