import 'dart:convert';

ProjectModel projectModelFromJson(String str) =>
    ProjectModel.fromJson(json.decode(str));

String projectModelToJson(ProjectModel data) => json.encode(data.toJson());

class ProjectModel {
  ProjectModel({
    this.data,
    this.success,
    this.message,
  });

  List<ProjectData>? data;
  bool? success;
  String? message;

  factory ProjectModel.fromJson(Map<String, dynamic> json) => ProjectModel(
        data: List<ProjectData>.from(
            json["data"].map((x) => ProjectData.fromJson(x))),
        success: json["success"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data!.map((x) => x.toJson())),
        "success": success,
        "message": message,
      };
}

class ProjectData {
  ProjectData({
    this.id,
    this.registerUserId,
    this.projectId,
    this.addBy,
    this.projectRights,
    this.taskRight,
    this.issuesRight,
    this.deletedAt,
    this.createdAt,
    this.updatedAt,
    this.issues_count,
    this.issues_count_seven_days,
    this.members_count,
    this.projectDetail,
    this.projectProgress,
    this.projectProgressSevenDays,
  });

  int? id;
  int? registerUserId;
  int? projectId;
  int? addBy;
  dynamic projectRights;
  dynamic taskRight;
  dynamic issuesRight;
  dynamic deletedAt;
  dynamic createdAt;
  dynamic updatedAt;
  int? issues_count;
  int? issues_count_seven_days;
  int? members_count;
  ProjectDetail? projectDetail;
  String? projectProgress;
  String? projectProgressSevenDays;

  factory ProjectData.fromJson(Map<String, dynamic> json) => ProjectData(
        id: json["id"],
        registerUserId: json["registerUserId"],
        projectId: json["projectId"],
        addBy: json["addBy"],
        projectRights: json["projectRights"],
        taskRight: json["taskRight"],
        issuesRight: json["issuesRight"],
        deletedAt: json["deleted_at"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
        issues_count: json["issues_count"],
        issues_count_seven_days: json["issues_count_seven_days"],
        members_count: json["members_count"],
        projectProgress: json["projectProgress"],
        projectProgressSevenDays: json["projectProgressSevenDays"],
        projectDetail: ProjectDetail.fromJson(json["project_detail"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "registerUserId": registerUserId,
        "projectId": projectId,
        "addBy": addBy,
        "projectRights": projectRights,
        "taskRight": taskRight,
        "issuesRight": issuesRight,
        "deleted_at": deletedAt,
        "created_at": createdAt,
        "updated_at": updatedAt,
        "issues_count": issues_count,
        "issues_count_seven_days": issues_count_seven_days,
        "members_count": members_count,
        "projectProgress": projectProgress,
        "projectProgressSevenDays": projectProgressSevenDays,
        "project_detail": projectDetail?.toJson(),
      };
}

class ProjectDetail {
  ProjectDetail({
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
  String? saleValue;
  String? budget;
  dynamic deletedAt;
  String? createdAt;
  String? updatedAt;

  factory ProjectDetail.fromJson(Map<String, dynamic> json) => ProjectDetail(
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
        "saleValue": saleValue == null ? null : saleValue,
        "budget": budget == null ? null : budget,
        "deleted_at": deletedAt,
        "created_at": createdAt,
        "updated_at": updatedAt,
      };
}
