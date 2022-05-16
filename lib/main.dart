import 'package:constructin/helper/route_helper.dart';
import 'package:constructin/utils/app_string.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:sizer/sizer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Sizer(builder: (a, b, c) {
      return GetMaterialApp(
        title: AppString.appName,
        debugShowCheckedModeBanner: false,
        getPages: RouteHelper.routes,
        initialRoute: RouteHelper.createProject,
      );
    });
  }
}
