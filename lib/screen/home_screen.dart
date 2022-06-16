import 'package:constructin/helper/route_helper.dart';
import 'package:constructin/utils/app_color.dart';
import 'package:constructin/utils/app_dimens.dart';
import 'package:constructin/utils/app_string.dart';
import 'package:constructin/utils/unil.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../utils/app_asset.dart';
import '../widget/comman_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColor.white,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: 15.w,
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColor.white,
                boxShadow: const <BoxShadow>[
                  BoxShadow(
                      color: AppColor.gray1,
                      blurRadius: 1.0,
                      offset: Offset(0.0, 0.75))
                ],
              ),
              child: Padding(
                padding: EdgeInsets.only(left: 5.w, top: 3.w, bottom: 3.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          height: 10.w,
                          width: 10.w,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage(ImageAsset.ellipse))),
                        ),
                        SizedBox(
                          width: 5.w,
                        ),
                        Text(
                          "My Projects",
                          style: Utils.regularTextStyle(
                              color: AppColor.textColor,
                              fontSize: AppDimens.large_font),
                        ),
                      ],
                    ),
                    Padding(
                      padding:
                          EdgeInsets.only(right: 10.0, top: 5.0, bottom: 5.0),
                      child: Image.asset(ImageAsset.icons_more),
                    ),
                  ],
                ),
              ),
            ),
            Spacer(),
            Container(
              height: 70.w,
              width: 70.w,
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: AssetImage(ImageAsset.under_maintenance),
                ),
              ),
            ),
            SizedBox(
              height: 10.w,
            ),
            Center(
              child: Padding(
                padding: EdgeInsets.only(left: 10.w, right: 10.w),
                child: Text(
                  AppString.youdon_have_any_active,
                  textAlign: TextAlign.center,
                  style: Utils.regularTextStyle(
                      color: AppColor.textColor1,
                      fontSize: AppDimens.default_font),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 20.w, right: 20.w, top: 10.w),
              child: commandButton(
                  name: AppString.createNewProject,
                  strColor: AppColor.white,
                  bg: AppColor.mainColor,
                  onPress: () {
                    Get.offAndToNamed(RouteHelper.createProject, arguments: 0);
                  }),
            ),
            Spacer(),
          ],
        ),
      ),
    );
  }
}
