import 'dart:async';

import 'package:constructin/utils/app_asset.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:sizer/sizer.dart';

import '../helper/route_helper.dart';
import '../model/project_model.dart';
import '../utils/api_services.dart';
import '../utils/app_color.dart';
import '../utils/app_dimens.dart';
import '../utils/app_fonts.dart';
import '../utils/app_string.dart';
import '../utils/shared_preferences/preferences_key.dart';
import '../utils/shared_preferences/preferences_manager.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  ProjectModel? projectModel;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    Timer(const Duration(milliseconds: 3000), () async {
      bool result = await InternetConnectionChecker().hasConnection;
      if (result == true) {
        String body = PreferencesManager.getString(PreferencesKey.userModel);
        if (body != "") {
          projectModel = await ApiServices.getProjectList();
          if (projectModel!.data!.isEmpty) {
            Get.offAndToNamed(RouteHelper.home);
          } else {
            Get.offAndToNamed(RouteHelper.projectList);
          }
        } else {
          Get.offAndToNamed(RouteHelper.signIn);
        }
      } else {
        showInSnackBar("Please Connect Internet.");
      }
    });
    super.initState();
  }

  void showInSnackBar(String value) {
    final snackBar = SnackBar(
      content: Text(value),
      action: SnackBarAction(
        label: '',
        onPressed: () {
          // Some code to undo the change.
        },
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppColor.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              AppString.appName1,
              style: TextStyle(
                  fontSize: AppDimens.extra_large_font,
                  color: AppColor.mainColor,
                  fontFamily: AppFonts.gilroy,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 3.2),
            ),
            Container(
              width: 75.w,
              height: 80.w,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(ImageAsset.engineer_rafiki),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
