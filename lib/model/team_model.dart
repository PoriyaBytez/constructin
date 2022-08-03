import 'dart:convert';

TeamModel teamModelFromJson(String str) => TeamModel.fromJson(json.decode(str));

String teamModelToJson(TeamModel data) => json.encode(data.toJson());

class TeamModel {
  TeamModel({
    this.data,
    this.success,
    this.message,
  });

  List<TeamData>? data;
  bool? success;
  String? message;

  factory TeamModel.fromJson(Map<String, dynamic> json) => TeamModel(
        data:
            List<TeamData>.from(json["data"].map((x) => TeamData.fromJson(x))),
        success: json["success"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data!.map((x) => x.toJson())),
        "success": success,
        "message": message,
      };
}

class TeamData {
  TeamData({
    this.id,
    this.registerUserId,
    this.projectId,
    this.addBy,
    this.projectRights,
    this.taskRight,
    this.issuesRight,
    this.joined,
    this.deletedAt,
    this.createdAt,
    this.updatedAt,
    this.rights,
    this.teamDetails,
  });

  int? id;
  int? registerUserId;
  int? projectId;
  int? addBy;
  dynamic projectRights;
  dynamic taskRight;
  dynamic issuesRight;
  int? joined;
  dynamic deletedAt;
  dynamic createdAt;
  dynamic updatedAt;
  List<Right>? rights;
  TeamDetails? teamDetails;

  factory TeamData.fromJson(Map<String, dynamic> json) => TeamData(
        id: json["id"],
        registerUserId: json["registerUserId"],
        projectId: json["projectId"],
        addBy: json["addBy"],
        projectRights: json["projectRights"],
        taskRight: json["taskRight"],
        issuesRight: json["issuesRight"],
        joined: json["joined"],
        deletedAt: json["deleted_at"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
        rights: json["rights"] == null
            ? null
            : List<Right>.from(json["rights"].map((x) => Right.fromJson(x))),
        teamDetails: json["team_details"] == null
            ? null
            : TeamDetails.fromJson(json["team_details"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "registerUserId": registerUserId,
        "projectId": projectId,
        "addBy": addBy,
        "projectRights": projectRights,
        "taskRight": taskRight,
        "issuesRight": issuesRight,
        "joined": joined,
        "deleted_at": deletedAt,
        "created_at": createdAt,
        "updated_at": updatedAt,
        "rights": List<Right>.from(rights!.map((x) => x.toJson())),
        "team_details": teamDetails!.toJson(),
      };
}

class Right {
  Right({
    this.id,
    this.title,
    this.description,
    this.isAllow,
  });

  int? id;
  String? title;
  String? description;
  bool? isAllow;

  factory Right.fromJson(Map<String, dynamic> json) => Right(
        id: json["id"],
        title: json["title"],
        description: json["description"],
        isAllow: json["isAllow"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "description": description,
        "isAllow": isAllow,
      };
}

class TeamDetails {
  TeamDetails(
      {this.id,
      this.image,
      this.companyName,
      this.currentRoleId,
      this.name,
      this.countryCode,
      this.mobile,
      this.isShow});

  int? id;
  dynamic image;
  dynamic companyName;
  dynamic currentRoleId;
  String? name;
  String? countryCode;
  String? mobile;
  bool? isShow;

  factory TeamDetails.fromJson(Map<String, dynamic> json) => TeamDetails(
        id: json["id"],
        image: json["image"],
        companyName: json["companyName"],
        currentRoleId: json["currentRoleId"],
        name: json["name"],
        countryCode: json["countryCode"],
        mobile: json["mobile"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "image": image,
        "companyName": companyName,
        "currentRoleId": currentRoleId,
        "name": name,
        "countryCode": countryCode,
        "mobile": mobile,
      };
}
