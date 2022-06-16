import 'dart:async';

import 'package:constructin/utils/app_asset.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
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

  @override
  void initState() {
    Timer(const Duration(milliseconds: 3000), () async {
      String body = PreferencesManager.getString(PreferencesKey.userModel);
      print("body ${body.toString()}");
      if (body != "") {
        projectModel = await ApiServices.getProjectList();
        if (projectModel!.data!.isEmpty) {
          print("home");
          Get.offAndToNamed(RouteHelper.home);
        } else {
          print("projectList");
          Get.offAndToNamed(RouteHelper.projectList);
        }
      } else {
        Get.offAndToNamed(RouteHelper.signIn);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
