import 'dart:convert';

import 'package:constructin/model/team_model.dart';

CommentModel commentModelFromJson(String str) =>
    CommentModel.fromJson(json.decode(str));

String commentModelToJson(CommentModel data) => json.encode(data.toJson());

class CommentModel {
  CommentModel({
    this.data,
    this.success,
    this.message,
  });

  List<CommentData>? data;
  bool? success;
  String? message;

  factory CommentModel.fromJson(Map<String, dynamic> json) => CommentModel(
        data: List<CommentData>.from(
            json["data"].map((x) => CommentData.fromJson(x))),
        success: json["success"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data!.map((x) => x.toJson())),
        "success": success,
        "message": message,
      };
}

class CommentData {
  CommentData({
    this.id,
    this.registerUserId,
    this.projectId,
    this.taskId,
    this.issueId,
    this.image,
    this.comment,
    this.deletedAt,
    this.createdAt,
    this.updatedAt,
    this.members,
  });

  int? id;
  int? registerUserId;
  int? projectId;
  String? taskId;
  int? issueId;
  dynamic image;
  String? comment;
  dynamic deletedAt;
  String? createdAt;
  String? updatedAt;
  dynamic members;

  factory CommentData.fromJson(Map<String, dynamic> json) => CommentData(
        id: json["id"],
        registerUserId: json["registerUserId"],
        projectId: json["projectId"],
        taskId: json["taskId"],
        issueId: json["issueId"],
        image: json["image"],
        comment: json["comment"],
        deletedAt: json["deleted_at"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
        members: json["members"] == null
            ? null
            : TeamDetails.fromJson(json["members"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "registerUserId": registerUserId,
        "projectId": projectId,
        "taskId": taskId,
        "issueId": issueId,
        "image": image,
        "comment": comment,
        "deleted_at": deletedAt,
        "created_at": createdAt,
        "updated_at": updatedAt,
        "members": members?.toJson(),
      };
}
