import 'dart:convert';

import 'package:constructin/model/issue_model.dart';
import 'package:constructin/model/task_details_model.dart';
import 'package:constructin/model/task_model.dart';

TaskReview taskReviewFromJson(String str) =>
    TaskReview.fromJson(json.decode(str));

String taskReviewToJson(TaskReview data) => json.encode(data.toJson());

class TaskReview {
  TaskReview({
    this.data,
    this.success,
    this.message,
  });

  TaskReviewData? data;
  bool? success;
  String? message;

  factory TaskReview.fromJson(Map<String, dynamic> json) => TaskReview(
        data: TaskReviewData.fromJson(json["data"]),
        success: json["success"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "data": data!.toJson(),
        "success": success,
        "message": message,
      };
}

class TaskReviewData {
  TaskReviewData({
    this.id,
    this.registerUserId,
    this.projectId,
    this.taskCategoryId,
    this.title,
    this.startDate,
    this.endDate,
    this.totalWork,
    this.unitId,
    this.deletedAt,
    this.createdAt,
    this.updatedAt,
    this.issuesCount,
    this.workCompleted,
    this.taskProgress,
    this.taskUnit,
    this.issues,
    this.attachment,
    this.dataTaskProgress,
  });

  int? id;
  int? registerUserId;
  int? projectId;
  int? taskCategoryId;
  String? title;
  String? startDate;
  String? endDate;
  int? totalWork;
  int? unitId;
  dynamic deletedAt;
  String? createdAt;
  String? updatedAt;
  int? issuesCount;
  int? workCompleted;
  String? taskProgress;
  Task? taskUnit;
  List<IssueData>? issues;
  List<dynamic>? attachment;
  List<TaskDetailsData>? dataTaskProgress = [];

  factory TaskReviewData.fromJson(Map<String, dynamic> json) => TaskReviewData(
        id: json["id"],
        registerUserId: json["registerUserId"],
        projectId: json["projectId"],
        taskCategoryId: json["taskCategoryId"],
        title: json["title"],
        startDate: json["startDate"],
        endDate: json["endDate"],
        totalWork: json["totalWork"],
        unitId: json["unitId"],
        deletedAt: json["deleted_at"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
        issuesCount: json["issues_count"],
        workCompleted: json["workCompleted"],
        taskProgress: json["taskProgress"],
        taskUnit: Task.fromJson(json["task_unit"]),
        issues: json["issues"] == []
            ? []
            : List<IssueData>.from(
                json["issues"].map((x) => IssueData.fromJson(x))),
        attachment: json["attachment"] == null
            ? null
            : List<Attachment>.from(
                json["attachment"].map((x) => Attachment.fromJson(x))),
        dataTaskProgress: List<TaskDetailsData>.from(
            json["task_progress"].map((x) => TaskDetailsData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "registerUserId": registerUserId,
        "projectId": projectId,
        "taskCategoryId": taskCategoryId,
        "title": title,
        "startDate": startDate,
        "endDate": endDate,
        "totalWork": totalWork,
        "unitId": unitId,
        "deleted_at": deletedAt,
        "created_at": createdAt,
        "updated_at": updatedAt,
        "issues_count": issuesCount,
        "workCompleted": workCompleted,
        "taskProgress": taskProgress,
        "task_unit": taskUnit!.toJson(),
        "issues": List<dynamic>.from(issues!.map((x) => x.toJson())),
        "attachment": List<Attachment>.from(attachment!.map((x) => x)),
        "task_progress":
            List<dynamic>.from(dataTaskProgress!.map((x) => x.toJson())),
      };
}

class Attachment {
  Attachment({
    this.id,
    this.registerUserId,
    this.projectId,
    this.taskId,
    this.image,
    this.deletedAt,
    this.createdAt,
    this.updatedAt,
  });

  int? id;
  int? registerUserId;
  int? projectId;
  int? taskId;
  String? image;
  dynamic deletedAt;
  String? createdAt;
  String? updatedAt;

  factory Attachment.fromJson(Map<String, dynamic> json) => Attachment(
        id: json["id"],
        registerUserId: json["registerUserId"],
        projectId: json["projectId"],
        taskId: json["taskId"],
        image: json["image"],
        deletedAt: json["deleted_at"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "registerUserId": registerUserId,
        "projectId": projectId,
        "taskId": taskId,
        "image": image,
        "deleted_at": deletedAt,
        "created_at": createdAt,
        "updated_at": updatedAt,
      };
}
