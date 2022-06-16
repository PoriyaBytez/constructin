import 'package:constructin/screen/task/task_issue_screen.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';

import '../screen/auth/mobile_number_screen.dart';
import '../screen/auth/sign_in_screen.dart';
import '../screen/dashboard_screen.dart';
import '../screen/home_screen.dart';
import '../screen/issue_details_screen.dart';
import '../screen/profile_screen.dart';
import '../screen/project/create_project_screen.dart';
import '../screen/project/project_list_screen.dart';
import '../screen/splash_screen.dart';
import '../screen/task/task_details_screen.dart';
import '../screen/task/task_review_screen.dart';
import '../screen/task/update_task_screen.dart';
import '../screen/team/add_team_member_screen.dart';
import '../screen/team/add_team_screen.dart';
import '../screen/team/team_mamber_list_screen.dart';

class RouteHelper {
  static String splash = '/Splash';
  static String signIn = '/SignIn';
  static String mobileNumberScreen = '/MobileNumber';
  static String home = '/HomeScreen';
  static String profile = '/ProfileScreen';
  static String createProject = '/CreateProject';
  static String projectList = '/ProjectList';
  static String dashBoard = '/DashBoardScreen';
  static String addTask = '/AddTask';
  static String updateTask = '/UpdateTask';

  static String taskIssue = '/TaskIssue';
  static String issueDetails = '/IssueDetails';
  static String taskReview = '/TaskReview';
  static String addTeam = '/AddTeam';
  static String addTeamMember = '/AddTeamMember';
  static String contact = '/ContactScreen';
  // static String teamMemberList = '/TeamMemberList';

  static List<GetPage> routes = [
    GetPage(name: splash, page: () => SplashScreen()),
    GetPage(name: signIn, page: () => SignInScreen()),
    GetPage(name: mobileNumberScreen, page: () => MobileNumberScreen()),
    GetPage(name: home, page: () => HomeScreen()),
    GetPage(name: profile, page: () => ProfileScreen()),
    GetPage(name: createProject, page: () => CreateProjectScreen()),
    GetPage(name: projectList, page: () => ProjectListScreen()),
    GetPage(name: dashBoard, page: () => DashBoardScreen()),
    GetPage(name: updateTask, page: () => UpdateTaskScreen()),

    GetPage(name: taskIssue, page: () => TaskIssueScreen()),
    GetPage(name: issueDetails, page: () => IssueDetailsScreen()),
    GetPage(name: taskReview, page: () => TaskReviewScreen()),
    GetPage(name: addTeam, page: () => AddTeamScreen()),
    // GetPage(name: addTeamMember, page: () => AddTeamMemberScreen()),
    // GetPage(name: teamMemberList, page: () => TeamMemberListScreen()),
  ];
}
