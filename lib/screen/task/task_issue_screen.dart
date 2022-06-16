import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../../utils/app_asset.dart';
import '../../utils/app_color.dart';
import '../../utils/app_dimens.dart';
import '../../utils/app_string.dart';
import '../../utils/unil.dart';
import '../../widget/comman_widget.dart';
import '../../widget/text_form_field.dart';

class TaskIssueScreen extends StatefulWidget {
  const TaskIssueScreen({Key? key}) : super(key: key);

  @override
  State<TaskIssueScreen> createState() => _TaskIssueScreenState();
}

class _TaskIssueScreenState extends State<TaskIssueScreen> {
  TextEditingController descriptionController = TextEditingController();
  TextEditingController categoryController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColor.white,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            appBar("Task issue", () {
              Get.back();
            }),
            SizedBox(
              height: 5.w,
            ),
            Expanded(
                child: Padding(
              padding: EdgeInsets.all(3.w),
              child: ListView(
                shrinkWrap: true,
                children: [
                  Card(
                    margin: EdgeInsets.zero,
                    // decoration: BoxDecoration(
                    //   color: AppColor.white,
                    //   boxShadow: const <BoxShadow>[
                    //     BoxShadow(
                    //         color: AppColor.bg,
                    //         blurRadius: 10.0,
                    //         offset: Offset(0.0, 0.75))
                    //   ],
                    // ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.all(3.w),
                          child: Text(
                            "Task- Excavation",
                            style: Utils.regularTextStyle(
                                fontSize: AppDimens.large_font,
                                color: AppColor.dotColor),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(3.w),
                          child: Text(
                            "New issue-",
                            style: Utils.regularTextStyle(
                                fontSize: AppDimens.large_font,
                                color: AppColor.dotColor),
                          ),
                        ),
                        CommandTextFormField(
                          title: AppString.strEnterIssueDescription,
                          controller: descriptionController,
                          hint: AppString.strEnterIssueDescription,
                          textInputAction: TextInputAction.done,
                          textInputType: TextInputType.text,
                          onChange: (value) {},
                        ),
                        CommandTextFormField(
                          title: AppString.strSelectIssueCategory,
                          controller: descriptionController,
                          hint: AppString.strSelectIssueCategory,
                          textInputAction: TextInputAction.done,
                          textInputType: TextInputType.text,
                          onChange: (value) {},
                        ),
                        SizedBox(
                          height: 5.w,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(left: 3.w, top: 3.w),
                              child: Text(
                                "+ Add Photos",
                                style: Utils.regularTextStyle(
                                    fontSize: AppDimens.large_font,
                                    color: AppColor.dotColor),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 3.w, top: 3.w),
                              child: SizedBox(
                                  height: 10.w,
                                  width: 10.w,
                                  child: Image.asset(ImageAsset.iconSelectPic)),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 5.w,
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 3.w, top: 3.w),
                          child: Text(
                            "+ Add team member",
                            style: Utils.regularTextStyle(
                                fontSize: AppDimens.large_font,
                                color: AppColor.dotColor),
                          ),
                        ),
                        SizedBox(
                          height: 20.w,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 30.w,
                  ),
                  Image.asset(ImageAsset.btnIssueSave)
                ],
              ),
            ))
          ],
        ),
      ),
    );
  }
}
