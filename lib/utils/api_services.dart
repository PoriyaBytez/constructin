import 'dart:convert';
import 'dart:io';

import 'package:constructin/model/company_role_model.dart';
import 'package:constructin/model/project_type_model.dart';
import 'package:constructin/model/task_details_model.dart';
import 'package:constructin/model/task_image_model.dart';
import 'package:constructin/model/task_review_model.dart';
import 'package:constructin/model/team_model.dart';
import 'package:constructin/model/unit_list_model.dart';
import 'package:constructin/utils/shared_preferences/preferences_key.dart';
import 'package:constructin/utils/toasts.dart';
import 'package:constructin/utils/util.dart';
import 'package:dio/dio.dart';

import '../model/comment_model.dart';
import '../model/issue_model.dart';
import '../model/project_model.dart';
import '../model/task_category_model.dart';
import '../model/task_model.dart';
import '../model/user_model.dart';
import 'shared_preferences/preferences_manager.dart';

class ApiServices {
  static const String base = "https://admin.constructin.net/api/";

  // static const String base = "http://192.168.1.10:8000/api/";
  static const String login = 'login';
  static const String projectType = 'projectType';
  static const String projectCreate = 'projectCreate';
  static const String projectList = 'projectList';
  static const String projectUpdate = 'projectUpdate';
  static const String projectDelete = 'projectDelete';
  static const String teamList = 'teamList';
  static const String createTeam = 'createTeam';
  static const String teamRight = 'teamRight';
  static const String taskCategoryList = 'taskCategoryList';
  static const String createTask = 'createTask';
  static const String taskList = 'taskList';
  static const String taskUpdate = 'taskUpdate';
  static const String taskDelete = 'taskDelete';
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
  static const String issueEdit = 'issueEdit';
  static const String issueDelete = 'issueDelete';
  static const String issueList = 'issueList';
  static const String issueRight = 'issueRight';
  static const String issueClose = 'issueClose';
  static const String createComment = 'createComment';
  static const String commentList = 'commentList';
  static const String taskReview = 'taskReview';
  static const String taskImageDelete = 'taskImageDelete';

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
      Toasts.showToast(response.data["message"]);
      return UserModel.fromJson(response.data);
    } else {
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
      return ProjectTypeModel.fromJson(response.data);
    } else {
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

    final Response response;
    if (data.id == null) {
      response = await dio.post(base + projectCreate, data: body);
    } else {
      response = await dio.post(base + projectUpdate, data: body);
    }
    if (response.statusCode == 200) {
      Toasts.showToast(response.data["message"]);
      PreferencesManager.setString(PreferencesKey.projectList, "1");
      return ProjectDetail.fromJson(response.data);
    } else {
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
        return ProjectModel.fromJson(response.data);
      } else {
        throw Exception('Failed to post.');
      }
    } on SocketException catch (e) {
      throw SocketException(e.toString());
    } on DioError catch (e) {
      return null;
    }
  }

  /// delete Project
  static Future<bool> postProjectDelete(int id) async {
    bool isDelete = false;
    Dio dio = getDio();
    dio.interceptors.add(InterceptorsWrapper(
      onResponse: (e, handler) {
        handler.next(e);
      },
    ));
    final response = await dio.post(base + projectDelete, data: {
      "projectId": id,
    });
    if (response.statusCode == 200) {
      Toasts.showToast("${response.data['message']}");
      isDelete = true;
      return isDelete;
    }
    return isDelete;
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
      return TeamModel.fromJson(response.data);
    } else {
      throw Exception('Failed to post.');
    }
  }

  /// Add Member in team
  static Future<dynamic> postAddMember(
      String name, String countryCode, String mobile, int? projectID) async {
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
        Toasts.showToast(response.data['message']);
        return TeamData.fromJson(response.data['data']);
      } else {
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
  static Future<dynamic> getDetails(int taskId, String inDate) async {
    Dio dio = getDio();
    dio.interceptors.add(InterceptorsWrapper(
      onResponse: (e, handler) {
        handler.next(e);
      },
    ));
    final response = await dio.post(base + taskDetails,
        data: {"taskId": taskId.toString(), "date": Utils.passData(inDate)});
    if (response.statusCode == 200) {
      return TaskDetailsData.fromJson(response.data["data"]);
    } else {
      throw Exception('Failed to post.');
    }
  }

  /// Role Assignee
  static Future<bool> postRoleAssignee(
      int registerId, int projectId, dynamic projectRights) async {
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
      Toasts.showToast(response.data['message']);
      // return TeamDetails.fromJson(response.data);
      return true;
    } else {
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
      return TaskCategoryModel.fromJson(response.data);
    } else {
      throw Exception('Failed to post.');
    }
  }

  /// Add Post Task
  static Future<TaskModel> postTask(
      int projectId, int taskCategoryId, String title) async {
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
      Toasts.showToast(response.data['message']);
      return TaskModel.fromJson(response.data);
    } else {
      throw Exception('Failed to post.');
    }
  }

  /// Task List
  static Future<TaskModel> getTaskList(int projectId) async {
    Dio dio = getDio();
    dio.interceptors.add(InterceptorsWrapper(
      onResponse: (e, handler) {
        handler.next(e);
      },
    ));
    final response =
        await dio.post(base + taskList, data: {"projectId": projectId});
    if (response.statusCode == 200) {
      return TaskModel.fromJson(response.data);
    } else {
      throw Exception('Failed to post.');
    }
  }

  /// Task Update Details
  static Future<TaskDetailsList> updateTask(int id, String startDate,
      String endDate, int totalWork, int unitId) async {
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
      Toasts.showToast(response.data['message']);
      return TaskDetailsList.fromJson(response.data["data"]);
    } else {
      throw Exception('Failed to post.');
    }
  }

  /// delete task
  static postTaskDelete(int id) async {
    Dio dio = getDio();
    bool isDelete = false;
    dio.interceptors.add(InterceptorsWrapper(
      onResponse: (e, handler) {
        handler.next(e);
      },
    ));
    final response = await dio.post(base + taskDelete, data: {
      "taskId": id,
    });
    if (response.statusCode == 200) {
      Toasts.showToast("${response.data['message']}");
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
      return UnitModel.fromJson(response.data);
    } else {
      throw Exception('Failed to post.');
    }
  }

  /// post Task Details Data Progress
  static Future<TaskDetailsModel>? postProgress(TaskDetailsData data) async {
    var bodydata = data.toJson();
    var body = jsonEncode(bodydata);
    TaskDetailsModel taskDetailsModel = TaskDetailsModel();
    try {
      Dio dio = getDio();
      dio.interceptors.add(InterceptorsWrapper(
        onResponse: (e, handler) {
          handler.next(e);
        },
      ));
      final response = await dio.post(base + taskProgress, data: body);
      if (response.statusCode == 200) {
        Toasts.showToast(response.data['message']);
        taskDetailsModel = TaskDetailsModel.fromJson(response.data);
      } else {
        throw Exception('Failed to post.');
      }
    } on DioError catch (e) {
      print("DioError : ${e.message}");
    }
    return taskDetailsModel;
  }

  /// post Task Right
  static Future<dynamic> postTaskRight(
      int taskId, int projectId, int registerUserId) async {
    Dio dio = getDio();
    try {
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
        Toasts.showToast(response.data["message"]);
        return true;
      }
    } on DioError catch (e) {
      if (e.response?.statusCode == 422) {
        Toasts.showToast(e.response?.data["message"]);
        return false;
      } else {
        throw Exception('Failed to post.');
      }
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
      Toasts.showToast(response.data["message"]);
      if (response.data["success"] == false) {
        Toasts.showToast(response.data["messages"]);
        return false;
      } else {
        Toasts.showToast(response.data["messages"]);
        return TaskCategoryData.fromJson(response.data["data"]);
      }
    } else {
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
      return CompanyRoleModel.fromJson(response.data);
    } else {
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
      Toasts.showToast(response.data["message"]);
      return UserModel.fromJson(response.data);
    } else {
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
      return TaskImageModel.fromJson(response.data);
    } else {
      throw Exception('Failed to post.');
    }
  }

  /// get  task Image List
  static Future<TaskImageModel?> postTaskImage(List<MultipartFile> list,
      int? taskId, int? projectId, int? registerUserId) async {
    try {
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
        Toasts.showToast(response.data['message']);
        return TaskImageModel.fromJson(response.data);
      } else {
        throw Exception('Failed to post.');
      }
    } on DioError catch (e) {
      print(e.message);
    }
    return null;
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
      return TaskCategoryModel.fromJson(response.data);
    } else {
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
      Toasts.showToast(response.data["message"]);
      if (response.data["success"] == false) {
        return false;
      } else {
        return TaskCategoryData.fromJson(response.data["data"]);
      }
    } else {
      throw Exception('Failed to post.');
    }
  }

  /// Post Issue Member Wise
  static Future<IssueData> postIssue(
      String projectId,
      String taskId,
      String issueCategoryId,
      String title,
      String tage,
      List<MultipartFile> list,
      String registerUserIdes) async {
    Dio dio = getDio();
    dio.interceptors.add(InterceptorsWrapper(
      onResponse: (e, handler) {
        handler.next(e);
      },
    ));
    final response = await dio.post(base + createIssue,
        data: FormData.fromMap({
          "projectId": projectId,
          "taskId": taskId,
          "issueCategoryId": issueCategoryId,
          "title": title,
          "tag": tage,
          "image[]": list,
          "registerUserIdes": registerUserIdes
        }));
    if (response.statusCode == 200) {
      Toasts.showToast(response.data['message']);
      return IssueData.fromJson(response.data["data"]);
    } else {
      throw Exception('Failed to post.');
    }
  }

  /// edit Issue Member Wise
  static Future<IssueData> editIssue(
      int id, String issueCategoryId, String title, String tage) async {
    Dio dio = getDio();
    dio.interceptors.add(InterceptorsWrapper(
      onResponse: (e, handler) {
        handler.next(e);
      },
    ));
    final response = await dio.post(base + issueEdit,
        data: FormData.fromMap({
          "id": id,
          "issueCategoryId": issueCategoryId,
          "title": title,
          // "tag": tage,
        }));
    if (response.statusCode == 200) {
      Toasts.showToast(response.data['message']);
      return IssueData.fromJson(response.data["data"]);
    } else {
      throw Exception('Failed to post.');
    }
  }

  /// delete Issue
  static postIssueDelete(int id) async {
    Dio dio = getDio();
    bool isDelete = false;
    dio.interceptors.add(InterceptorsWrapper(
      onResponse: (e, handler) {
        handler.next(e);
      },
    ));
    final response = await dio.post(base + issueDelete, data: {
      "issueId": id,
    });
    if (response.statusCode == 200) {
      Toasts.showToast("${response.data['message']}");
      // isDelete = response.data['success'];
      // return isDelete;
    }
    // return isDelete;
  }

  /// Issue List
  static Future<IssueModel> getIssueList(int id, int type) async {
    Dio dio = getDio();
    print("id : $id");
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
      return IssueModel.fromJson(response.data);
    } else {
      throw Exception('Failed to post.');
    }
  }

  /// Issue Right
  static Future<dynamic> postIssueRight(
      int issueId, int projectId, int registerUserId) async {
    Dio dio = getDio();
    try {
      dio.interceptors.add(InterceptorsWrapper(
        onResponse: (e, handler) {
          handler.next(e);
        },
      ));
      final response = await dio.post(base + issueRight, data: {
        "issueId": issueId,
        "projectId": projectId,
        "registerUserId": registerUserId,
      });

      if (response.statusCode == 200) {
        Toasts.showToast(response.data['message']);
        return true;
      } else {
        throw Exception('Failed to post.');
      }
    } on DioError catch (e) {
      if (e.response?.statusCode == 422) {
        Toasts.showToast(e.response?.data['message']);
        return false;
      } else {
        throw Exception('Failed to post.');
      }
    }
  }

  /// Issue close
  static Future<int> poseIssueClose(int id) async {
    Dio dio = getDio();
    print("id : $id");
    dio.interceptors.add(InterceptorsWrapper(
      onResponse: (e, handler) {
        handler.next(e);
      },
    ));
    final response = await dio.post(base + issueClose, data: {
      "issueId": id,
    });
    if (response.statusCode == 200) {
      return 0;
    } else {
      throw Exception('Failed to post.');
    }
  }

  /// crate Comment
  static Future<CommentData> poseComment(int projectId, int issueId,
      String taskId, dynamic image, String comment) async {
    Dio dio = getDio();

    dio.interceptors.add(InterceptorsWrapper(
      onResponse: (e, handler) {
        handler.next(e);
      },
    ));
    final response = await dio.post(base + createComment,
        data: FormData.fromMap({
          "projectId": projectId,
          "issueId": issueId,
          "taskId": taskId,
          "image": image,
          "comment": comment
        }));
    if (response.statusCode == 200) {
      return CommentData.fromJson(response.data["data"]);
    } else {
      throw Exception('Failed to post.');
    }
  }

  /// Comment List get
  static Future<CommentModel> getCommentList(int id) async {
    Dio dio = getDio();

    dio.interceptors.add(InterceptorsWrapper(
      onResponse: (e, handler) {
        handler.next(e);
      },
    ));
    final response = await dio.post(base + commentList, data: {"issueId": id});
    if (response.statusCode == 200) {
      return CommentModel.fromJson(response.data);
    } else {
      throw Exception('Failed to post.');
    }
  }

  /// get Task View
  static Future<TaskReviewData>? getTaskView(int id) async {
    TaskReviewData taskDetailsModel = TaskReviewData();
    Dio dio = getDio();
    dio.interceptors.add(InterceptorsWrapper(
      onResponse: (e, handler) {
        handler.next(e);
      },
    ));
    final response = await dio.post(base + taskReview, data: {"id": id});
    if (response.statusCode == 200) {
      taskDetailsModel = TaskReviewData.fromJson(response.data["data"]);
    } else {
      throw Exception('Failed to post.');
    }
    return taskDetailsModel;
  }

  /// get Task View
  static imageDelete(int taskId, int taskImageId) async {
    Dio dio = getDio();
    dio.interceptors.add(InterceptorsWrapper(
      onResponse: (e, handler) {
        handler.next(e);
      },
    ));
    final response = await dio.post(base + taskImageDelete,
        data: {"taskId": taskId, "taskImageId": taskImageId});
    if (response.statusCode == 200) {
      Toasts.showToast("${response.data['message']}");
    }
  }
}
