import 'dart:convert';

TaskModel taskModelFromJson(String str) => TaskModel.fromJson(json.decode(str));

String taskModelToJson(TaskModel data) => json.encode(data.toJson());

class TaskModel {
  TaskModel({
    this.data,
    this.success,
    this.message,
  });

  List<TaskDetailsList>? data;
  bool? success;
  String? message;

  factory TaskModel.fromJson(Map<String, dynamic> json) => TaskModel(
        data: List<TaskDetailsList>.from(
            json["data"].map((x) => TaskDetailsList.fromJson(x))),
        success: json["success"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data!.map((x) => x.toJson())),
        "success": success,
        "message": message,
      };
}

class TaskDetailsList {
  TaskDetailsList(
      {this.id,
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
      this.project,
      this.taskCategory,
      this.taskUnit,
      this.taskMembers,
      this.workCompleted});

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
  Project? project;
  dynamic taskCategory;
  dynamic taskUnit;
  int? taskMembers;
  int? workCompleted;

  factory TaskDetailsList.fromJson(Map<String, dynamic> json) =>
      TaskDetailsList(
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
        project:
            json["project"] == null ? null : Project.fromJson(json["project"]),
        taskCategory: json["task_category"] == null
            ? null
            : Task.fromJson(json["task_category"]),
        taskUnit:
            json["task_unit"] == null ? null : Task.fromJson(json["task_unit"]),
        taskMembers: json["taskMembers"],
        workCompleted: json["workCompleted"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "registerUserId": registerUserId,
        "projectId": projectId,
        "taskCategoryId": taskCategoryId,
        "title": title,
        "startDate": startDate,
        // "${startDate.year.toString().padLeft(4, '0')}-${startDate.month.toString().padLeft(2, '0')}-${startDate.day.toString().padLeft(2, '0')}",
        "endDate": endDate,
        // "${endDate.year.toString().padLeft(4, '0')}-${endDate.month.toString().padLeft(2, '0')}-${endDate.day.toString().padLeft(2, '0')}",
        "totalWork": totalWork,
        "unitId": unitId,
        "deleted_at": deletedAt,
        "created_at": createdAt,
        "updated_at": updatedAt,
        "project": project?.toJson(),
        "task_category": taskCategory?.toJson(),
        "task_unit": taskUnit?.toJson(),
        "taskMembers": taskMembers,
        "workCompleted": workCompleted
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
  DateTime? startDate;
  DateTime? endDate;
  dynamic saleValue;
  dynamic budget;
  dynamic deletedAt;
  DateTime? createdAt;
  DateTime? updatedAt;

  factory Project.fromJson(Map<String, dynamic> json) => Project(
        id: json["id"],
        registerUserId: json["registerUserId"],
        projectName: json["projectName"],
        clientName: json["clientName"],
        siteLocation: json["siteLocation"],
        projectTypeId: json["projectTypeId"],
        startDate: DateTime.parse(json["startDate"]),
        endDate: DateTime.parse(json["endDate"]),
        saleValue: json["saleValue"],
        budget: json["budget"],
        deletedAt: json["deleted_at"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
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

class Task {
  Task({
    this.id,
    this.title,
    this.registerUserId,
    this.deletedAt,
    this.createdAt,
    this.updatedAt,
    this.measurementType,
  });

  int? id;
  String? title;
  dynamic registerUserId;
  dynamic deletedAt;
  dynamic createdAt;
  dynamic updatedAt;
  int? measurementType;

  factory Task.fromJson(Map<String, dynamic> json) => Task(
        id: json["id"],
        title: json["title"],
        registerUserId: json["registerUserId"],
        deletedAt: json["deleted_at"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
        measurementType:
            json["measurementType"] == null ? null : json["measurementType"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "registerUserId": registerUserId,
        "deleted_at": deletedAt,
        "created_at": createdAt,
        "updated_at": updatedAt,
        "measurementType": measurementType == null ? null : measurementType,
      };
}
