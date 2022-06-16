import 'package:constructin/utils/app_color.dart';
import 'package:constructin/utils/app_dimens.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:sizer/sizer.dart';

import '../utils/app_asset.dart';
import '../utils/unil.dart';
import '../widget/comman_widget.dart';

class IssueDetailsScreen extends StatefulWidget {
  const IssueDetailsScreen({Key? key}) : super(key: key);

  @override
  State<IssueDetailsScreen> createState() => _IssueDetailsScreenState();
}

class _IssueDetailsScreenState extends State<IssueDetailsScreen> {
  int selectIndex = 1;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColor.white,
        body: Column(
          children: [
            appBar("Material Shortage", () {
              Get.back();
            }),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(
                    top: 8.w, left: 4.w, right: 3.w, bottom: 3.w),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                  color: AppColor.green1,
                                  borderRadius: BorderRadius.circular(5)),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "Material",
                                  style: Utils.regularTextStyle(
                                      color: AppColor.green),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 5.w,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                  color: AppColor.btnUpdateBg,
                                  borderRadius: BorderRadius.circular(5)),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "Excavation",
                                  style: Utils.regularTextStyle(
                                      color: AppColor.textColor2),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 3.w,
                    ),
                    Text(
                      "Material shortage at site due to price hike and other reasons",
                      style: Utils.regularTextStyle(color: AppColor.textColor3),
                    ),
                    SizedBox(
                      height: 10.w,
                    ),
                    Container(
                      height: 10.w,
                      color: AppColor.textFormFieldBg,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          InkWell(
                            onTap: () {
                              setState(() {
                                selectIndex = 1;
                              });
                            },
                            child: Text(
                              "Comments",
                              style: Utils.regularTextStyle(
                                  color: selectIndex == 1
                                      ? AppColor.textColor2
                                      : AppColor.textColor3),
                            ),
                          ),
                          Container(
                            width: 2,
                            color: AppColor.floatBg1,
                          ),
                          InkWell(
                            onTap: () {
                              setState(() {
                                selectIndex = 2;
                              });
                            },
                            child: Text(
                              "Attachments",
                              style: Utils.regularTextStyle(
                                  color: selectIndex == 2
                                      ? AppColor.textColor2
                                      : AppColor.textColor3),
                            ),
                          ),
                          Container(
                            width: 2,
                            color: AppColor.floatBg1,
                          ),
                          InkWell(
                            onTap: () {
                              setState(() {
                                selectIndex = 3;
                              });
                            },
                            child: Text(
                              "Details",
                              style: Utils.regularTextStyle(
                                  color: selectIndex == 3
                                      ? AppColor.textColor2
                                      : AppColor.textColor3),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10.w,
                    ),
                    selectIndex == 1
                        ? Expanded(
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: 2,
                              itemBuilder: (context, index) {
                                return Card(
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                        top: 3.w,
                                        bottom: 6.w,
                                        left: 3.w,
                                        right: 3.w),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Text(
                                          "just now",
                                          style: Utils.regularTextStyle(
                                              color: AppColor.textColor8,
                                              fontSize: AppDimens.default_font),
                                        ),
                                        Row(
                                          children: [
                                            Container(
                                              height: 8.w,
                                              width: 8.w,
                                              decoration: BoxDecoration(
                                                  image: DecorationImage(
                                                      image: AssetImage(
                                                          ImageAsset.ellipse))),
                                            ),
                                            SizedBox(
                                              width: 3.w,
                                            ),
                                            Text(
                                              "is the PO place for this material?",
                                              style: Utils.regularTextStyle(
                                                  color: AppColor.black,
                                                  fontSize:
                                                      AppDimens.default_font),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          )
                        : selectIndex == 2
                            ? Expanded(child: Container())
                            : Expanded(
                                child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Issue raised on - dd/mm/yy"),
                                  SizedBox(
                                    height: 5.w,
                                  ),
                                  Text("Task -"),
                                  SizedBox(
                                    height: 5.w,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("Team members- "),
                                      Text(
                                        "add member +",
                                        style: Utils.regularTextStyle(color: AppColor.dotColor),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 5.w,
                                  ),
                                  Expanded(
                                    child: ListView.builder(
                                      itemCount: 12,
                                      shrinkWrap: true,
                                      itemBuilder: (context, index) {
                                        return Card(
                                          child: Padding(
                                            padding: EdgeInsets.all(3.w),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text("Pooja"),
                                                Text("remove"),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              )),
                    selectIndex == 3
                        ? Container()
                        : Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Align(
                                alignment: Alignment.bottomCenter,
                                child: Container(
                                  height: 12.w,
                                  width: 100.w,
                                  decoration: BoxDecoration(
                                      border:
                                          Border.all(color: AppColor.otpBox),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(50))),
                                  child: Row(
                                    children: [
                                      Container(
                                        height: 12.w,
                                        width: 75.w,
                                        child: TextField(
                                          decoration: InputDecoration(
                                            hintText: "Add comment",
                                            hintStyle: Utils.regularTextStyle(
                                                color: AppColor.hintText),
                                            contentPadding: EdgeInsets.all(3.w),
                                            enabledBorder: InputBorder.none,
                                            focusedBorder: InputBorder.none,
                                          ),
                                        ),
                                      ),
                                      selectIndex == 1
                                          ? Padding(
                                              padding:
                                                  EdgeInsets.only(right: 2.w),
                                              child: Text("Post"),
                                            )
                                          : Text("Attach")
                                    ],
                                  ),
                                )),
                          ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
