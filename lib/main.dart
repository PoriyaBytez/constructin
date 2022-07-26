import 'package:constructin/bloc/project_list/project_list_bloc.dart';
import 'package:constructin/helper/route_helper.dart';
import 'package:constructin/utils/app_color.dart';
import 'package:constructin/utils/app_string.dart';
import 'package:constructin/utils/palette_color.dart';
import 'package:constructin/utils/shared_preferences/preferences_manager.dart';
import 'package:device_preview/device_preview.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:sizer/sizer.dart';

import 'bloc/create_project_bloc/create_project_bloc.dart';
import 'bloc/login_bloc/login_bloc.dart';
import 'bloc/task_bloc/task_bloc.dart';
import 'bloc/task_update_bloc/task_update_bloc.dart';
import 'bloc/team_member/team_member_bloc.dart';
import 'bloc/team_member_list_bloc/team_member_list_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await PreferencesManager.getInstance();
  await Firebase.initializeApp();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      // systemNavigationBarColor: AppColor.white, // navigation bar color
      statusBarColor: AppColor.white, //
      statusBarIconBrightness: Brightness.dark, // status bar color
    ),
  );
  runApp(const MyApp());
  // runApp( DevicePreview(
  //   enabled: !kReleaseMode,
  //   builder: (context) => MyApp(), // Wrap your app
  // ),);
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<LoginBloc>(create: (context) => LoginBloc()),
        BlocProvider<CreateProjectBloc>(
            create: (context) => CreateProjectBloc()),
        BlocProvider<ProjectListBloc>(create: (context) => ProjectListBloc()),
        BlocProvider<TeamMemberBloc>(create: (context) => TeamMemberBloc()),
        BlocProvider<TeamMemberListBloc>(
            create: (context) => TeamMemberListBloc()),
        BlocProvider<TaskBloc>(create: (context) => TaskBloc()),
        BlocProvider<TaskUpdateBloc>(create: (context) => TaskUpdateBloc()),
      ],
      child: Sizer(builder: (a, b, c) {
        return GetMaterialApp(
          title: AppString.appName,
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
              primaryColor: AppColor.mainColor, primarySwatch: Palette.kToDark),
          getPages: RouteHelper.routes,
          initialRoute: RouteHelper.splash,
        );
      }),
    );
  }
}
