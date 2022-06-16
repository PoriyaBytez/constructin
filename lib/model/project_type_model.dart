import 'dart:convert';

ProjectTypeModel projectTypeFromJson(String str) =>
    ProjectTypeModel.fromJson(json.decode(str));

String projectTypeToJson(ProjectTypeModel data) => json.encode(data.toJson());

class ProjectTypeModel {
  ProjectTypeModel({
    this.data,
    this.success,
    this.message,
  });

  List<ProjectType>? data;
  bool? success;
  String? message;

  factory ProjectTypeModel.fromJson(Map<String, dynamic> json) =>
      ProjectTypeModel(
        data: List<ProjectType>.from(
            json["data"].map((x) => ProjectType.fromJson(x))),
        success: json["success"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "data": List<ProjectType>.from(data!.map((x) => x.toJson())),
        "success": success,
        "message": message,
      };
}

class ProjectType {
  ProjectType({
    this.id,
    this.title,
  });

  int? id;
  String? title;

  factory ProjectType.fromJson(Map<String, dynamic> json) => ProjectType(
        id: json["id"],
        title: json["title"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
      };
}
