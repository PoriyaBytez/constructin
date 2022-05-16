import 'package:get/get_navigation/src/routes/get_route.dart';

import '../screen/auth/mobile_number_screen.dart';
import '../screen/auth/sign_in_screen.dart';
import '../screen/create_project_screen.dart';
import '../screen/home_screen.dart';

class RouteHelper {
  static String splash = '/Splash';
  static String signIn = '/SignIn';
  static String mobileNumberScreen = '/MobileNumber';
  static String home = '/HomeScreen';
  static String createProject = '/CreateProject';


  static List<GetPage> routes = [
    // GetPage(name: splash, page: () => SplashScreen()),
    GetPage(name: signIn, page: () => SignInScreen()),
    GetPage(name: mobileNumberScreen, page: () => MobileNumberScreen()),
    GetPage(name: home, page: () => HomeScreen()),
    GetPage(name: createProject, page: () => CreateProjectScreen()),
  ];
}
