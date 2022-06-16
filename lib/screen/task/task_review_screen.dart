import 'package:constructin/utils/app_color.dart';
import 'package:constructin/widget/comman_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:sizer/sizer.dart';

import '../../utils/app_asset.dart';
import '../../utils/app_dimens.dart';
import '../../utils/unil.dart';

class TaskReviewScreen extends StatefulWidget {
  const TaskReviewScreen({Key? key}) : super(key: key);

  @override
  State<TaskReviewScreen> createState() => _TaskReviewScreenState();
}

class _TaskReviewScreenState extends State<TaskReviewScreen> {
  TextEditingController startDateController = TextEditingController();
  TextEditingController endDateController = TextEditingController();

  @override
  void initState() {
    startDateController.text = "1/4/2022";
    endDateController.text = "1/6/2022";
    super.initState();
  }

  List<String> list = ["Timeline", "Issue register", "Photos"];
  int selectIndex = 1;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColor.white,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            appBar("Tack Review- Excavation", () {
              Get.back();
            }),
            Padding(
              padding: EdgeInsets.only(left: 3.w, right: 3.w),
              child: SizedBox(
                height: 16.w,
                width: double.infinity,
                child: ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: list.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          setState(() {
                            selectIndex = index;
                          });
                        },
                        child: Padding(
                          padding:
                              EdgeInsets.only(left: 2.w, right: 2.w, top: 6.w),
                          child: Container(
                            decoration: BoxDecoration(
                                color: selectIndex == index
                                    ? AppColor.cBg
                                    : AppColor.white,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.0)),
                                border: Border.all(
                                    color: selectIndex == index
                                        ? AppColor.textColor2
                                        : AppColor.textColor4,
                                    width: 2)),
                            child: Center(
                                child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                list[index],
                                style: Utils.mediumTextStyle(
                                    color: selectIndex == index
                                        ? AppColor.textColor2
                                        : AppColor.textColor4),
                              ),
                            )),
                          ),
                        ),
                      );
                    }),
              ),
            ),
            selectIndex == 0
                ? Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.all(4.w),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 5.w,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Start date",
                                          style: Utils.regularTextStyle(
                                              color: AppColor.textColor,
                                              fontSize: AppDimens.medium_font),
                                        ),
                                        SizedBox(
                                          height: 2.w,
                                        ),
                                        Container(
                                          decoration: BoxDecoration(
                                              color: AppColor.textFormFieldBg,
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(5))),
                                          child: Padding(
                                            padding: EdgeInsets.only(
                                                left: 2.w,
                                                right: 20.w,
                                                top: 2.w,
                                                bottom: 2.w),
                                            child: Text("1/4/2022",
                                                style: Utils.regularTextStyle(
                                                    color: AppColor.textColor)),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: InkWell(
                                      onTap: () {},
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "End date",
                                            style: Utils.regularTextStyle(
                                                color: AppColor.textColor,
                                                fontSize:
                                                    AppDimens.medium_font),
                                          ),
                                          SizedBox(
                                            height: 2.w,
                                          ),
                                          Container(
                                            decoration: BoxDecoration(
                                                color: AppColor.textFormFieldBg,
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(5))),
                                            child: Padding(
                                              padding: EdgeInsets.only(
                                                  left: 2.w,
                                                  right: 20.w,
                                                  top: 2.w,
                                                  bottom: 2.w),
                                              child: Text(
                                                "1/6/2022",
                                                style: Utils.regularTextStyle(
                                                    color: AppColor.textColor),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 5.w,
                              ),
                              Text(
                                "120 out of 2400 m^3 completed",
                                style: Utils.regularTextStyle(
                                    color: AppColor.textColor,
                                    fontSize: AppDimens.medium_font),
                              ),
                              SizedBox(
                                height: 5.w,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(
                                    height: 15.w,
                                    width: 15.w,
                                    child: CircularPercentIndicator(
                                      radius: 25.0,
                                      lineWidth: 5.0,
                                      percent: 0.1,
                                      center: Text(
                                        "10%",
                                        style: Utils.regularTextStyle(
                                            color: AppColor.progressPercent),
                                      ),
                                      progressColor: Colors.green,
                                    ),
                                  ),
                                  Text(
                                    "-days left",
                                    style: Utils.regularTextStyle(
                                        color: AppColor.textColor2,
                                        fontSize: AppDimens.large_font),
                                  ),
                                  Text(
                                    "-issues",
                                    style: Utils.regularTextStyle(
                                        color: AppColor.red,
                                        fontSize: AppDimens.large_font),
                                  ),
                                  Container(),
                                  Container()
                                ],
                              ),
                              SizedBox(
                                height: 5.w,
                              ),
                              Container(
                                color: AppColor.gray1,
                                height: 1,
                                width: double.infinity,
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "Timeline",
                            style: Utils.mediumTextStyle(
                                color: AppColor.textColor3, fontSize: 5.w),
                          ),
                        ),
                        SizedBox(
                          height: 3.w,
                        ),
                        Expanded(
                          child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: 13,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "30/May/22",
                                        style: Utils.regularTextStyle(
                                            color: AppColor.textColor3,
                                            fontSize: AppDimens.default_font),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "Daily Progress - 200 cum.",
                                                style: Utils.regularTextStyle(
                                                    color: AppColor.textColor3,
                                                    fontSize: 3.5.w),
                                              ),
                                              SizedBox(
                                                height: 1.w,
                                              ),
                                              Text(
                                                "Total Progress - 1200 | 26000 cum.",
                                                style: Utils.regularTextStyle(
                                                    color: AppColor.textColor3,
                                                    fontSize: 3.5.w),
                                              ),
                                              SizedBox(
                                                height: 1.w,
                                              ),
                                              Text(
                                                "Manpower  - 2 Skilled | 0 Semiskilled | 0 Unskilled",
                                                style: Utils.regularTextStyle(
                                                    color: AppColor.textColor3,
                                                    fontSize: 3.5.w),
                                              ),
                                              SizedBox(
                                                height: 1.w,
                                              ),
                                              Text(
                                                "Open Issues - 2 nos.",
                                                style: Utils.regularTextStyle(
                                                    color: AppColor.textColor3,
                                                    fontSize: 3.5.w),
                                              ),
                                            ]),
                                      ),
                                    ],
                                  ),
                                );
                              }),
                        ),
                      ],
                    ),
                  )
                : selectIndex == 1
                    ? Padding(
                        padding: EdgeInsets.all(3.w),
                        child: Expanded(
                          child: ListView(
                            shrinkWrap: true,
                            children: [
                              Text(
                                "Open(2)",
                                style: Utils.mediumTextStyle(
                                    color: AppColor.textColor2),
                              ),
                              SizedBox(
                                height: 70.w,
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  padding: EdgeInsets.zero,
                                  itemCount: 2,
                                  itemBuilder: (context, index) {
                                    return Card(
                                      child: Padding(
                                        padding: EdgeInsets.all(4.w),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Row(
                                                  children: [
                                                    Container(
                                                      decoration: BoxDecoration(
                                                          color:
                                                              AppColor.green1,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(5)),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Text(
                                                          "Material",
                                                          style: Utils
                                                              .regularTextStyle(
                                                                  color: AppColor
                                                                      .green),
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: 5.w,
                                                    ),
                                                    Container(
                                                      decoration: BoxDecoration(
                                                          color: AppColor
                                                              .btnUpdateBg,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(5)),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Text(
                                                          "Excavation",
                                                          style: Utils
                                                              .regularTextStyle(
                                                                  color: AppColor
                                                                      .textColor2),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(
                                                    height: 8.w,
                                                    width: 8.w,
                                                    child: Image.asset(
                                                        ImageAsset.icons_more)),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 3.w,
                                            ),
                                            Text(
                                              "Material shortage at site due to price hike and other reasons",
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                              style: Utils.regularTextStyle(
                                                  color: AppColor.green),
                                            ),
                                            SizedBox(
                                              height: 3.w,
                                            ),
                                            Row(
                                              children: [
                                                Container(
                                                  height: 8.w,
                                                  width: 8.w,
                                                  decoration: BoxDecoration(
                                                      image: DecorationImage(
                                                          image: AssetImage(
                                                              ImageAsset
                                                                  .ellipse))),
                                                ),
                                                SizedBox(
                                                  width: 2.w,
                                                ),
                                                Text(
                                                  "John Doe",
                                                  style: Utils.regularTextStyle(
                                                      color:
                                                          AppColor.textColor8,
                                                      fontSize: 2.4.w),
                                                ),
                                                SizedBox(
                                                  width: 2.w,
                                                ),
                                                Container(
                                                  height: 8.w,
                                                  width: 8.w,
                                                  decoration: BoxDecoration(
                                                      image: DecorationImage(
                                                          image: AssetImage(
                                                              ImageAsset
                                                                  .iconSchedule))),
                                                ),
                                                SizedBox(
                                                  width: 2.w,
                                                ),
                                                Text(
                                                  "10:00 AM, 24th May 2022",
                                                  style: Utils.regularTextStyle(
                                                      color:
                                                          AppColor.textColor8,
                                                      fontSize: 2.4.w),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 3.w,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Container(
                                                  height: 5.w,
                                                  width: 5.w,
                                                  decoration: BoxDecoration(
                                                      image: DecorationImage(
                                                          image: AssetImage(
                                                              ImageAsset
                                                                  .iconChat))),
                                                ),
                                                Container(
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  5)),
                                                      border: Border.all(
                                                          color: AppColor.red1,
                                                          width: 2)),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Text(
                                                      "Close issue",
                                                      style: Utils
                                                          .regularTextStyle(
                                                              color: AppColor
                                                                  .red1),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                              SizedBox(
                                height: 3.w,
                              ),
                              Text(
                                "Close(2)",
                                style: Utils.mediumTextStyle(
                                    color: AppColor.textColor2),
                              ),
                              SizedBox(
                                height: 70.w,
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  padding: EdgeInsets.zero,
                                  itemCount: 2,
                                  itemBuilder: (context, index) {
                                    return Card(
                                      child: Padding(
                                        padding: EdgeInsets.all(4.w),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Row(
                                                  children: [
                                                    Container(
                                                      decoration: BoxDecoration(
                                                          color:
                                                              AppColor.green1,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(5)),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Text(
                                                          "Material",
                                                          style: Utils
                                                              .regularTextStyle(
                                                                  color: AppColor
                                                                      .green),
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: 5.w,
                                                    ),
                                                    Container(
                                                      decoration: BoxDecoration(
                                                          color: AppColor
                                                              .btnUpdateBg,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(5)),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Text(
                                                          "Excavation",
                                                          style: Utils
                                                              .regularTextStyle(
                                                                  color: AppColor
                                                                      .textColor2),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(
                                                    height: 8.w,
                                                    width: 8.w,
                                                    child: Image.asset(
                                                        ImageAsset.icons_more)),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 3.w,
                                            ),
                                            Text(
                                              "Material shortage at site due to price hike and other reasons",
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                              style: Utils.regularTextStyle(
                                                  color: AppColor.green),
                                            ),
                                            SizedBox(
                                              height: 3.w,
                                            ),
                                            Row(
                                              children: [
                                                Container(
                                                  height: 8.w,
                                                  width: 8.w,
                                                  decoration: BoxDecoration(
                                                      image: DecorationImage(
                                                          image: AssetImage(
                                                              ImageAsset
                                                                  .ellipse))),
                                                ),
                                                SizedBox(
                                                  width: 2.w,
                                                ),
                                                Text(
                                                  "John Doe",
                                                  style: Utils.regularTextStyle(
                                                      color:
                                                          AppColor.textColor8,
                                                      fontSize: 2.4.w),
                                                ),
                                                SizedBox(
                                                  width: 2.w,
                                                ),
                                                Container(
                                                  height: 8.w,
                                                  width: 8.w,
                                                  decoration: BoxDecoration(
                                                      image: DecorationImage(
                                                          image: AssetImage(
                                                              ImageAsset
                                                                  .iconSchedule))),
                                                ),
                                                SizedBox(
                                                  width: 2.w,
                                                ),
                                                Text(
                                                  "10:00 AM, 24th May 2022",
                                                  style: Utils.regularTextStyle(
                                                      color:
                                                          AppColor.textColor8,
                                                      fontSize: 2.4.w),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 3.w,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Container(
                                                  height: 5.w,
                                                  width: 5.w,
                                                  decoration: BoxDecoration(
                                                      image: DecorationImage(
                                                          image: AssetImage(
                                                              ImageAsset
                                                                  .iconChat))),
                                                ),
                                                Container(
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  5)),
                                                      border: Border.all(
                                                          color: AppColor.red1,
                                                          width: 2)),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Text(
                                                      "Close issue",
                                                      style: Utils
                                                          .regularTextStyle(
                                                              color: AppColor
                                                                  .red1),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    : Expanded(
                        child: Padding(
                          padding: EdgeInsets.all(4.w),
                          child: Text(
                            "dd/mm/yy",
                            style: Utils.mediumTextStyle(
                                color: AppColor.textColor,
                                fontSize: AppDimens.medium_font),
                          ),
                        ),
                      ),
          ],
        ),
      ),
    );
  }
}
