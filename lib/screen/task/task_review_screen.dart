import 'package:cached_network_image/cached_network_image.dart';
import 'package:constructin/model/task_review_model.dart';
import 'package:constructin/screen/task/task_issue_screen.dart';
import 'package:constructin/utils/api_services.dart';
import 'package:constructin/utils/app_color.dart';
import 'package:constructin/widget/comman_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:sizer/sizer.dart';

import '../../utils/app_asset.dart';
import '../../utils/app_dimens.dart';
import '../../utils/app_string.dart';
import '../../utils/toasts.dart';
import '../../utils/util.dart';
import '../issue_details_screen.dart';
import 'full_screen_image.dart';

class TaskReviewScreen extends StatefulWidget {
  int? id, day;

  TaskReviewScreen({this.id, this.day});

  @override
  State<TaskReviewScreen> createState() => _TaskReviewScreenState();
}

enum Menu { itemOne }

class _TaskReviewScreenState extends State<TaskReviewScreen> {
  TaskReviewData taskDetailsModel = TaskReviewData();
  String? startDate, endDate;
  List<String> dateList = [];

  List<AttachmentData> attachmentList = [];
  List<String> list = ["Timeline", "Issue register", "Photos"];
  int selectIndex = 0;
  int progress = 0;
  int progress1 = 0;

  String today = DateFormat("dd/MM/yyyy").format(DateTime.now());
  String yesterday = DateFormat("dd/MM/yyyy")
      .format(DateTime.now().subtract(Duration(days: 1)));

