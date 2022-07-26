import 'dart:convert';

TaskDetailsModel taskDetailsModelFromJson(String str) =>
    TaskDetailsModel.fromJson(json.decode(str));

String taskDetailsModelToJson(TaskDetailsModel data) =>
    json.encode(data.toJson());

class TaskDetailsModel {
  TaskDetailsModel({
    this.data,
    this.success,
    this.message,
  });

  TaskDetailsData? data;
  bool? success;
  String? message;

  factory TaskDetailsModel.fromJson(Map<String, dynamic> json) =>
      TaskDetailsModel(
        data: TaskDetailsData.fromJson(json["data"]),
        success: json["success"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "data": data!.toJson(),
        "success": success,
        "message": message,
      };
}

class TaskDetailsData {
  TaskDetailsData(
      {this.id,
      this.registerUserId,
      this.projectId,
      this.taskId,
      this.todayProgress,
      this.noOfGang,
      this.attendees,
      this.attendeesSkilled,
      this.attendeesSemiSkilled,
      this.attendeesUnskilled,
      this.date,
      this.remark,
      this.deletedAt,
      this.createdAt,
      this.updatedAt,
      this.unitTitle,
      this.taskMembers,
      this.workCompleted,
      this.issues_count,
      this.taskProgress,
      this.task
      });

  int? id;
  int? registerUserId;
  int? projectId;
  int? taskId;
  String? todayProgress;
  String? noOfGang;
  String? attendees;
  dynamic attendeesSkilled;
  dynamic attendeesSemiSkilled;
  dynamic attendeesUnskilled;
  String? date;
  String? remark;
  dynamic deletedAt;
  String? createdAt;
  String? updatedAt;
  int? taskMembers;
  int? workCompleted;
  dynamic unitTitle;
  int? issues_count;
  String? taskProgress;
  dynamic task;

  factory TaskDetailsData.fromJson(Map<String, dynamic> json) =>
      TaskDetailsData(
        id: json["id"],
        registerUserId: json["registerUserId"],
        projectId: json["projectId"],
        taskId: json["taskId"],
        todayProgress: json["todayProgress"],
        noOfGang: json["noOfGang"],
        attendees: json["attendees"],
        attendeesSkilled: json["attendeesSkilled"],
        attendeesSemiSkilled: json["attendeesSemiSkilled"],
        attendeesUnskilled: json["attendeesUnskilled"],
        date: json["date"],
        remark: json["remark"],
        deletedAt: json["deleted_at"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
        unitTitle: json["unitTitle"],
        taskMembers: json["taskMembers"],
        workCompleted: json["workCompleted"],
        issues_count: json["issues_count"],
        taskProgress: json["taskProgress"],
        task:json["task"] == null ? null : Data.fromJson(json["task"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "registerUserId": registerUserId,
        "projectId": projectId,
        "taskId": taskId,
        "todayProgress": todayProgress,
        "noOfGang": noOfGang,
        "attendees": attendees,
        "attendeesSkilled": attendeesSkilled,
        "attendeesSemiSkilled": attendeesSemiSkilled,
        "attendeesUnskilled": attendeesUnskilled,
        "date": date,
        // "date": "${date!.year.toString().padLeft(4, '0')}-${date!.month.toString().padLeft(2, '0')}-${date!.day.toString().padLeft(2, '0')}",
        "remark": remark,
        "deleted_at": deletedAt,
        "created_at": createdAt,
        "updated_at": updatedAt,
        "unitTitle": unitTitle,
        "issues_count": issues_count,
        "task": task,
      };
}

class Data {
  Data({
    this.startDate,
    this.endDate,
  });


  String? startDate;
  String? endDate;


  factory Data.fromJson(Map<String, dynamic> json) => Data(
        startDate: json["startDate"],
        endDate: json["endDate"]
      );

  Map<String, dynamic> toJson() => {
        "startDate": startDate,
        "endDate": endDate,
      };
}
