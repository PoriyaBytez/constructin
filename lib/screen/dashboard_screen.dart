import 'package:constructin/bloc/task_bloc/task_bloc.dart';
import 'package:constructin/helper/route_helper.dart';
import 'package:constructin/screen/task/add_task_screen.dart';
import 'package:constructin/utils/app_string.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:sizer/sizer.dart';

import '../model/task_model.dart';
import '../utils/app_asset.dart';
import '../utils/app_color.dart';
import '../utils/app_dimens.dart';
import '../utils/unil.dart';

class DashBoardScreen extends StatefulWidget {
  const DashBoardScreen({Key? key}) : super(key: key);

  @override
  State<DashBoardScreen> createState() => _DashBoardScreenState();
}

class _DashBoardScreenState extends State<DashBoardScreen> {
  List<String> list = ['All', 'Not started', 'In progress', 'Slow', 'Delayed'];
  int selectIndex1 = 0;
  int selectIndex = 1;
  bool listNull = false;
  TaskBloc? taskBloc;
  bool isLoading = false;
  List<TaskDetailsList> taskDetailsList = [];
  int? projectId;

  @override
  void initState() {
    taskBloc = BlocProvider.of<TaskBloc>(context);
    projectId = Get.arguments;
    print("id   project : ${Get.arguments}");
    taskBloc?.add(TaskPressed(projectId: Get.arguments));
    super.initState();
  }