  @override
  void initState() {
    ApiServices.getTaskView(widget.id!)?.then((value) {
      setState(() {
        taskDetailsModel = value;
        startDate = Utils.showData(taskDetailsModel.startDate!);
        endDate = Utils.showData(taskDetailsModel.endDate!);
        if (taskDetailsModel.attachment != null) {
          for (int i = 0; i < taskDetailsModel.attachment!.length; i++) {
            DateTime parseDate = DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'")
                .parse(taskDetailsModel.attachment![i].createdAt);
            var inputDate = DateTime.parse(parseDate.toString());
            var outputFormat = DateFormat('dd/MM/yyyy');
            var outputDate = outputFormat.format(inputDate);
            if (dateList.isEmpty) {
              dateList.add(outputDate.toString());
            } else if (!dateList.contains(outputDate.toString())) {
              dateList.add(outputDate.toString());
            }
          }

          for (int j = 0; j < dateList.length; j++) {
            List<String> imageList = [];
            for (int k = 0; k < taskDetailsModel.attachment!.length; k++) {
              DateTime parseDate = DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'")
                  .parse(taskDetailsModel.attachment![k].createdAt);
              var inputDate = DateTime.parse(parseDate.toString());
              var outputFormat = DateFormat('dd/MM/yyyy');
              var outputDate = outputFormat.format(inputDate);
              if (dateList[j].toString().trim() ==
                  outputDate.toString().trim()) {
                imageList.add(taskDetailsModel.attachment![k].image);
              }
            }
            attachmentList
                .add(AttachmentData(date: dateList[j], image: imageList));
          }
        }
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColor.white,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            appBar("Task Review- ${taskDetailsModel.title ?? ""}", () {
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
                                            child: Text(startDate ?? "",
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
                                                endDate ?? "",
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
                                "${taskDetailsModel.workCompleted ?? "0"} out of ${taskDetailsModel.totalWork} ${taskDetailsModel.taskUnit?.title} completed",
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
                                      percent: double.parse(
                                              taskDetailsModel.taskProgress ??
                                                  "0.0") /
                                          100,
                                      center: Text(
                                        "${double.parse(taskDetailsModel.taskProgress ?? "0.0").toStringAsFixed(0)}%",
                                        style: Utils.regularTextStyle(
                                            color: AppColor.progressPercent,
                                            fontSize: 10.0),
                                      ),
                                      progressColor: Colors.green,
                                    ),
                                  ),
                                  Text(
                                    "${widget.day}-days left",
                                    style: Utils.regularTextStyle(
                                        color: AppColor.textColor2,
                                        fontSize: AppDimens.large_font),
                                  ),
                                  Text(
                                    "${taskDetailsModel.issuesCount ?? 0} issues",
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
                        taskDetailsModel.dataTaskProgress?.length == null
                            ? Center(child: CircularProgressIndicator())
                            : Expanded(
                                child: taskDetailsModel
                                        .dataTaskProgress!.isEmpty
                                    ? Center(child: Text("Not Data Found"))
                                    : ListView.builder(
                                        shrinkWrap: true,
                                        key: UniqueKey(),
                                        itemCount: taskDetailsModel
                                            .dataTaskProgress?.length,
                                        itemBuilder: (context, index) {
                                          progress = int.parse(taskDetailsModel
                                                  .dataTaskProgress?[index]
                                                  .todayProgress ??
                                              "0");
                                          if (index != 0) {
                                            progress1 = progress1 +
                                                int.parse(taskDetailsModel
                                                        .dataTaskProgress?[
                                                            index - 1]
                                                        .todayProgress ??
                                                    "0");
                                          }
                                          String? date;
                                          date = Utils.showData(taskDetailsModel
                                                  .dataTaskProgress?[index]
                                                  .date ??
                                              "");
                                          return Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  date,
                                                  style: Utils.regularTextStyle(
                                                      color:
                                                          AppColor.textColor3,
                                                      fontSize: AppDimens
                                                          .default_font),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          "Daily Progress - ${taskDetailsModel.dataTaskProgress?[index].todayProgress} cum.",
                                                          style: Utils
                                                              .regularTextStyle(
                                                                  color: AppColor
                                                                      .textColor3,
                                                                  fontSize:
                                                                      3.5.w),
                                                        ),
                                                        SizedBox(
                                                          height: 1.w,
                                                        ),
                                                        Text(
                                                          "Total Progress - ${progress1 + progress}   | ${taskDetailsModel.totalWork} cum.",
                                                          style: Utils
                                                              .regularTextStyle(
                                                                  color: AppColor
                                                                      .textColor3,
                                                                  fontSize:
                                                                      3.5.w),
                                                        ),
                                                        SizedBox(
                                                          height: 1.w,
                                                        ),
                                                        SingleChildScrollView(
                                                          scrollDirection:
                                                              Axis.horizontal,
                                                          child: Text(
                                                            "Manpower  - ${taskDetailsModel.dataTaskProgress?[index].attendeesSkilled ?? "0"} Skilled | ${taskDetailsModel.dataTaskProgress?[index].attendeesSemiSkilled ?? "0"} Semiskilled | ${taskDetailsModel.dataTaskProgress?[index].attendeesUnskilled ?? "0"} Unskilled",
                                                            style: Utils
                                                                .regularTextStyle(
                                                                    color: AppColor
                                                                        .textColor3,
                                                                    fontSize:
                                                                        3.5.w),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: 1.w,
                                                        ),
                                                        Text(
                                                          "Open Issues - ${taskDetailsModel.issuesCount} nos.",
                                                          style: Utils
                                                              .regularTextStyle(
                                                                  color: AppColor
                                                                      .textColor3,
                                                                  fontSize:
                                                                      3.5.w),
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
                    ? Expanded(
                        child: Padding(
                          padding: EdgeInsets.all(3.w),
                          child: taskDetailsModel.issues!.isEmpty
                              ? Center(child: Text("Not Data Found"))
                              : ListView.builder(
                                  shrinkWrap: true,
                                  padding: EdgeInsets.zero,
                                  itemCount: taskDetailsModel.issues?.length,
                                  itemBuilder: (context, index) {
                                    var outputFormat =
                                        DateFormat("hh:mm a, dd MMM, yyyy");
                                    var outputDate = outputFormat.format(
                                        taskDetailsModel
                                            .issues![index].createdAt!);
                                    return Stack(
                                      children: [
                                        SizedBox(
                                          height: 48.w,
                                          child: Card(
                                            child: Padding(
                                              padding: EdgeInsets.all(2.w),
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
                                                                color: AppColor
                                                                    .green1,
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            5)),
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(8.0),
                                                              child: Text(
                                                                " ${taskDetailsModel.issues?[index].issueCategory?.title ?? ""}",
                                                                style: Utils.regularTextStyle(
                                                                    color: AppColor
                                                                        .green),
                                                              ),
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            width: 5.w,
                                                          ),
                                                          Container(
                                                            width: 18.w,
                                                            decoration: BoxDecoration(
                                                                color: AppColor
                                                                    .btnUpdateBg,
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            5)),
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(8.0),
                                                              child: Text(
                                                                taskDetailsModel
                                                                        .title ??
                                                                    "",
                                                                overflow:
                                                                    TextOverflow
                                                                        .clip,
                                                                maxLines: 4,
                                                                style: Utils.regularTextStyle(
                                                                    color: AppColor
                                                                        .textColor2),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      PopupMenuButton(
                                                          child: Icon(
                                                            Icons.more_vert,
                                                            color: AppColor
                                                                .textColor2,
                                                            size: 30,
                                                          ),
                                                          onSelected:
                                                              (Menu item) {
                                                            setState(() {
                                                              Navigator.push(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                      builder:
                                                                          (_) {
                                                                return TaskIssueScreen(
                                                                  tag: 0,
                                                                  edit: 1,
                                                                  id: taskDetailsModel
                                                                      .issues?[
                                                                          index]
                                                                      .id,
                                                                  issueData:
                                                                      taskDetailsModel
                                                                              .issues?[
                                                                          index],
                                                                );
                                                              })).then((value) {
                                                                if (value !=
                                                                    null) {
                                                                  setState(() {
                                                                    taskDetailsModel
                                                                        .issues?[
                                                                            index]
                                                                        .issueCategory!
                                                                        .title = value.issueCategory!.title;
                                                                    taskDetailsModel
                                                                        .issues?[
                                                                            index]
                                                                        .title = value.title;
                                                                  });
                                                                }
                                                              });
                                                            });
                                                          },
                                                          itemBuilder: (BuildContext
                                                                  context) =>
                                                              <
                                                                  PopupMenuEntry<
                                                                      Menu>>[
                                                                const PopupMenuItem<
                                                                    Menu>(
                                                                  value: Menu
                                                                      .itemOne,
                                                                  child: Text(
                                                                      'Issue edit'),
                                                                ),
                                                              ]),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    height: 3.w,
                                                  ),
                                                  Text(
                                                    " ${taskDetailsModel.issues?[index].title ?? ""}",
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    maxLines: 1,
                                                    style:
                                                        Utils.regularTextStyle(
                                                            color: AppColor
                                                                .textColor),
                                                  ),
                                                  SizedBox(
                                                    height: 3.w,
                                                  ),
                                                  Row(
                                                    children: [
                                                      Container(
                                                        height: 10.w,
                                                        width: 10.w,
                                                        decoration: BoxDecoration(
                                                            shape:
                                                                BoxShape.circle,
                                                            border: Border.all(
                                                                color: AppColor
                                                                    .black,
                                                                width: 1)),
                                                        child: taskDetailsModel
                                                                    .issues?[
                                                                        index]
                                                                    .teamDetails
                                                                    ?.image ==
                                                                null
                                                            ? Icon(
                                                                Icons.person,
                                                                size: 8.w,
                                                              )
                                                            : CircleAvatar(
                                                                radius: 200.0,
                                                                backgroundImage: NetworkImage(AppString
                                                                        .basePath +
                                                                    taskDetailsModel
                                                                        .issues?[
                                                                            index]
                                                                        .teamDetails
                                                                        ?.image),
                                                              ),
                                                      ),
                                                      SizedBox(
                                                        width: 2.w,
                                                      ),
                                                      Text(
                                                        " ${taskDetailsModel.issues?[index].teamDetails?.name ?? taskDetailsModel.issues?[index].teamDetails?.mobile ?? ""}",
                                                        style: Utils
                                                            .regularTextStyle(
                                                                color: AppColor
                                                                    .textColor8,
                                                                fontSize:
                                                                    2.4.w),
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
                                                        outputDate,
                                                        style: Utils
                                                            .regularTextStyle(
                                                                color: AppColor
                                                                    .textColor8,
                                                                fontSize:
                                                                    2.4.w),
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
                                                      InkWell(
                                                        onTap: () {
                                                          Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                  builder: (_) {
                                                            return IssueDetailsScreen(
                                                              data: taskDetailsModel
                                                                      .issues![
                                                                  index],
                                                            );
                                                          })).then((value) {
                                                            setState(() {
                                                              taskDetailsModel
                                                                      .issues?[
                                                                          index]
                                                                      .commentCount =
                                                                  value;
                                                            });
                                                          });
                                                        },
                                                        child: Row(
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
                                                            SizedBox(
                                                              width: 2,
                                                            ),
                                                            Text(
                                                              taskDetailsModel
                                                                      .issues?[
                                                                          index]
                                                                      .commentCount
                                                                      ?.toString() ??
                                                                  "0",
                                                              style: Utils
                                                                  .regularTextStyle(),
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                      taskDetailsModel
                                                                  .issues?[
                                                                      index]
                                                                  .status ==
                                                              1
                                                          ? InkWell(
                                                              onTap: () {
                                                                closeBottomSheet(
                                                                    context,
                                                                    () {
                                                                  ApiServices.poseIssueClose(
                                                                          taskDetailsModel.issues?[index].id ??
                                                                              0)
                                                                      .then(
                                                                          (value) {
                                                                    setState(
                                                                        () {
                                                                      taskDetailsModel
                                                                          .issues?[
                                                                              index]
                                                                          .status = value;
                                                                    });
                                                                  });
                                                                  Navigator.of(
                                                                          context)
                                                                      .pop();
                                                                });
                                                              },
                                                              child: Container(
                                                                decoration: BoxDecoration(
                                                                    borderRadius:
                                                                        BorderRadius.all(Radius.circular(
                                                                            5)),
                                                                    border: Border.all(
                                                                        color: AppColor
                                                                            .red1,
                                                                        width:
                                                                            2)),
                                                                child: Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                              .all(
                                                                          8.0),
                                                                  child: Text(
                                                                    AppString
                                                                        .strCloseIssue,
                                                                    style: Utils
                                                                        .regularTextStyle(
                                                                            color:
                                                                                AppColor.red1),
                                                                  ),
                                                                ),
                                                              ),
                                                            )
                                                          : Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(8.0),
                                                              child: Text(
                                                                AppString
                                                                    .strCloseIssue,
                                                                style: Utils
                                                                    .regularTextStyle(
                                                                        color: AppColor
                                                                            .red1),
                                                              )),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        taskDetailsModel
                                                    .issues?[index].status !=
                                                1
                                            ? Padding(
                                                padding: EdgeInsets.all(1.w),
                                                child: InkWell(
                                                  onTap: () {
                                                    Toasts.showToast(
                                                        "Issue close already");
                                                  },
                                                  child: Container(
                                                    height: 46.w,
                                                    decoration: BoxDecoration(
                                                        color: AppColor.white4,
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    5))),
                                                  ),
                                                ),
                                              )
                                            : Container()
                                      ],
                                    );
                                  },
                                ),
                        ),
                      )
                    : Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                                child: attachmentList.isEmpty
                                    ? Center(child: Text("Not Data Found"))
                                    : SingleChildScrollView(
                                        child: ListView.builder(
                                            shrinkWrap: true,
                                            itemCount: attachmentList.length,
                                            physics:
                                                NeverScrollableScrollPhysics(),
                                            reverse: true,
                                            itemBuilder: (context, i) {
                                              return Padding(
                                                padding: EdgeInsets.all(2.w),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Text(
                                                        today
                                                                    .toString()
                                                                    .trim() ==
                                                                attachmentList[
                                                                        i]
                                                                    .date!
                                                            ? "Today"
                                                            : yesterday
                                                                        .toString()
                                                                        .trim() ==
                                                                    attachmentList[
                                                                            i]
                                                                        .date!
                                                                ? "Yesterday"
                                                                : attachmentList[
                                                                            i]
                                                                        .date ??
                                                                    "",
                                                        style: Utils
                                                            .mediumTextStyle(),
                                                      ),
                                                    ),
                                                    GridView.builder(
                                                      gridDelegate:
                                                          const SliverGridDelegateWithFixedCrossAxisCount(
                                                        crossAxisCount: 3,
                                                      ),
                                                      itemCount:
                                                          attachmentList[i]
                                                              .image!
                                                              .length,
                                                      shrinkWrap: true,
                                                      addAutomaticKeepAlives:
                                                          false,
                                                      physics:
                                                          NeverScrollableScrollPhysics(),
                                                      itemBuilder:
                                                          (context, index) {
                                                        final path =
                                                            attachmentList[i]
                                                                .image![index]
                                                                .split(".")
                                                                .last;
                                                        return InkWell(
                                                          onTap: () {
                                                            Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                    builder:
                                                                        (_) {
                                                              return FullScreen(
                                                                  url: attachmentList[
                                                                              i]
                                                                          .image![
                                                                      index],
                                                                  extention:
                                                                      path);
                                                            }));
                                                          },
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(8.0),
                                                            child: path != "pdf"
                                                                ? ClipRRect(
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .circular(5),
                                                                    child:
                                                                        CachedNetworkImage(
                                                                      height:
                                                                          10.w,
                                                                      width:
                                                                          10.w,
                                                                      fit: BoxFit
                                                                          .cover,
                                                                      imageUrl: (AppString
                                                                              .basePath) +
                                                                          (attachmentList[i]
                                                                              .image![index]),
                                                                      progressIndicatorBuilder: (context,
                                                                              url,
                                                                              downloadProgress) =>
                                                                          Center(
                                                                        child:
                                                                            SizedBox(
                                                                          height:
                                                                              10.w,
                                                                          width:
                                                                              10.w,
                                                                          child:
                                                                              CircularProgressIndicator(value: downloadProgress.progress),
                                                                        ),
                                                                      ),
                                                                      errorWidget: (context,
                                                                              url,
                                                                              error) =>
                                                                          Icon(Icons
                                                                              .error),
                                                                    ),
                                                                  )
                                                                : Icon(
                                                                    Icons
                                                                        .picture_as_pdf_outlined,
                                                                    size: 10.w,
                                                                  ),
                                                          ),
                                                        );
                                                      },
                                                    )
                                                  ],
                                                ),
                                              );
                                            }),
                                      ))
                          ],
                        ),
                      ),
          ],
        ),
      ),
    );
  }
}

class AttachmentData {
  String? date;
  List<String>? image;

  AttachmentData({this.date, this.image});
}
