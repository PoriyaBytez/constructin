import 'dart:convert';
import 'dart:io';

import 'package:constructin/model/company_role_model.dart';
import 'package:constructin/model/project_type_model.dart';
import 'package:constructin/model/task_details_model.dart';
import 'package:constructin/model/task_image_model.dart';
import 'package:constructin/model/team_model.dart';
import 'package:constructin/model/unit_list_model.dart';
import 'package:constructin/utils/shared_preferences/preferences_key.dart';
import 'package:constructin/utils/toasts.dart';
import 'package:dio/dio.dart';

import '../model/issue_model.dart';
import '../model/project_model.dart';
import '../model/task_category_model.dart';
import '../model/task_model.dart';
import '../model/user_model.dart';
import 'shared_preferences/preferences_manager.dart';

class ApiServices {
  static const String base = "https://admin.constructin.net/api/";
  static const String login = 'login';
  static const String projectType = 'projectType';
  static const String projectCreate = 'projectCreate';
  static const String projectList = 'projectList';
  static const String teamList = 'teamList';
  static const String createTeam = 'createTeam';
  static const String teamRight = 'teamRight';
  static const String taskCategoryList = 'taskCategoryList';
  static const String createTask = 'createTask';
  static const String taskList = 'taskList';
  static const String taskUpdate = 'taskUpdate';
  static const String unitList = 'unitList';
  static const String taskProgress = 'taskProgress';
  static const String taskDetails = 'taskDetails';
  static const String taskRight = 'taskRight';
  static const String taskCategoryMemberWise = 'taskCategoryMemberWise';
  static const String taskCategoryMemberWiseEdit = 'taskCategoryMemberWiseEdit';
  static const String companyRole = 'companyRole';
  static const String profile = 'profile';
  static const String taskImageList = 'taskImageList';
  static const String taskImage = 'taskImage';
  static const String issueCategoryList = 'issueCategoryList';
  static const String issueCategoryMemberWise = 'issueCategoryMemberWise';
  static const String issueCategoryMemberWiseEdit =
      'issueCategoryMemberWiseEdit';
  static const String createIssue = 'createIssue';
  static const String issueList = 'issueList';

  static Dio getDio() {
    String strUserData = PreferencesManager.getString(PreferencesKey.userModel);
    UserModel userModel = UserModel.fromJson(jsonDecode(strUserData));
    String? token = userModel.data?.accessToken;
    // print("token ${token}");
    Dio dio = Dio();
    dio.options.headers["authorization"] = "Bearer $token";
    return dio;
  }

  /// login user
  static Future<UserModel> loginUser(
      String? countryCode, String? mobile, int? type, String? deviceId) async {
    Dio dio = Dio();
    dio.interceptors.add(InterceptorsWrapper(
      onResponse: (e, handler) {
        handler.next(e);
      },
    ));
    final response = await dio.post(base + login, data: {
      "countryCode": countryCode,
      "mobile": mobile,
      "type": type,
      "deviceId": deviceId,
    });
    if (response.statusCode == 200) {
      print("response: UserModel ${response.data}");
      Toasts.showToast(response.data["message"]);
      return UserModel.fromJson(response.data);
    } else {
      print("response: UserModel ${response.data['message']}");
      Toasts.showToast(response.data["message"]);
      throw Exception('Failed to post.');
    }
  }

  /// get project type
  static Future<ProjectTypeModel> getProject() async {
    Dio dio = getDio();
    dio.interceptors.add(InterceptorsWrapper(
      onResponse: (e, handler) {
        handler.next(e);
      },
    ));
    final response = await dio.post(base + projectType, data: {});
    if (response.statusCode == 200) {
      print("response: ProjectType ${response.data}");
      return ProjectTypeModel.fromJson(response.data);
    } else {
      print("response: ProjectType ${response.data['message']}");
      throw Exception('Failed to post.');
    }
  }

