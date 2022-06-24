import 'dart:io';

import 'package:constructin/screen/task/full_screen_image.dart';
import 'package:constructin/screen/task/task_details_screen.dart';
import 'package:constructin/screen/task/task_issue_screen.dart';
import 'package:constructin/utils/app_asset.dart';
import 'package:constructin/utils/app_color.dart';
import 'package:constructin/utils/app_dimens.dart';
import 'package:constructin/utils/toasts.dart';
import 'package:constructin/utils/unil.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

import '../../bloc/task_update_bloc/task_update_bloc.dart';
import '../../model/task_details_model.dart';
import '../../model/task_image_model.dart';
import '../../model/task_model.dart';
import '../../utils/api_services.dart';
import '../../utils/app_string.dart';
import '../../widget/comman_widget.dart';
import '../../widget/text_form_field.dart';

class UpdateTaskScreen extends StatefulWidget {
  const UpdateTaskScreen({Key? key}) : super(key: key);

  @override
  State<UpdateTaskScreen> createState() => _UpdateTaskScreenState();
}

class _UpdateTaskScreenState extends State<UpdateTaskScreen> {
  TextEditingController quantityController = TextEditingController();
  TextEditingController noGangController = TextEditingController();
  TextEditingController skilledController = TextEditingController();
  TextEditingController semiSkilledController = TextEditingController();
  TextEditingController unSkilledController = TextEditingController();
  int radioValue = 1;
  late TaskDetailsList taskDetailsList;
  late String currentDate;
  String? unit;
  late TaskDetailsData detailsData;
  late TaskUpdateBloc taskUpdateBloc;
  bool isLoading = false;
  var now = DateTime.now();
  var formatter;
  List<String> unitList = [];

  List<TaskImageData> taskImageList = [];

  @override
  void initState() {
    taskUpdateBloc = BlocProvider.of<TaskUpdateBloc>(context);
    taskDetailsList = Get.arguments;
    ApiServices.getUnitList().then((value) {
      for (int i = 0; i < value.data!.length; i++) {
        setState(() {
          unitList.add(value.data![i].title ?? "");
        });
      }
    });
    formatter = DateFormat('yyyy-MM-dd');
    currentDate = formatter.format(now);
    taskUpdateBloc.add(
        TaskUpdatePressed(taskId: taskDetailsList.id ?? 0, date: currentDate));
    ApiServices.getTaskImageList(taskDetailsList.id!).then((value) {
      setState(() {
        taskImageList = value.data!;
      });
    });
    super.initState();
  }

