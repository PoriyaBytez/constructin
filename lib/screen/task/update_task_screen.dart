import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:constructin/screen/task/full_screen_image.dart';
import 'package:constructin/screen/task/task_details_screen.dart';
import 'package:constructin/screen/task/task_issue_screen.dart';
import 'package:constructin/utils/app_asset.dart';
import 'package:constructin/utils/app_color.dart';
import 'package:constructin/utils/app_dimens.dart';
import 'package:constructin/utils/toasts.dart';
import 'package:constructin/utils/util.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:sizer/sizer.dart';

import '../../bloc/task_update_bloc/task_update_bloc.dart';
import '../../model/issue_model.dart';
import '../../model/task_details_model.dart';
import '../../model/task_image_model.dart';
import '../../model/task_model.dart';
import '../../utils/api_services.dart';
import '../../utils/app_string.dart';
import '../../widget/comman_widget.dart';
import '../../widget/text_form_field.dart';
import '../issue_details_screen.dart';

class UpdateTaskScreen extends StatefulWidget {
  TaskDetailsList? taskDetailsList;

  UpdateTaskScreen({this.taskDetailsList});

  @override
  State<UpdateTaskScreen> createState() => _UpdateTaskScreenState();
}

enum Menu { itemOne, itemTwo }

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
  List<IssueData> issueList = [];

  @override
  void initState() {
    taskDetailsList = widget.taskDetailsList!;
    formatter = DateFormat('dd/MM/yyyy');
    currentDate = formatter.format(now);
    taskUpdateBloc = BlocProvider.of<TaskUpdateBloc>(context);
    taskUpdateBloc.add(
        TaskUpdatePressed(taskId: taskDetailsList.id ?? 0, date: currentDate));
    ApiServices.getUnitList().then((value) {
      for (int i = 0; i < value.data!.length; i++) {
        setState(() {
          unitList.add(value.data![i].title ?? "");
        });
      }
    });
    ApiServices.getTaskImageList(taskDetailsList.id!).then((value) {
      setState(() {
        taskImageList = value.data!;
      });
    });
    ApiServices.getIssueList(taskDetailsList.id!, 1).then((value) {
      setState(() {
        issueList = value.data!;
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
      // currentDate = Utils.showData(detailsData.date) ;
      currentDate =
          Utils.showData(detailsData.date ?? Utils.passData(currentDate));
      unit = detailsData.unitTitle;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColor.white,
        bottomNavigationBar: InkWell(
            onTap: () {
              if (taskDetailsList.totalWork != null) {
                if (quantityController.text != "") {
                  TaskDetailsData data = TaskDetailsData(
                      projectId: taskDetailsList.projectId,
                      taskId: taskDetailsList.id,
                      todayProgress: quantityController.text,
                      attendees: radioValue.toString(),
                      noOfGang: noGangController.text,
                      attendeesSkilled: skilledController.text,
                      attendeesSemiSkilled: semiSkilledController.text,
                      attendeesUnskilled: unSkilledController.text,
                      remark: "test",
                      date: Utils.passData(currentDate));
                  ApiServices.postProgress(data)?.then((value) {
                    setState(() {
                      taskDetailsList.issues_count = value.data?.issues_count;
                      taskDetailsList.taskProgress = value.data?.taskProgress;
                      taskDetailsList.startDate = value.data?.task.startDate;
                      taskDetailsList.endDate = value.data?.task.endDate;
                      Navigator.pop(context, taskDetailsList);
                    });
                  });
                } else {
                  Toasts.showToast("Please update progress details.");
                }
              } else {
                Toasts.showToast(
                    "Please update ${taskDetailsList.title} task details.");
              }
            },
            child: Image.asset(
              ImageAsset.btnUpdateSave,
              height: 18.w,
            )),
        body: WillPopScope(
          onWillPop: () {
            Navigator.pop(context, taskDetailsList);
            return Future(() => false);
          },
          child: Column(
            children: [
              appBar("Task Update", () {
                Navigator.pop(context, taskDetailsList);
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
                                            projectID:
                                                taskDetailsList.projectId!,
                                            id: taskDetailsList.id!,
                                            startDate:
                                                taskDetailsList.startDate ?? "",
                                            endDate:
                                                taskDetailsList.endDate ?? "",
                                            unitValue:
                                                taskDetailsList.unitId ?? 0,
                                            totalWork:
                                                taskDetailsList.totalWork ==
                                                        null
                                                    ? "null"
                                                    : taskDetailsList.totalWork
                                                        .toString(),
                                          );
                                        })).then((value) {
                                          if (value != null) {
                                            if (value!.runtimeType == int) {
                                              setState(() {
                                                taskDetailsList.taskMembers =
                                                    value;
                                              });
                                            } else {
                                              setState(() {
                                                taskDetailsList.endDate =
                                                    value.endDate;
                                                taskDetailsList.totalWork =
                                                    value.totalWork;
                                                taskDetailsList.startDate =
                                                    value.startDate;
                                                unit = value.unitTitle;
                                                taskDetailsList.unitId =
                                                    value.unitId;
                                                taskDetailsList.taskMembers =
                                                    value?.taskMembers;
                                              });
                                            }
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
                                    firstRow(
                                        "EndDate",
                                        Utils.showData(
                                            taskDetailsList.endDate ?? "")),
                                    firstRow(
                                        "Work Completed",
                                        taskDetailsList.workCompleted
                                            .toString()),
                                    firstRow(
                                        "Total Work",
                                        taskDetailsList.totalWork == null
                                            ? "0"
                                            : taskDetailsList.totalWork
                                                .toString()),
                                  ],
                                ),
                                SizedBox(
                                  height: 2.w,
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
                                          padding: EdgeInsets.all(1.5.w),
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
                                                    var formatter = DateFormat(
                                                        'dd/MM/yyyy');
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
                                                  color:
                                                      AppColor.arrowBackColor,
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
                                                    var formatter = DateFormat(
                                                        'dd/MM/yyyy');
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
                                                  color:
                                                      AppColor.arrowBackColor,
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
                                          padding: EdgeInsets.all(1.0.w),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding: EdgeInsets.only(
                                                    left: 3.w, top: 2.w),
                                                child: Text(
                                                  "Today’s progress",
                                                  style: Utils.regularTextStyle(
                                                      fontSize: AppDimens
                                                          .default_font,
                                                      color: AppColor.dotColor),
                                                ),
                                              ),
                                              Row(
                                                children: [
                                                  Expanded(
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
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        right: 10.0),
                                                    child: Text(
                                                      unit ?? "Unit of work",
                                                      style: Utils
                                                          .regularTextStyle(
                                                              fontSize: AppDimens
                                                                  .default_font,
                                                              color: AppColor
                                                                  .hintText),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Padding(
                                                padding:
                                                    EdgeInsets.only(left: 3.w),
                                                child: Row(
                                                  children: [
                                                    Container(
                                                      decoration: BoxDecoration(
                                                          color: AppColor.gray3,
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
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
                                                              padding:
                                                                  EdgeInsets
                                                                      .all(0.5
                                                                          .w),
                                                              child: Container(
                                                                height: 6.5.w,
                                                                decoration: BoxDecoration(
                                                                    color: radioValue ==
                                                                            1
                                                                        ? AppColor
                                                                            .white
                                                                        : AppColor
                                                                            .gray3,
                                                                    borderRadius:
                                                                        BorderRadius.all(
                                                                            Radius.circular(5))),
                                                                child: Center(
                                                                  child:
                                                                      Padding(
                                                                    padding: EdgeInsets.only(
                                                                        left:
                                                                            2.w,
                                                                        right: 2
                                                                            .w),
                                                                    child: Text(
                                                                      "Add Gang",
                                                                      style: Utils.regularTextStyle(
                                                                          color:
                                                                              AppColor.dotColor),
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
                                                            child: Padding(
                                                              padding:
                                                                  EdgeInsets
                                                                      .all(0.5
                                                                          .w),
                                                              child: Container(
                                                                height: 6.5.w,
                                                                decoration: BoxDecoration(
                                                                    color: radioValue ==
                                                                            2
                                                                        ? AppColor
                                                                            .white
                                                                        : AppColor
                                                                            .gray3,
                                                                    borderRadius:
                                                                        BorderRadius.all(
                                                                            Radius.circular(5))),
                                                                child: Center(
                                                                  child:
                                                                      Padding(
                                                                    padding: EdgeInsets.only(
                                                                        left:
                                                                            3.w,
                                                                        right: 3
                                                                            .w),
                                                                    child: Text(
                                                                      "Add manpower",
                                                                      style: Utils.regularTextStyle(
                                                                          color:
                                                                              AppColor.dotColor),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
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
                                                                .strNos,
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
                                                    )
                                                  : Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Expanded(
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Padding(
                                                                padding: EdgeInsets
                                                                    .only(
                                                                        left:
                                                                            3.w,
                                                                        top: 2
                                                                            .w),
                                                                child: Text(
                                                                  "Skilled",
                                                                  style: Utils
                                                                      .regularTextStyle(
                                                                          color:
                                                                              AppColor.textColor1),
                                                                ),
                                                              ),
                                                              CommandTextFormField(
                                                                title: AppString
                                                                    .strEnterQuantity,
                                                                controller:
                                                                    skilledController,
                                                                hint: AppString
                                                                    .strNos,
                                                                textInputAction:
                                                                    TextInputAction
                                                                        .done,
                                                                textInputType:
                                                                    TextInputType
                                                                        .number,
                                                                onChange:
                                                                    (value) {},
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        Expanded(
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Padding(
                                                                padding: EdgeInsets
                                                                    .only(
                                                                        left:
                                                                            3.w,
                                                                        top: 2
                                                                            .w),
                                                                child: Text(
                                                                  "Semi-skilled",
                                                                  style: Utils
                                                                      .regularTextStyle(
                                                                          color:
                                                                              AppColor.textColor1),
                                                                ),
                                                              ),
                                                              CommandTextFormField(
                                                                title: AppString
                                                                    .strEnterQuantity,
                                                                controller:
                                                                    semiSkilledController,
                                                                hint: AppString
                                                                    .strNos,
                                                                textInputAction:
                                                                    TextInputAction
                                                                        .done,
                                                                textInputType:
                                                                    TextInputType
                                                                        .number,
                                                                onChange:
                                                                    (value) {},
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        Expanded(
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Padding(
                                                                padding: EdgeInsets
                                                                    .only(
                                                                        left:
                                                                            3.w,
                                                                        top: 2
                                                                            .w),
                                                                child: Text(
                                                                  "Unskilled",
                                                                  style: Utils
                                                                      .regularTextStyle(
                                                                          color:
                                                                              AppColor.textColor1),
                                                                ),
                                                              ),
                                                              CommandTextFormField(
                                                                title: AppString
                                                                    .strEnterQuantity,
                                                                controller:
                                                                    unSkilledController,
                                                                hint: AppString
                                                                    .strNos,
                                                                textInputAction:
                                                                    TextInputAction
                                                                        .done,
                                                                textInputType:
                                                                    TextInputType
                                                                        .number,
                                                                onChange:
                                                                    (value) {},
                                                              ),
                                                            ],
                                                          ),
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
                                addIssue(),
                              ],
                            ),
                          ),
                        ],
                      ),
                      isLoading
                          ? Container(
                              height: 100.h,
                              width: 100.w,
                              color: AppColor.gray4,
                              child: Center(
                                child: CircularProgressIndicator(
                                  color: AppColor.mainColor,
                                ),
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
      ),
    );
  }

  openCamera(ImageSource source) async {
    XFile? pickedFile = (await ImagePicker().pickImage(
        source: source, maxWidth: 1000, maxHeight: 1000, imageQuality: 50));

    List<MultipartFile> list = [];
    String fileName = File(pickedFile!.path).path.split('/').last;
    list.add(await MultipartFile.fromFile(File(pickedFile.path).path,
        filename: fileName));
    ApiServices.postTaskImage(list, taskDetailsList.id,
            taskDetailsList.projectId, taskDetailsList.registerUserId)
        .then((value) {
      setState(() {
        taskImageList.add(value!.data![0]);
        Navigator.pop(context);
      });
    });
  }

  getFilePicker() async {
    final dir = await path_provider.getTemporaryDirectory();
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.custom,
      allowedExtensions: ['jpg', 'pdf', 'png'],
    );

    List<MultipartFile> list = [];
    for (int i = 0; i < result!.files.length; i++) {
      var mb = ((result.files[i].size) / 1024) / 1024;
      int? quality = Utils.getQuality(mb);
      String fileName = File(result.files[i].path!).path.split('/').last;
      final targetPath = dir.absolute.path + fileName;
      final format = result.files[i].extension;
      if (format == "pdf") {
        final imgFile = File(result.files[i].path!);
        list.add(
            await MultipartFile.fromFile(imgFile.path, filename: fileName));
      } else {
        final imgFile = await Utils.testCompressAndGetFile(
            File(result.files[i].path!), targetPath, quality, format);
        list.add(
            await MultipartFile.fromFile(imgFile!.path, filename: fileName));
      }
    }
    Navigator.pop(context);
    setState(() {
      isLoading = true;
    });
    ApiServices.postTaskImage(list, taskDetailsList.id,
            taskDetailsList.projectId, taskDetailsList.registerUserId)
        .then((value) {
      if (value != null) {
        setState(() {
          isLoading = false;
          for (int i = 0; i < value.data!.length; i++) {
            taskImageList.add(value.data![i]);
          }
        });
      }
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
                child: SizedBox(
                  height: 10.w,
                  width: 60.w,
                  child: ListView.builder(
                      padding: EdgeInsets.only(right: 2.w, left: 2.w),
                      shrinkWrap: true,
                      key: UniqueKey(),
                      scrollDirection: Axis.horizontal,
                      itemCount: taskImageList.length,
                      itemBuilder: (context, index) {
                        final path =
                            taskImageList[index].image?.split(".").last;
                        return InkWell(
                          onTap: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (_) {
                              return FullScreen(
                                url: taskImageList[index].image!,
                                extention: path!,
                                delete: "delete",
                              );
                            })).then((value) {
                              if (value.toString() == "2") {
                                setState(() {
                                  ApiServices.imageDelete(taskDetailsList.id!,
                                      taskImageList[index].id!);
                                  taskImageList.removeAt(index);
                                });
                              }
                            });
                          },
                          child: Padding(
                            padding: EdgeInsets.only(right: 2.w),
                            child: path != "pdf"
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(5),
                                    child: CachedNetworkImage(
                                      height: 10.w,
                                      width: 10.w,
                                      fit: BoxFit.cover,
                                      imageUrl: (AppString.basePath) +
                                          (taskImageList[index].image ?? ""),
                                      cacheManager: CacheManager(Config(
                                        "key$index",
                                        stalePeriod: const Duration(days: 7),
                                      )),
                                      placeholder: (context, url) => Center(
                                        child: SizedBox(
                                          height: 5.w,
                                          width: 5.w,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2.1,
                                          ),
                                        ),
                                      ),
                                      errorWidget: (context, url, error) =>
                                          Icon(Icons.error),
                                    ),
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
          height: 3.w,
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

  Widget addIssue() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: () {
            if (taskDetailsList.totalWork != null) {
              Navigator.push(context, MaterialPageRoute(builder: (_) {
                return TaskIssueScreen(
                  projectID: taskDetailsList.projectId,
                  edit: 0,
                  taskId: taskDetailsList.id,
                  tag: 0,
                );
              })).then((value) {
                if (value != null) {
                  setState(() {
                    issueList.add(value);
                    taskDetailsList.issues_count = issueList.length;
                  });
                }
              });
            } else {
              Toasts.showToast(
                  "Please update ${taskDetailsList.title} task details.");
            }
          },
          child: Padding(
            padding: EdgeInsets.only(top: 3.w, bottom: 1.w),
            child: Text(
              "+ Add issues",
              style: Utils.regularTextStyle(
                  fontSize: AppDimens.large_font, color: AppColor.textColor3),
            ),
          ),
        ),
        SizedBox(
          height: 49.w,
          width: 88.w,
          child: ListView.builder(
            shrinkWrap: true,
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.zero,
            itemCount: issueList.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              var outputFormat = DateFormat("hh:mm a, dd MMM, yyyy");
              var outputDate = outputFormat.format(issueList[index].createdAt!);
              return Stack(
                children: [
                  SizedBox(
                    width: 80.w,
                    height: 48.w,
                    child: Card(
                      child: Padding(
                        padding: EdgeInsets.all(2.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      width: 34.w,
                                      decoration: BoxDecoration(
                                          color: AppColor.green1,
                                          borderRadius:
                                              BorderRadius.circular(5)),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          issueList[index]
                                                  .issueCategory!
                                                  .title ??
                                              "",
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                          style: Utils.regularTextStyle(
                                              color: AppColor.green),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 3.w,
                                    ),
                                    Container(
                                      width: 18.w,
                                      decoration: BoxDecoration(
                                          color: AppColor.btnUpdateBg,
                                          borderRadius:
                                              BorderRadius.circular(5)),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          issueList[index].task!.title ?? "",
                                          maxLines: 1,
                                          overflow: TextOverflow.clip,
                                          style: Utils.regularTextStyle(
                                              color: AppColor.textColor2),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                PopupMenuButton(
                                    child: Icon(
                                      Icons.more_vert,
                                      color: AppColor.textColor2,
                                      size: 30,
                                    ),
                                    onSelected: (Menu item) {
                                      if (item.index == 0) {
                                        setState(() {
                                          Navigator.push(context,
                                              MaterialPageRoute(builder: (_) {
                                            return TaskIssueScreen(
                                              tag: 0,
                                              edit: 1,
                                              id: issueList[index].id,
                                              issueData: issueList[index],
                                            );
                                          })).then((value) {
                                            if (value != null) {
                                              setState(() {
                                                issueList[index]
                                                        .issueCategory!
                                                        .title =
                                                    value.issueCategory!.title;
                                                issueList[index].title =
                                                    value.title;
                                              });
                                            }
                                          });
                                        });
                                      } else if (item.index == 1) {
                                        showMyDialog(context,
                                            "are you sure, delete this Issue?",
                                            () {
                                          Navigator.pop(context);
                                          ApiServices.postIssueDelete(
                                              issueList[index].id!);
                                          setState(() {
                                            issueList.removeAt(index);
                                          });
                                          // .then((value) => () {
                                          //       print("value $value");
                                          //       if (value == true) {
                                          //
                                          //       }
                                          //     });
                                        });
                                      }
                                    },
                                    itemBuilder: (BuildContext context) =>
                                        <PopupMenuEntry<Menu>>[
                                          const PopupMenuItem<Menu>(
                                            value: Menu.itemOne,
                                            child: Text('Issue edit'),
                                          ),
                                          const PopupMenuItem<Menu>(
                                            value: Menu.itemTwo,
                                            child: Text('Issue delete'),
                                          ),
                                        ]),
                              ],
                            ),
                            SizedBox(
                              height: 3.w,
                            ),
                            Text(
                              issueList[index].title ?? "",
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: Utils.regularTextStyle(
                                  color: AppColor.textColor2),
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
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                          color: AppColor.black, width: 1)),
                                  child: issueList[index].teamDetails?.image ==
                                          null
                                      ? Icon(
                                          Icons.person,
                                          size: 8.w,
                                        )
                                      : CircleAvatar(
                                          radius: 200.0,
                                          backgroundImage: NetworkImage(
                                              AppString.basePath +
                                                  issueList[index]
                                                      .teamDetails
                                                      ?.image),
                                        ),
                                ),
                                SizedBox(
                                  width: 2.w,
                                ),
                                Text(
                                  issueList[index].teamDetails?.name ??
                                      issueList[index].teamDetails?.mobile ??
                                      "",
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
                                              ImageAsset.iconSchedule))),
                                ),
                                SizedBox(
                                  width: 2.w,
                                ),
                                Text(
                                  outputDate,
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                InkWell(
                                  onTap: () {
                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (_) {
                                      return IssueDetailsScreen(
                                        data: issueList[index],
                                      );
                                    })).then((value) {
                                      setState(() {
                                        issueList[index].commentCount = value;
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
                                                    ImageAsset.iconChat))),
                                      ),
                                      SizedBox(
                                        width: 2,
                                      ),
                                      Text(
                                        issueList[index]
                                                .commentCount
                                                ?.toString() ??
                                            "0",
                                        style: Utils.regularTextStyle(),
                                      )
                                    ],
                                  ),
                                ),
                                issueList[index].status == 1
                                    ? InkWell(
                                        onTap: () {
                                          closeBottomSheet(context, () {
                                            ApiServices.poseIssueClose(
                                                    issueList[index].id!)
                                                .then((value) {
                                              setState(() {
                                                issueList[index].status = value;
                                              });
                                            });
                                            Navigator.of(context).pop();
                                          });
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(5)),
                                              border: Border.all(
                                                  color: AppColor.red1,
                                                  width: 2)),
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              AppString.strCloseIssue,
                                              style: Utils.regularTextStyle(
                                                  color: AppColor.red1),
                                            ),
                                          ),
                                        ),
                                      )
                                    : Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          AppString.strCloseIssue,
                                          style: Utils.regularTextStyle(
                                              color: AppColor.red1),
                                        )),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  issueList[index].status != 1
                      ? Padding(
                          padding: EdgeInsets.all(1.w),
                          child: InkWell(
                            onTap: () {
                              Toasts.showToast("Issue close already");
                            },
                            child: Container(
                              width: 78.w,
                              height: 46.w,
                              decoration: BoxDecoration(
                                  color: AppColor.white4,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5))),
                            ),
                          ),
                        )
                      : Container()
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}