  /// post create project
  static Future<ProjectDetail> postCreateProject(ProjectDetail data) async {
    var bodydata = data.toJson();
    var body = jsonEncode(bodydata);
    Dio dio = getDio();
    dio.interceptors.add(InterceptorsWrapper(
      onResponse: (e, handler) {
        handler.next(e);
      },
    ));
    final response = await dio.post(base + projectCreate, data: body);
    if (response.statusCode == 200) {
      print("response: CreateProject ${response.data}");
      Toasts.showToast(response.data["message"]);
      PreferencesManager.setString(PreferencesKey.projectList, "1");
      return ProjectDetail.fromJson(response.data);
    } else {
      print("response: CreateProject ${response.data['message']}");
      throw Exception('Failed to post.');
    }
  }

  /// Get Project List
  static Future<ProjectModel?> getProjectList() async {
    try {
      Dio dio = getDio();
      dio.interceptors.add(InterceptorsWrapper(
        onResponse: (e, handler) {
          handler.next(e);
        },
      ));
      final response = await dio.post(
        base + projectList,
      );
      if (response.statusCode == 200) {
        print("response: ProjectModel ${response.data}");

        return ProjectModel.fromJson(response.data);
      } else {
        print("response: ProjectModel ${response.data['message']}");
        throw Exception('Failed to post.');
      }
    } on SocketException catch (e) {
      print("Please Connect Internet}");
      throw SocketException(e.toString());
    } on DioError catch (e) {
      return null;
    }
  }

  /// Get TeamMemberList
  static Future<TeamModel> getTeamMemberList(int projectId) async {
    Dio dio = getDio();
    dio.interceptors.add(InterceptorsWrapper(
      onResponse: (e, handler) {
        handler.next(e);
      },
    ));
    final response =
        await dio.post(base + teamList, data: {"projectId": projectId});
    if (response.statusCode == 200) {
      print("response: TeamModel ${response.data}");
      return TeamModel.fromJson(response.data);
    } else {
      print("response: ProjectModel ${response.data['message']}");
      throw Exception('Failed to post.');
    }
  }

  /// Add Member in team
  static Future<dynamic> postAddMember(
      String name, String countryCode, String mobile, int? projectID) async {
    print("name ${name}");
    print("countryCode ${countryCode}");
    print("mobile ${mobile.replaceAll(" ", "")}");
    print("projectId ${projectID}");
    Dio dio = getDio();
    dio.interceptors.add(InterceptorsWrapper(
      onResponse: (e, handler) {
        handler.next(e);
      },
    ));
    var response;
    try {
      response = await dio.post(base + createTeam, data: {
        "name": name,
        "countryCode": countryCode,
        "mobile": mobile,
        "projectId": projectID,
      });
      if (response.statusCode == 200) {
        print("response: TeamData ${response.data}");
        Toasts.showToast(response.data['message']);
        return TeamData.fromJson(response.data['data']);
      } else {
        print("response: TeamData ${response.data['message']}");
        throw Exception('Failed to post.');
      }
    } catch (e) {
      if (e.runtimeType == DioError) {
        var dioException = e as DioError;
        if (dioException.response!.statusCode == 409) {
          Toasts.showToast("The user already exists.");
          return false;
        }
      }
    }
  }

  ///  taskDetails date wise
  static Future<dynamic> getDetails(int taskId, String date) async {
    print("id : $taskId");
    print("date : $date");
    Dio dio = getDio();
    dio.interceptors.add(InterceptorsWrapper(
      onResponse: (e, handler) {
        handler.next(e);
      },
    ));
    final response = await dio.post(base + taskDetails,
        data: {"taskId": taskId.toString(), "date": date});
    if (response.statusCode == 200) {
      print("response: DetailsData ${response.data}");
      if (response.data["data"] == null) {
        Toasts.showToast(response.data["messages"]);
        return false;
      } else {
        return TaskDetailsData.fromJson(response.data["data"]);
      }
    } else {
      print("response: DetailsData ${response.data['message']}");
      throw Exception('Failed to post.');
    }
  }

  /// Role Assignee
  static Future<bool> postRoleAssignee(
      int registerId, int projectId, dynamic projectRights) async {
    print("registerId : $registerId");
    print("projectId : $projectId");
    print("projectRights : $projectRights");
    Dio dio = getDio();
    dio.interceptors.add(InterceptorsWrapper(
      onResponse: (e, handler) {
        handler.next(e);
      },
    ));
    final response = await dio.post(base + teamRight, data: {
      "registerId": registerId,
      "projectId": projectId,
      "projectRights": projectRights
    });
    if (response.statusCode == 200) {
      print("response: TeamDetails ${response.data}");
      Toasts.showToast(response.data['message']);
      // return TeamDetails.fromJson(response.data);
      return true;
    } else {
      print("response: TeamDetails ${response.data['message']}");
      throw Exception('Failed to post.');
    }
  }