  initValue() {
    setState(() {
      quantityController.text = detailsData.todayProgress ?? "";
      noGangController.text = detailsData.noOfGang ?? "";
      skilledController.text = detailsData.attendeesSkilled ?? "";
      semiSkilledController.text = detailsData.attendeesSemiSkilled ?? "";
      unSkilledController.text = detailsData.attendeesUnskilled ?? "";
      radioValue = int.parse(detailsData.attendees ?? "1");
      currentDate = detailsData.date ?? formatter.format(now);
      // if (detailsData.task?.taskUnit == null) {
      //   unit = "Unit of work";
      // } else {
      Task task = detailsData.task?.taskUnit;
      unit = task.title;
      // taskDetailsList.workCompleted = detailsData.workCompleted;
      // taskDetailsList.taskMembers = detailsData.taskMembers;
      // }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColor.white,
        body: Column(
          children: [
            appBar("Task Update", () {
              Get.back();
            }),
            Expanded(
              child: BlocListener<TaskUpdateBloc, TaskUpdateState>(
                listener: (context, state) {
                  if (state is TaskUpdateLoading) {
                    setState(() {
                      isLoading = true;
                    });
                  } else if (state is TaskUpdateSuccess) {
                    setState(() {
                      isLoading = false;
                      if (state.taskDate != false) {
                        detailsData = state.taskDate;
                        initValue();
                      } else {
                        setState(() {
                          quantityController.text = "";
                          noGangController.text = "";
                          skilledController.text = "";
                          semiSkilledController.text = "";
                          unSkilledController.text = "";
                          radioValue = int.parse("1");
                          // taskDetailsList.workCompleted = 0;
                          // taskDetailsList.taskMembers = 0;
                          unit = "Unit of work";
                        });
                      }
                    });
                  }
                },
                child: Stack(
                  children: [
                    ListView(
                      shrinkWrap: true,
                      children: [
                        Padding(
                          padding: EdgeInsets.all(5.w),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Task Details- ${taskDetailsList.title}",
                                    overflow: TextOverflow.clip,
                                    style: Utils.regularTextStyle(
                                        fontSize: AppDimens.medium_font,
                                        color: AppColor.textColor3),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      Navigator.push(context,
                                          MaterialPageRoute(builder: (_) {
                                        return TaskDetailsScreen(
                                          taskDetailsList: taskDetailsList,
                                          projectID: taskDetailsList.projectId!,
                                          id: taskDetailsList.id!,
                                          startDate:
                                              taskDetailsList.startDate ?? "",
                                          endDate:
                                              taskDetailsList.endDate ?? "",
                                          unitValue:
                                              taskDetailsList.unitId ?? 0,
                                          totalWork:
                                              taskDetailsList.totalWork == null
                                                  ? "null"
                                                  : taskDetailsList.totalWork
                                                      .toString(),
                                        );
                                      })).then((value) {
                                        if (value != null) {
                                          print("taskUnit ${value}");
                                          setState(() {
                                            taskDetailsList.endDate =
                                                value.endDate;
                                            taskDetailsList.totalWork =
                                                value.totalWork;
                                            taskDetailsList.startDate =
                                                value.startDate;
                                            taskDetailsList.unitId =
                                                value?.unitId;
                                            taskDetailsList.taskMembers =
                                                value?.taskMembers;
                                          });
                                        }
                                      });
                                    },
                                    child: Icon(
                                      Icons.edit,
                                      color: AppColor.textColor,
                                    ),
                                  )
                                ],
                              ),
                              SizedBox(
                                height: 2.w,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  firstRow("Member",
                                      taskDetailsList.taskMembers.toString()),
                                  firstRow("EndDate",
                                      taskDetailsList.endDate ?? "-"),
                                  firstRow("Work Completed",
                                      taskDetailsList.workCompleted.toString()),
                                  firstRow(
                                      "Total Work",
                                      taskDetailsList.totalWork == null
                                          ? "0"
                                          : taskDetailsList.totalWork
                                              .toString()),
                                ],
                              ),
                              SizedBox(
                                height: 4.w,
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  boxShadow: const <BoxShadow>[
                                    BoxShadow(
                                        color: AppColor.bg,
                                        blurRadius: 5.0,
                                        offset: Offset(0.0, 0.75))
                                  ],
                                ),
                                child: Column(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(5),
                                            topRight: Radius.circular(5)),
                                        color: AppColor.white1,
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            InkWell(
                                              onTap: () {
                                                setState(() {
                                                  var yesterday = DateTime(
                                                      now.year,
                                                      now.month,
                                                      now.day - 1);
                                                  var formatter =
                                                      DateFormat('yyyy-MM-dd');
                                                  now = yesterday;
                                                  currentDate = formatter
                                                      .format(yesterday);
                                                  taskUpdateBloc.add(
                                                      TaskUpdatePressed(
                                                          taskId:
                                                              taskDetailsList
                                                                      .id ??
                                                                  0,
                                                          date: currentDate));
                                                });
                                              },
                                              child: Icon(
                                                Icons.arrow_back_ios,
                                                color: AppColor.arrowBackColor,
                                              ),
                                            ),
                                            Text(
                                              currentDate,
                                              style: Utils.regularTextStyle(
                                                  fontSize:
                                                      AppDimens.default_font,
                                                  color: AppColor.textColor3),
                                            ),
                                            InkWell(
                                              onTap: () {
                                                setState(() {
                                                  var yesterday = DateTime(
                                                      now.year,
                                                      now.month,
                                                      now.day + 1);
                                                  now = yesterday;
                                                  var formatter =
                                                      DateFormat('yyyy-MM-dd');
                                                  currentDate = formatter
                                                      .format(yesterday);
                                                  taskUpdateBloc.add(
                                                      TaskUpdatePressed(
                                                          taskId:
                                                              taskDetailsList
                                                                      .id ??
                                                                  0,
                                                          date: currentDate));
                                                });
                                              },
                                              child: Icon(
                                                Icons.arrow_forward_ios,
                                                color: AppColor.arrowBackColor,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.only(
                                            bottomLeft: Radius.circular(5),
                                            bottomRight: Radius.circular(5)),
                                        color: AppColor.white,
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.only(
                                                  left: 3.w, top: 3.w),
                                              child: Text(
                                                "Today’s progress",
                                                style: Utils.regularTextStyle(
                                                    fontSize:
                                                        AppDimens.default_font,
                                                    color: AppColor.dotColor),
                                              ),
                                            ),
                                            Row(
                                              children: [
                                                SizedBox(
                                                  width: 60.w,
                                                  child: CommandTextFormField(
                                                    title: AppString
                                                        .strEnterQuantity,
                                                    controller:
                                                        quantityController,
                                                    hint: AppString
                                                        .strEnterQuantity,
                                                    textInputAction:
                                                        TextInputAction.done,
                                                    textInputType:
                                                        TextInputType.number,
                                                    onChange: (value) {},
                                                  ),
                                                ),
                                                Text(
                                                  unit ?? "Unit of work",
                                                  style: Utils.regularTextStyle(
                                                      fontSize: AppDimens
                                                          .default_font,
                                                      color: AppColor.hintText),
                                                ),
                                              ],
                                            ),
                                            Padding(
                                              padding:
                                                  EdgeInsets.only(left: 3.w),
                                              child: Container(
                                                width: 57.w,
                                                height: 8.w,
                                                decoration: BoxDecoration(
                                                    color: AppColor.gray3,
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                5))),
                                                child: Row(
                                                  children: [
                                                    InkWell(
                                                      onTap: () {
                                                        setState(() {
                                                          radioValue = 1;
                                                        });
                                                      },
                                                      child: Padding(
                                                        padding: EdgeInsets.all(
                                                            0.5.w),
                                                        child: Container(
                                                          height: 6.5.w,
                                                          decoration: BoxDecoration(
                                                              color:
                                                                  radioValue ==
                                                                          1
                                                                      ? AppColor
                                                                          .white
                                                                      : AppColor
                                                                          .gray3,
                                                              borderRadius: BorderRadius
                                                                  .all(Radius
                                                                      .circular(
                                                                          5))),
                                                          child: Center(
                                                            child: Padding(
                                                              padding: EdgeInsets
                                                                  .only(
                                                                      left: 2.w,
                                                                      right:
                                                                          2.w),
                                                              child: Text(
                                                                "Add Gang",
                                                                style: Utils.regularTextStyle(
                                                                    color: AppColor
                                                                        .dotColor),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    InkWell(
                                                      onTap: () {
                                                        setState(() {
                                                          radioValue = 2;
                                                        });
                                                      },
                                                      child: Container(
                                                        height: 6.5.w,
                                                        decoration: BoxDecoration(
                                                            color: radioValue ==
                                                                    2
                                                                ? AppColor.white
                                                                : AppColor
                                                                    .gray3,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            5))),
                                                        child: Center(
                                                          child: Padding(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    left: 3.w,
                                                                    right: 3.w),
                                                            child: Text(
                                                              "Add manpower",
                                                              style: Utils.regularTextStyle(
                                                                  color: AppColor
                                                                      .dotColor),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            radioValue == 1
                                                ? Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      SizedBox(
                                                        width: 28.w,
                                                        child:
                                                            CommandTextFormField(
                                                          title: AppString
                                                              .strEnterQuantity,
                                                          controller:
                                                              noGangController,
                                                          hint: AppString
                                                              .strEnterQuantity,
                                                          textInputAction:
                                                              TextInputAction
                                                                  .done,
                                                          textInputType:
                                                              TextInputType
                                                                  .number,
                                                          onChange: (value) {},
                                                        ),
                                                      ),
                                                    ],
                                                  )
                                                : Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Padding(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    left: 3.w,
                                                                    top: 4.w),
                                                            child: Text(
                                                              "Skilled",
                                                              style: Utils.regularTextStyle(
                                                                  color: AppColor
                                                                      .textColor1),
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            width: 28.w,
                                                            child:
                                                                CommandTextFormField(
                                                              title: AppString
                                                                  .strEnterQuantity,
                                                              controller:
                                                                  skilledController,
                                                              hint: AppString
                                                                  .strEnterQuantity,
                                                              textInputAction:
                                                                  TextInputAction
                                                                      .done,
                                                              textInputType:
                                                                  TextInputType
                                                                      .number,
                                                              onChange:
                                                                  (value) {},
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Padding(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    left: 3.w,
                                                                    top: 4.w),
                                                            child: Text(
                                                              "Semi-skilled",
                                                              style: Utils.regularTextStyle(
                                                                  color: AppColor
                                                                      .textColor1),
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            width: 28.w,
                                                            child:
                                                                CommandTextFormField(
                                                              title: AppString
                                                                  .strEnterQuantity,
                                                              controller:
                                                                  semiSkilledController,
                                                              hint: AppString
                                                                  .strEnterQuantity,
                                                              textInputAction:
                                                                  TextInputAction
                                                                      .done,
                                                              textInputType:
                                                                  TextInputType
                                                                      .number,
                                                              onChange:
                                                                  (value) {},
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Padding(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    left: 3.w,
                                                                    top: 4.w),
                                                            child: Text(
                                                              "Unskilled",
                                                              style: Utils.regularTextStyle(
                                                                  color: AppColor
                                                                      .textColor1),
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            width: 28.w,
                                                            child:
                                                                CommandTextFormField(
                                                              title: AppString
                                                                  .strEnterQuantity,
                                                              controller:
                                                                  unSkilledController,
                                                              hint: AppString
                                                                  .strEnterQuantity,
                                                              textInputAction:
                                                                  TextInputAction
                                                                      .done,
                                                              textInputType:
                                                                  TextInputType
                                                                      .number,
                                                              onChange:
                                                                  (value) {},
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                            imageList("Add Photo"),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 3.w,
                              ),
                              InkWell(
                                onTap: () {
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (_) {
                                    return TaskIssueScreen(
                                      taskDetailsList: taskDetailsList,
                                    );
                                  }));
                                },
                                child: Text(
                                  "+ Add issues",
                                  style: Utils.regularTextStyle(
                                      fontSize: AppDimens.large_font,
                                      color: AppColor.textColor3),
                                ),
                              ),
                              SizedBox(
                                height: 3.w,
                              ),
                              SizedBox(
                                height: 50.w,
                                width: 88.w,
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  padding: EdgeInsets.zero,
                                  itemCount: 5,
                                  scrollDirection: Axis.horizontal,
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
                                                                    .circular(
                                                                        5)),
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
                                                                    .circular(
                                                                        5)),
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
                                                          ImageAsset
                                                              .icons_more)),
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
                                                    style:
                                                        Utils.regularTextStyle(
                                                            color: AppColor
                                                                .textColor8,
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
                                                    style:
                                                        Utils.regularTextStyle(
                                                            color: AppColor
                                                                .textColor8,
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
                                                            color:
                                                                AppColor.red1,
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
                                      ),
                                    );
                                  },
                                ),
                              ),
                              InkWell(
                                  onTap: () {
                                    print(
                                        "dsadasd ${taskDetailsList.totalWork}");
                                    if (taskDetailsList.totalWork != null) {
                                      TaskDetailsData data = TaskDetailsData(
                                          projectId: taskDetailsList.projectId,
                                          taskId: taskDetailsList.id,
                                          todayProgress:
                                              quantityController.text,
                                          attendees: radioValue.toString(),
                                          noOfGang: noGangController.text,
                                          attendeesSkilled:
                                              skilledController.text,
                                          attendeesSemiSkilled:
                                              semiSkilledController.text,
                                          attendeesUnskilled:
                                              unSkilledController.text,
                                          remark: "test",
                                          date: currentDate);
                                      ApiServices.postProgress(data)
                                          .then((value) {
                                        setState(() {
                                          TaskDetailsModel data = value;
                                          taskDetailsList.workCompleted =
                                              data.data?.workCompleted;
                                          taskDetailsList.taskMembers =
                                              data.data?.taskMembers;
                                        });
                                      });
                                    } else {
                                      Toasts.showToast(
                                          "Please update ${taskDetailsList.title} task details.");
                                    }
                                  },
                                  child: Image.asset(ImageAsset.btnUpdateSave))
                            ],
                          ),
                        ),
                      ],
                    ),
                    isLoading
                        ? Center(
                            child: CircularProgressIndicator(
                              color: AppColor.mainColor,
                            ),
                          )
                        : Container(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  openCamera(ImageSource source) async {
    XFile? pickedFile = (await ImagePicker().pickImage(
        source: source, maxWidth: 1000, maxHeight: 1000, imageQuality: 10));
    List<MultipartFile> list = [];
    String fileName = File(pickedFile!.path).path.split('/').last;
    list.add(await MultipartFile.fromFile(File(pickedFile.path).path,
        filename: fileName));

    ApiServices.postTaskImage(list, taskDetailsList.id,
            taskDetailsList.projectId, taskDetailsList.registerUserId)
        .then((value) {
      setState(() {
        taskImageList.add(value.data![0]);
        Navigator.pop(context);
      });
    });
  }

  getFilePicker() async {
    final result = await FilePicker.platform.pickFiles(allowMultiple: true);
    print("file  frile  ${result?.files.length}");
    List<MultipartFile> list = [];
    for (int i = 0; i < result!.files.length; i++) {
      String fileName = File(result.files[i].path!).path.split('/').last;
      print(" name $fileName");
      list.add(await MultipartFile.fromFile(File(result.files[i].path!).path,
          filename: fileName));
    }
    ApiServices.postTaskImage(list, taskDetailsList.id,
            taskDetailsList.projectId, taskDetailsList.registerUserId)
        .then((value) {
      setState(() {
        print("value File :${value.data!.length}");
        for (int i = 0; i < value.data!.length; i++) {
          taskImageList.add(value.data![i]);
        }
        Navigator.pop(context);
      });
    });
  }

  Widget imageList(String name) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(
            left: 3.w,
          ),
          child: Text(
            name,
            style: Utils.regularTextStyle(
                fontSize: AppDimens.default_font, color: AppColor.dotColor),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 3.w, top: 3.w),
          child: Row(
            children: [
              InkWell(
                onTap: () {
                  if (taskDetailsList.totalWork != null) {
                    Utils.pickImageDialog(context, () {
                      getFilePicker();
                    }, () {
                      openCamera(ImageSource.camera);
                    });
                  } else {
                    Toasts.showToast(
                        "Please update ${taskDetailsList.title} task details.");
                  }
                },
                child: SizedBox(
                    height: 10.w,
                    width: 10.w,
                    child: Image.asset(ImageAsset.iconSelectPic)),
              ),
              Expanded(
                child: Container(
                  height: 10.w,
                  child: ListView.builder(
                      padding: EdgeInsets.only(right: 2.w, left: 2.w),
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemCount: taskImageList.length,
                      itemBuilder: (context, index) {
                        final path =
                            taskImageList[index].image?.split(".").last;
                        print(path?.split(".").last);
                        print("extenstion $path");
                        return InkWell(
                          onTap: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (_) {
                              return FullScreen(
                                  url: taskImageList[index].image!,
                                  extention: path!);
                            }));
                          },
                          child: Padding(
                            padding: EdgeInsets.only(right: 2.w),
                            child: path != "pdf"
                                ? Container(
                                    height: 10.w,
                                    width: 10.w,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(5)),
                                        image: DecorationImage(
                                            image: NetworkImage(
                                                taskImageList[index].image ??
                                                    ""),
                                            fit: BoxFit.cover)),
                                  )
                                : Icon(
                                    Icons.picture_as_pdf_outlined,
                                    size: 10.w,
                                  ),
                          ),
                        );
                      }),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 2.w,
        )
      ],
    );
  }

  Widget firstRow(String title, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          title,
          style: Utils.regularTextStyle(
              fontSize: AppDimens.indicator_size, color: AppColor.textColor7),
        ),
        SizedBox(
          height: 2.w,
        ),
        Text(
          value,
          overflow: TextOverflow.clip,
          style: Utils.regularTextStyle(fontSize: 2.5.w),
        ),
      ],
    );
  }
}