  int daysElapsedSince(DateTime from, DateTime to) {
// get the difference in term of days, and not just a 24h difference
    from = DateTime(from.year, from.month, from.day);
    to = DateTime(to.year, to.month, to.day);

    return to.difference(from).inDays;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Container(
              height: 15.w,
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColor.white,
                boxShadow: const <BoxShadow>[
                  BoxShadow(
                      color: AppColor.bg,
                      blurRadius: 10.0,
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
                        InkWell(
                          onTap: () {
                            Get.back();
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(0.0),
                            child: SizedBox(
                                height: 5.w,
                                width: 7.w,
                                child: Image.asset(ImageAsset.arrow_back)),
                          ),
                        ),
                        SizedBox(
                          width: 5.w,
                        ),
                        Text(
                          "Projects 1",
                          style: Utils.mediumTextStyle(
                              color: AppColor.textColor,
                              fontSize: AppDimens.large_font),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                              right: 6.w, top: 1.w, bottom: 1.w),
                          child: Image.asset(ImageAsset.iconFilter),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              right: 5.w, top: 1.w, bottom: 1.w),
                          child: Image.asset(ImageAsset.iconsSearch),
                        ),
                        SizedBox(
                          width: 10.w,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            selectIndex == 1
                ? Expanded(
                    child: BlocListener<TaskBloc, TaskState>(
                      listener: (context, state) {
                        if (state is TaskLoading) {
                          setState(() {
                            isLoading = true;
                          });
                        } else if (state is TaskSuccess) {
                          setState(() {
                            isLoading = false;
                            print("Size : ${state.taskModel.data!.length}");
                            taskDetailsList = state.taskModel.data!;
                          });
                        }
                      },
                      child: Column(
                        children: [
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
                                          selectIndex1 = index;
                                        });
                                      },
                                      child: Padding(
                                        padding: EdgeInsets.only(
                                            left: 2.w, right: 2.w, top: 6.w),
                                        child: Container(
                                          decoration: BoxDecoration(
                                              color: selectIndex1 == index
                                                  ? AppColor.cBg
                                                  : AppColor.white,
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10.0)),
                                              border: Border.all(
                                                  color: selectIndex1 == index
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
                          Expanded(
                            child:
                            isLoading
                                ? Center(
                                    child: CircularProgressIndicator(
                                      color: AppColor.mainColor,
                                    ),
                                  )
                                :
                            taskDetailsList.isEmpty
                                    ? noDataFound()
                                    : ListView.builder(
                                        itemCount: taskDetailsList.length,
                                        shrinkWrap: true,
                                        itemBuilder: (context, index) {
                                          int differentDate = 0;
                                          if (taskDetailsList[index]
                                                  .startDate !=
                                              null) {
                                            DateTime from = DateTime.parse(
                                                taskDetailsList[index]
                                                        .startDate ??
                                                    '');
                                            DateTime to = DateTime.parse(
                                                taskDetailsList[index]
                                                        .endDate ??
                                                    '');
                                            differentDate =
                                                daysElapsedSince(from, to);
                                          }

                                          return Padding(
                                            padding: EdgeInsets.all(5.w),
                                            child: Column(
                                              children: [
                                                Container(
                                                  decoration: BoxDecoration(
                                                      color:
                                                          AppColor.btnUpdateBg,
                                                      borderRadius:
                                                          BorderRadius.only(
                                                              topLeft: Radius
                                                                  .circular(10),
                                                              topRight: Radius
                                                                  .circular(
                                                                      10))),
                                                  child: Padding(
                                                    padding: EdgeInsets.only(
                                                        top: 2.w,
                                                        left: 4.w,
                                                        bottom: 4.w),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Column(
                                                          children: [
                                                            Container(
                                                              decoration: BoxDecoration(
                                                                  color:
                                                                      AppColor
                                                                          .cBg1,
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              5)),
                                                              child: Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .all(
                                                                        8.0),
                                                                child: Text(
                                                                  "Not Stated",
                                                                  style: Utils
                                                                      .regularTextStyle(
                                                                          color:
                                                                              AppColor.textColor1),
                                                                ),
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              height: 2.w,
                                                            ),
                                                            Text(
                                                              taskDetailsList[
                                                                          index]
                                                                      .title ??
                                                                  "",
                                                              style: Utils.mediumTextStyle(
                                                                  fontSize:
                                                                      AppDimens
                                                                          .large_font,
                                                                  color: AppColor
                                                                      .textColor5),
                                                            ),
                                                            Text(
                                                              "",
                                                              style: Utils.regularTextStyle(
                                                                  color: AppColor
                                                                      .textColor1,
                                                                  fontSize:
                                                                      AppDimens
                                                                          .large_font),
                                                            )
                                                          ],
                                                        ),
                                                        Row(
                                                          children: [
                                                            InkWell(
                                                              onTap: () {
                                                                Get.toNamed(
                                                                    RouteHelper
                                                                        .updateTask,
                                                                    arguments:
                                                                        taskDetailsList[
                                                                            index]);
                                                              },
                                                              child: Container(
                                                                decoration: BoxDecoration(
                                                                    color:
                                                                        AppColor
                                                                            .cBg,
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            5)),
                                                                child: Padding(
                                                                  padding:
                                                                      EdgeInsets
                                                                          .all(
                                                                              10.0),
                                                                  child: Text(
                                                                    "Update",
                                                                    style: Utils.regularTextStyle(
                                                                        color: AppColor
                                                                            .textColor5,
                                                                        fontSize:
                                                                            AppDimens.large_font),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              width: 2.w,
                                                            ),
                                                            SizedBox(
                                                                height: 7.w,
                                                                width: 10.w,
                                                                child: Image.asset(
                                                                    ImageAsset
                                                                        .icons_more)),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                  decoration: BoxDecoration(
                                                      color: AppColor.cBg,
                                                      borderRadius:
                                                          BorderRadius.only(
                                                              bottomLeft: Radius
                                                                  .circular(10),
                                                              bottomRight:
                                                                  Radius
                                                                      .circular(
                                                                          10))),
                                                  child: Padding(
                                                    padding: EdgeInsets.only(
                                                        bottom: 2.w,
                                                        top: 4.w,
                                                        right: 6.w),
                                                    child: Column(
                                                      children: [
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            SizedBox(
                                                              height: 15.w,
                                                              width: 15.w,
                                                              child:
                                                                  CircularPercentIndicator(
                                                                radius: 25.0,
                                                                lineWidth: 5.0,
                                                                percent: 0.1,
                                                                center: Text(
                                                                  "10%",
                                                                  style: Utils
                                                                      .regularTextStyle(
                                                                          color:
                                                                              AppColor.progressPercent),
                                                                ),
                                                                progressColor:
                                                                    Colors
                                                                        .green,
                                                              ),
                                                            ),
                                                            Text(
                                                              "$differentDate-days left",
                                                              style: Utils.regularTextStyle(
                                                                  color: AppColor
                                                                      .textColor1,
                                                                  fontSize:
                                                                      AppDimens
                                                                          .large_font),
                                                            ),
                                                            Text(
                                                              "-issues",
                                                              style: Utils.regularTextStyle(
                                                                  color: AppColor
                                                                      .textColor1,
                                                                  fontSize:
                                                                      AppDimens
                                                                          .large_font),
                                                            ),
                                                            Container(),
                                                            Container()
                                                          ],
                                                        ),
                                                        Align(
                                                          alignment: Alignment
                                                              .bottomRight,
                                                          child: Text(
                                                            "click for review",
                                                            style: Utils.regularTextStyle(
                                                                color: AppColor
                                                                    .textColor6,
                                                                fontSize: AppDimens
                                                                    .default_font),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                      ),
                          ),
                        ],
                      ),
                    ),
                  )
                : selectIndex == 2
                    ? Expanded(
                        child: Center(
                          child: Text("Attendance"),
                        ),
                      )
                    : selectIndex == 3
                        ? Expanded(
                            child: ListView.builder(
                              shrinkWrap: true,
                              padding: EdgeInsets.all(3.w),
                              itemCount: 5,
                              itemBuilder: (context, index) {
                                return Container(
                                  height: 50.w,
                                  width: 80.w,
                                  child: Card(
                                    child: Padding(
                                      padding: EdgeInsets.all(4.w),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                children: [
                                                  Container(
                                                    decoration: BoxDecoration(
                                                        color: AppColor.green1,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5)),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
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
                                                          const EdgeInsets.all(
                                                              8.0),
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
                                                    color: AppColor.textColor8,
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
                                                    color: AppColor.textColor8,
                                                    fontSize: 2.4.w),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 3.w,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
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
                                                            Radius.circular(5)),
                                                    border: Border.all(
                                                        color: AppColor.red1,
                                                        width: 2)),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Text(
                                                    "Close issue",
                                                    style:
                                                        Utils.regularTextStyle(
                                                            color:
                                                                AppColor.red1),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          )
                        : selectIndex == 4
                            ? Expanded(
                                child: Center(
                                  child: Text("Material"),
                                ),
                              )
                            : selectIndex == 5
                                ? Expanded(
                                    child: Center(
                                      child: Text("More"),
                                    ),
                                  )
                                : Container(),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: 20.w,
                width: double.infinity,
                decoration: BoxDecoration(color: AppColor.white),
                child: Padding(
                  padding: EdgeInsets.only(left: 5.w, right: 5.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      item(
                          1,
                          selectIndex == 1
                              ? ImageAsset.iconPlan
                              : ImageAsset.iconPlan1,
                          "Plan", () {
                        setState(() {
                          selectIndex = 1;
                        });
                      }),
                      item(
                          2,
                          selectIndex == 2
                              ? ImageAsset.iconAttendance
                              : ImageAsset.iconAttendance1,
                          "Attendance", () {
                        setState(() {
                          selectIndex = 2;
                        });
                      }),
                      item(
                          3,
                          selectIndex == 3
                              ? ImageAsset.iconIssues
                              : ImageAsset.iconIssues1,
                          "Issues", () {
                        setState(() {
                          selectIndex = 3;
                        });
                      }),
                      item(
                          4,
                          selectIndex == 4
                              ? ImageAsset.iconMaterial
                              : ImageAsset.iconMaterial1,
                          "Material", () {
                        setState(() {
                          selectIndex = 4;
                        });
                      }),
                      item(
                          5,
                          selectIndex == 5
                              ? ImageAsset.iconMore
                              : ImageAsset.iconMore,
                          "More", () {
                        setState(() {
                          selectIndex = 5;
                        });
                      }),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
        floatingActionButton: taskDetailsList.isEmpty
            ? Container()
            : selectIndex == 1
                ? InkWell(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) {
                        return AddTaskScreen(
                          projectId: projectId!,
                        );
                      })).then((value) {
                        setState(() {
                          taskDetailsList.add(value);
                        });
                      });
                    },
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 22.w),
                      child: Container(
                          height: 10.w,
                          width: 30.w,
                          decoration: BoxDecoration(
                              boxShadow: const <BoxShadow>[
                                BoxShadow(
                                    color: AppColor.white3,
                                    blurRadius: 50.0,
                                    offset: Offset(0.0, 0.75))
                              ],
                              color: AppColor.floatBg1,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(50))),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.add_circle_outline,
                                color: AppColor.textColor3,
                              ),
                              SizedBox(
                                width: 1.w,
                              ),
                              Text(
                                "Add Task",
                                style: Utils.regularTextStyle(),
                              )
                            ],
                          )),
                    ),
                  )
                : Container(),
      ),
    );
  }

  Widget item(int index, String icon, String name, GestureTapCallback? onTab) {
    return InkWell(
      onTap: onTab,
      child: Column(
        children: [
          Container(
            height: 1.w,
            width: 10.w,
            decoration: BoxDecoration(
                color: selectIndex == index ? AppColor.divider : AppColor.white,
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(5),
                    bottomRight: Radius.circular(5))),
          ),
          SizedBox(
            height: 2.w,
          ),
          Container(
            height: 8.w,
            width: 8.w,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage(icon), fit: BoxFit.cover)),
          ),
          SizedBox(
            height: 2.w,
          ),
          Text(
            name,
            style: Utils.regularTextStyle(
                color:
                    selectIndex == index ? AppColor.textColor2 : AppColor.black,
                fontSize: AppDimens.default_font),
          )
        ],
      ),
    );
  }

  Widget noDataFound() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(),
        Container(
            height: 60.w,
            width: 60.w,
            child: Image.asset(ImageAsset.dashboardImage)),
        Text(
          AppString.strAddTasks,
          textAlign: TextAlign.center,
          style: Utils.regularTextStyle(
              color: AppColor.textColor3, fontSize: AppDimens.medium_font),
        ),
        InkWell(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (_) {
              return AddTaskScreen(
                projectId: projectId!,
              );
            })).then((value) {
              setState(() {
                taskDetailsList.add(value);
              });
            });
          },
          child: Padding(
            padding: EdgeInsets.only(bottom: 22.w),
            child: Container(
                height: 15.w,
                width: 70.w,
                decoration: BoxDecoration(
                    boxShadow: const <BoxShadow>[
                      BoxShadow(
                          color: AppColor.white3,
                          blurRadius: 50.0,
                          offset: Offset(0.0, 0.75))
                    ],
                    color: AppColor.floatBg1,
                    borderRadius: BorderRadius.all(Radius.circular(50))),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.add_circle_outline,
                      color: AppColor.textColor3,
                    ),
                    SizedBox(
                      width: 1.w,
                    ),
                    Text(
                      "Add Task",
                      style: Utils.regularTextStyle(
                          fontSize: AppDimens.medium_font),
                    )
                  ],
                )),
          ),
        )
      ],
    );
  }
}