  /// Task Category List
  static Future<TaskCategoryModel> getTaskCategoryList() async {
    Dio dio = getDio();
    dio.interceptors.add(InterceptorsWrapper(
      onResponse: (e, handler) {
        handler.next(e);
      },
    ));
    final response = await dio.post(base + taskCategoryList);
    if (response.statusCode == 200) {
      print("response: TaskCategoryModel ${response.data}");
      return TaskCategoryModel.fromJson(response.data);
    } else {
      print("response: TaskCategoryModel ${response.data['message']}");
      throw Exception('Failed to post.');
    }
  }

  /// Add Post Task
  static Future<TaskModel> postTask(
      int projectId, int taskCategoryId, String title) async {
    print("projectId ${projectId}");
    print("taskCategoryId ${taskCategoryId}");
    print("title ${title}");
    Dio dio = getDio();
    dio.interceptors.add(InterceptorsWrapper(
      onResponse: (e, handler) {
        handler.next(e);
      },
    ));
    final response = await dio.post(base + createTask, data: {
      "projectId": projectId,
      "taskCategoryId": taskCategoryId,
      "title": title
    });
    if (response.statusCode == 200) {
      print("response: TeamData ${response.data}");
      Toasts.showToast(response.data['message']);
      return TaskModel.fromJson(response.data);
    } else {
      print("response: TeamData ${response.data['message']}");
      throw Exception('Failed to post.');
    }
  }

  /// Task List
  static Future<TaskModel> getTaskList(int projectId) async {
    print("id services  project : $projectId");
    Dio dio = getDio();
    dio.interceptors.add(InterceptorsWrapper(
      onResponse: (e, handler) {
        handler.next(e);
      },
    ));
    final response =
        await dio.post(base + taskList, data: {"projectId": projectId});
    if (response.statusCode == 200) {
      print("response: TaskModel ${response.data}");
      return TaskModel.fromJson(response.data);
    } else {
      print("response: TaskModel ${response.data['message']}");
      throw Exception('Failed to post.');
    }
  }

  /// Task Update Details
  static Future<TaskDetailsList> updateTask(int id, String startDate,
      String endDate, int totalWork, int unitId) async {
    print("id :$id");
    print("startDate :$startDate");
    print("endDate :$endDate");
    print("totalWork :$totalWork");
    print("unitId :$unitId");
    Dio dio = getDio();
    dio.interceptors.add(InterceptorsWrapper(
      onResponse: (e, handler) {
        handler.next(e);
      },
    ));
    final response = await dio.post(base + taskUpdate, data: {
      "id": id,
      "startDate": startDate,
      "endDate": endDate,
      "totalWork": totalWork,
      "unitId": unitId
    });
    if (response.statusCode == 200) {
      print("response: TaskModel ${response.data}");
      Toasts.showToast(response.data['message']);
      return TaskDetailsList.fromJson(response.data["data"]);
    } else {
      print("response: TaskModel ${response.data['message']}");
      throw Exception('Failed to post.');
    }
  }

  /// Get Unit List
  static Future<UnitModel> getUnitList() async {
    Dio dio = getDio();
    dio.interceptors.add(InterceptorsWrapper(
      onResponse: (e, handler) {
        handler.next(e);
      },
    ));
    final response = await dio.post(base + unitList);
    if (response.statusCode == 200) {
      print("response: UnitModel ${response.data}");
      return UnitModel.fromJson(response.data);
    } else {
      print("response: UnitModel ${response.data['message']}");
      throw Exception('Failed to post.');
    }
  }

  /// post Task Details Data Progress
  static Future<TaskDetailsModel> postProgress(TaskDetailsData data) async {
    var bodydata = data.toJson();
    var body = jsonEncode(bodydata);
    Dio dio = getDio();
    dio.interceptors.add(InterceptorsWrapper(
      onResponse: (e, handler) {
        handler.next(e);
      },
    ));
    final response = await dio.post(base + taskProgress, data: body);
    if (response.statusCode == 200) {
      print("response: DetailsModel ${response.data}");
      Toasts.showToast(response.data['message']);
      return TaskDetailsModel.fromJson(response.data);
    } else {
      print("response: DetailsModel ${response.data['message']}");
      throw Exception('Failed to post.');
    }
  }

