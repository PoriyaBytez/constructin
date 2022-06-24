import 'dart:convert';

IssueModel issueModelFromJson(String str) =>
    IssueModel.fromJson(json.decode(str));

String issueModelToJson(IssueModel data) => json.encode(data.toJson());

class IssueModel {
  IssueModel({
    this.data,
    this.success,
    this.message,
  });

  List<Datum>? data;
  bool? success;
  String? message;

  factory IssueModel.fromJson(Map<String, dynamic> json) => IssueModel(
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
        success: json["success"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data!.map((x) => x.toJson())),
        "success": success,
        "message": message,
      };
}

class Datum {
  Datum({
    this.id,
    this.registerUserId,
    this.projectId,
    this.issueCategoryId,
    this.taskId,
    this.title,
    this.tag,
    this.issueStatus,
    this.deletedAt,
    this.createdAt,
    this.updatedAt,
  });

  int? id;
  int? registerUserId;
  int? projectId;
  int? issueCategoryId;
  dynamic taskId;
  String? title;
  String? tag;
  int? issueStatus;
  dynamic deletedAt;
  String? createdAt;
  String? updatedAt;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        registerUserId: json["registerUserId"],
        projectId: json["projectId"],
        issueCategoryId: json["issueCategoryId"],
        taskId: json["taskId"],
        title: json["title"],
        tag: json["tag"],
        issueStatus: json["issueStatus"],
        deletedAt: json["deleted_at"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "registerUserId": registerUserId,
        "projectId": projectId,
        "issueCategoryId": issueCategoryId,
        "taskId": taskId,
        "title": title,
        "tag": tag,
        "issueStatus": issueStatus,
        "deleted_at": deletedAt,
        "created_at": createdAt,
        "updated_at": updatedAt,
      };
}
