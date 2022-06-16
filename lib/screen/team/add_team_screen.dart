import 'package:constructin/helper/route_helper.dart';
import 'package:constructin/utils/app_asset.dart';
import 'package:constructin/utils/app_color.dart';
import 'package:constructin/utils/app_dimens.dart';
import 'package:constructin/utils/app_string.dart';
import 'package:constructin/utils/unil.dart';
import 'package:constructin/widget/comman_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:sizer/sizer.dart';

class AddTeamScreen extends StatefulWidget {
  const AddTeamScreen({Key? key}) : super(key: key);

  @override
  State<AddTeamScreen> createState() => _AddTeamScreenState();
}

class _AddTeamScreenState extends State<AddTeamScreen> {
  int? projectID;

  @override
  void initState() {
    projectID = Get.arguments;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColor.white,
        body: Column(
          children: [
            appBar("Add Team", () {
              Get.back();
            }),
            Spacer(),
            Container(
                height: 50.w,
                width: 50.w,
                child: Image.asset(ImageAsset.imageAddMember)),
            SizedBox(
              height: 10.w,
            ),
            Padding(
              padding: EdgeInsets.only(left: 15.w, right: 15.w),
              child: Text(
                AppString.strAddTeamMember,
                textAlign: TextAlign.start,
                style: Utils.regularTextStyle(
                    color: AppColor.textColor, fontSize: AppDimens.medium_font),
              ),
            ),
            SizedBox(
              height: 10.w,
            ),
            Padding(
              padding: EdgeInsets.only(left: 25.w, right: 25.w),
              child: commandButton(
                  name: "Next",
                  bg: AppColor.mainColor,
                  onPress: () {
                    Get.toNamed(RouteHelper.addTeamMember, arguments: projectID);
                  },
                  strColor: AppColor.white),
            ),
            Spacer(),
          ],
        ),
      ),
    );
  }
}
