import 'dart:convert';

import 'package:constructin/model/comment_model.dart';
import 'package:constructin/model/task_model.dart';
import 'package:constructin/model/team_model.dart';

IssueModel issueModelFromJson(String str) =>
    IssueModel.fromJson(json.decode(str));

String issueModelToJson(IssueModel data) => json.encode(data.toJson());

class IssueModel {
  IssueModel({
    this.data,
    this.success,
    this.message,
  });

  List<IssueData>? data;
  bool? success;
  String? message;

  factory IssueModel.fromJson(Map<String, dynamic> json) => IssueModel(
        data: List<IssueData>.from(
            json["data"].map((x) => IssueData.fromJson(x))),
        success: json["success"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data!.map((x) => x.toJson())),
        "success": success,
        "message": message,
      };
}

class IssueData {
  IssueData({
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
    this.project,
    this.issueCategory,
    this.task,
    this.teamDetails,
    this.attachment,
    this.members,
    this.commentCount,
    this.status,
  });

  int? id;
  int? registerUserId;
  int? projectId;
  int? issueCategoryId;
  String? taskId;
  String? title;
  dynamic tag;
  int? issueStatus;
  dynamic deletedAt;
  DateTime? createdAt;
  DateTime? updatedAt;
  Project? project;
  IssueCategory? issueCategory;
  dynamic task;
  TeamDetails? teamDetails;
  List<CommentData>? attachment;
  List<TeamData>? members;
  int? commentCount;
  int? status;

  factory IssueData.fromJson(Map<String, dynamic> json) => IssueData(
        id: json["id"],
        registerUserId: json["registerUserId"],
        projectId: json["projectId"],
        issueCategoryId: json["issueCategoryId"],
        taskId: json["taskId"],
        title: json["title"],
        tag: json["tag"],
        issueStatus: json["issueStatus"],
        deletedAt: json["deleted_at"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        project: Project.fromJson(json["project"]),
        commentCount: json["comment_count"],
        status: json["status"],
        issueCategory: IssueCategory.fromJson(json["issue_category"]),
        task: json["task"] == null ? null : Task.fromJson(json["task"]),
        teamDetails: TeamDetails.fromJson(json["team_details"]),
        attachment: json["attachment"] == null
            ? null
            : List<CommentData>.from(
                json["attachment"].map((x) => CommentData.fromJson(x))),
        members: List<TeamData>.from(
            json["members"].map((x) => TeamData.fromJson(x))),
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
        "comment_count": commentCount,
        "status": status,
        "project": project!.toJson(),
        "issue_category": issueCategory!.toJson(),
        "task": task!.toJson(),
        "team_details": teamDetails!.toJson(),
        "attachment": List<dynamic>.from(attachment!.map((x) => x.toJson())),
        "members": List<dynamic>.from(members!.map((x) => x.toJson())),
      };
}

class IssueCategory {
  IssueCategory({
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
  String? createdAt;
  String? updatedAt;

  factory IssueCategory.fromJson(Map<String, dynamic> json) => IssueCategory(
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

class Project {
  Project({
    this.id,
    this.registerUserId,
    this.projectName,
    this.clientName,
    this.siteLocation,
    this.projectTypeId,
    this.startDate,
    this.endDate,
    this.saleValue,
    this.budget,
    this.deletedAt,
    this.createdAt,
    this.updatedAt,
  });

  int? id;
  int? registerUserId;
  String? projectName;
  String? clientName;
  String? siteLocation;
  int? projectTypeId;
  String? startDate;
  String? endDate;
  dynamic saleValue;
  dynamic budget;
  dynamic deletedAt;
  String? createdAt;
  String? updatedAt;

  factory Project.fromJson(Map<String, dynamic> json) => Project(
        id: json["id"],
        registerUserId: json["registerUserId"],
        projectName: json["projectName"],
        clientName: json["clientName"],
        siteLocation: json["siteLocation"],
        projectTypeId: json["projectTypeId"],
        startDate: json["startDate"],
        endDate: json["endDate"],
        saleValue: json["saleValue"],
        budget: json["budget"],
        deletedAt: json["deleted_at"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "registerUserId": registerUserId,
        "projectName": projectName,
        "clientName": clientName,
        "siteLocation": siteLocation,
        "projectTypeId": projectTypeId,
        "startDate": startDate,
        // "${startDate.year.toString().padLeft(4, '0')}-${startDate.month.toString().padLeft(2, '0')}-${startDate.day.toString().padLeft(2, '0')}",
        "endDate": endDate,
        // "${endDate.year.toString().padLeft(4, '0')}-${endDate.month.toString().padLeft(2, '0')}-${endDate.day.toString().padLeft(2, '0')}",
        "saleValue": saleValue,
        "budget": budget,
        "deleted_at": deletedAt,
        "created_at": createdAt,
        "updated_at": updatedAt,
      };
}

// class TeamDetails {
//   TeamDetails({
//     this.id,
//     this.image,
//     this.companyName,
//     this.currentRoleId,
//     this.name,
//     this.countryCode,
//     this.mobile,
//   });
//
//   int? id;
//   dynamic image;
//   dynamic companyName;
//   dynamic currentRoleId;
//   dynamic name;
//   String? countryCode;
//   String? mobile;
//
//   factory TeamDetails.fromJson(Map<String, dynamic> json) => TeamDetails(
//         id: json["id"],
//         image: json["image"],
//         companyName: json["companyName"],
//         currentRoleId: json["currentRoleId"],
//         name: json["name"],
//         countryCode: json["countryCode"],
//         mobile: json["mobile"],
//       );
//
//   Map<String, dynamic> toJson() => {
//         "id": id,
//         "image": image,
//         "companyName": companyName,
//         "currentRoleId": currentRoleId,
//         "name": name,
//         "countryCode": countryCode,
//         "mobile": mobile,
//       };
// }