  /// post Task Right
  static Future<dynamic> postTaskRight(
      int taskId, int projectId, int registerUserId) async {
    print("taskId $taskId");
    print("projectId $projectId");
    print("registerUserId $registerUserId");

    Dio dio = getDio();
    dio.interceptors.add(InterceptorsWrapper(
      onResponse: (e, handler) {
        handler.next(e);
      },
    ));
    final response = await dio.post(base + taskRight, data: {
      "taskId": taskId.toString(),
      "projectId": projectId,
      "registerUserId": registerUserId
    });
    if (response.statusCode == 200) {
      print("response: TaskRight ${response.data}");
      Toasts.showToast(response.data["message"]);
      // if (response.data["data"] == null) {
      //   Toasts.showToast(response.data["messages"]);
      //   return false;
      // } else {
      //   return TaskDetailsData.fromJson(response.data["data"]);
      // }
    } else {
      print("response: TaskRight ${response.data['message']}");
      throw Exception('Failed to post.');
    }
  }

  /// post task Category Member Wise
  static Future<dynamic> postTaskCategory(String title, dynamic id) async {
    Dio dio = getDio();
    dio.interceptors.add(
      InterceptorsWrapper(
        onResponse: (e, handler) {
          handler.next(e);
        },
      ),
    );
    Response response;
    if (id == null) {
      response =
          await dio.post(base + taskCategoryMemberWise, data: {"title": title});
    } else {
      response = await dio.post(base + taskCategoryMemberWiseEdit,
          data: {"id": id, "title": title});
    }

    if (response.statusCode == 200) {
      print("response: TaskRight ${response.data}");
      Toasts.showToast(response.data["message"]);
      if (response.data["success"] == false) {
        Toasts.showToast(response.data["messages"]);
        return false;
      } else {
        Toasts.showToast(response.data["messages"]);
        return TaskCategoryData.fromJson(response.data["data"]);
      }
    } else {
      print("response: TaskRight ${response.data['message']}");
      throw Exception('Failed to post.');
    }
  }

  /// Get Company Role List
  static Future<CompanyRoleModel> getCompanyRoleList() async {
    Dio dio = getDio();
    dio.interceptors.add(InterceptorsWrapper(
      onResponse: (e, handler) {
        handler.next(e);
      },
    ));
    final response = await dio.post(base + companyRole);
    if (response.statusCode == 200) {
      print("response: CompanyRoleModel ${response.data}");
      return CompanyRoleModel.fromJson(response.data);
    } else {
      print("response: CompanyRoleModel ${response.data['message']}");
      throw Exception('Failed to post.');
    }
  }

  /// Post Edit Profile
  static Future<UserModel> editProfile(
    dynamic image,
    String? name,
    String? companyName,
    int? currentRoleId,
  ) async {
    print("image $image");
    print("name $name");
    print("companyName $companyName");
    print("currentRoleId $currentRoleId");
    Dio dio = getDio();
    dio.interceptors.add(InterceptorsWrapper(
      onResponse: (e, handler) {
        handler.next(e);
      },
    ));
    String? fileName;
    if (image != '') {
      fileName = image.path.split('/').last;
    }

    final response = await dio.post(base + profile,
        data: FormData.fromMap({
          "image": image == ""
              ? ""
              : await MultipartFile.fromFile(image.path, filename: fileName),
          "name": name,
          "companyName": companyName,
          "currentRoleId": 1
        }));
    if (response.statusCode == 200) {
      print("response: UserModel ${response.data}");
      Toasts.showToast(response.data["message"]);
      return UserModel.fromJson(response.data);
    } else {
      print("response: UserModel ${response.data['message']}");
      Toasts.showToast(response.data["message"]);
      throw Exception('Failed to post.');
    }
  }

  /// get  task Image List
  static Future<TaskImageModel> getTaskImageList(int taskId) async {
    Dio dio = getDio();
    dio.interceptors.add(InterceptorsWrapper(
      onResponse: (e, handler) {
        handler.next(e);
      },
    ));
    final response =
        await dio.post(base + taskImageList, data: {"taskId": taskId});
    if (response.statusCode == 200) {
      print("response: taskImageList ${response.data}");
      return TaskImageModel.fromJson(response.data);
    } else {
      print("response: taskImageList ${response.data['message']}");
      throw Exception('Failed to post.');
    }
  }

  /// get  task Image List
  static Future<TaskImageModel> postTaskImage(List<MultipartFile> list,
      int? taskId, int? projectId, int? registerUserId) async {
    print("image $list");
    print("taskId $taskId");
    print("projectId $projectId");
    print("registerUserId $registerUserId");
    Dio dio = getDio();
    dio.interceptors.add(InterceptorsWrapper(
      onResponse: (e, handler) {
        handler.next(e);
      },
    ));
    final response = await dio.post(base + taskImage,
        data: FormData.fromMap({
          "image[]": list,
          "taskId": taskId,
          "projectId": projectId,
          "registerUserId": registerUserId
        }));
    if (response.statusCode == 200) {
      print("response: taskImage ${response.data}");
      Toasts.showToast(response.data['message']);
      return TaskImageModel.fromJson(response.data);
    } else {
      throw Exception('Failed to post.');
    }
  }

  /// Issue Category List
  static Future<TaskCategoryModel> getIssueCategoryList() async {
    Dio dio = getDio();
    dio.interceptors.add(InterceptorsWrapper(
      onResponse: (e, handler) {
        handler.next(e);
      },
    ));
    final response = await dio.post(base + issueCategoryList);
    if (response.statusCode == 200) {
      print("response: IssueCategoryList ${response.data}");
      return TaskCategoryModel.fromJson(response.data);
    } else {
      print("response: IssueCategoryList ${response.data['message']}");
      throw Exception('Failed to post.');
    }
  }

  /// Post Issue Category Member Wise
  static Future<dynamic> postIssueCategory(String title, dynamic id) async {
    Dio dio = getDio();
    dio.interceptors.add(
      InterceptorsWrapper(
        onResponse: (e, handler) {
          handler.next(e);
        },
      ),
    );
    Response response;
    if (id == null) {
      response = await dio
          .post(base + issueCategoryMemberWise, data: {"title": title});
    } else {
      response = await dio.post(base + issueCategoryMemberWiseEdit,
          data: {"id": id, "title": title});
    }

    if (response.statusCode == 200) {
      print("response: Issue Category ${response.data}");
      Toasts.showToast(response.data["message"]);
      if (response.data["success"] == false) {
        Toasts.showToast(response.data["messages"]);
        return false;
      } else {
        Toasts.showToast(response.data["messages"]);
        return TaskCategoryData.fromJson(response.data["data"]);
      }
    } else {
      print("response: Issue Category ${response.data['message']}");
      throw Exception('Failed to post.');
    }
  }

  /// Post Issue Member Wise
  static Future<IssueModel> postIssue(
      String projectId, String issueCategoryId, String title) async {
    Dio dio = getDio();
    dio.interceptors.add(InterceptorsWrapper(
      onResponse: (e, handler) {
        handler.next(e);
      },
    ));
    final response = await dio.post(base + createIssue, data: {
      "projectId": projectId,
      "issueCategoryId": issueCategoryId,
      "title": title,
    });
    if (response.statusCode == 200) {
      print("response: IssueModel ${response.data}");
      return IssueModel.fromJson(response.data);
    } else {
      print("response: IssueModel ${response.data['message']}");
      throw Exception('Failed to post.');
    }
  }

  /// Issue List

  static Future<TaskCategoryModel> getIssueList(int id, int type) async {
    Dio dio = getDio();
    dio.interceptors.add(InterceptorsWrapper(
      onResponse: (e, handler) {
        handler.next(e);
      },
    ));
    final response = await dio.post(base + issueList, data: {
      "id": id,
      "type": type,
    });
    if (response.statusCode == 200) {
      print("response: IssueCategoryList ${response.data}");
      return TaskCategoryModel.fromJson(response.data);
    } else {
      print("response: IssueCategoryList ${response.data['message']}");
      throw Exception('Failed to post.');
    }
  }
}
