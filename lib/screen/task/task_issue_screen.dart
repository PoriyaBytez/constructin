import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../../model/task_category_model.dart';
import '../../model/task_image_model.dart';
import '../../model/task_model.dart';
import '../../utils/api_services.dart';
import '../../utils/app_asset.dart';
import '../../utils/app_color.dart';
import '../../utils/app_dimens.dart';
import '../../utils/app_string.dart';
import '../../utils/toasts.dart';
import '../../utils/unil.dart';
import '../../widget/comman_widget.dart';
import '../../widget/search_text_form_field.dart';
import '../../widget/text_form_field.dart';
import 'full_screen_image.dart';

class TaskIssueScreen extends StatefulWidget {
  TaskDetailsList taskDetailsList;

  TaskIssueScreen({required this.taskDetailsList});

  @override
  State<TaskIssueScreen> createState() => _TaskIssueScreenState();
}

class _TaskIssueScreenState extends State<TaskIssueScreen> {
  TextEditingController descriptionController = TextEditingController();

  List<TaskCategoryData> issueCategory = [];
  List<TaskCategoryData> searchIssueCategory = [];

  bool isSelect = false;
  String selectCategory = '';
  int selectIssueCategory = 0;
  TextEditingController issueController = TextEditingController();
  TextEditingController searchController = TextEditingController();
  List<TaskImageData> taskImageList = [];

  @override
  void initState() {
    // TODO: implement initState
    ApiServices.getIssueCategoryList().then((value) {
      for (int i = 0; i < value.data!.length; i++) {
        setState(() {
          issueCategory.add(value.data![i]);
        });
      }
    });
    // ApiServices.getTaskImageList(taskDetailsList.id!).then((value) {
    //   setState(() {
    //     taskImageList = value.data!;
    //   });
    // });

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
                        Padding(
                          padding: EdgeInsets.all(3.w),
                          child: InkWell(
                            onTap: () {
                              searchController.text = '';
                              categoryListBottomSet();
                            },
                            child: Container(
                                height: 15.w,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                    color: AppColor.textFormFieldBg,
                                    border: Border.all(
                                        color: AppColor.textFormFieldBg,
                                        width: 1),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                child: Row(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(left: 3.w),
                                      child: Text(
                                        selectCategory == ''
                                            ? "Select/Add Tack category"
                                            : selectCategory,
                                        style: Utils.regularTextStyle(
                                            color: selectCategory == ''
                                                ? AppColor.hintText
                                                : AppColor.black,
                                            fontSize: 4.w),
                                      ),
                                    ),
                                  ],
                                )),
                          ),
                        ),
                        isSelect
                            ? Padding(
                                padding: EdgeInsets.only(left: 5.w),
                                child: Text(
                                  "Please select category",
                                  style: TextStyle(
                                      color: AppColor.red1, fontSize: 12.0),
                                ),
                              )
                            : Container(),
                        CommandTextFormField(
                          title: AppString.strEnterIssueDescription,
                          controller: descriptionController,
                          hint: AppString.strEnterIssueDescription,
                          textInputAction: TextInputAction.done,
                          textInputType: TextInputType.multiline,
                          maxLines: null,
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
                                "+ Add Photos/attachment",
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
                  InkWell(
                      onTap: () {
                        ApiServices.postIssue(widget.taskDetailsList.projectId.toString(),
                            selectIssueCategory.toString(), descriptionController.text);
                      },
                      child: Image.asset(ImageAsset.btnIssueSave))
                ],
              ),
            ))
          ],
        ),
      ),
    );
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
                  // if (taskDetailsList.totalWork != null) {
                  //   Utils.pickImageDialog(context, () {
                  //     getFilePicker();
                  //   }, () {
                  //     openCamera(ImageSource.camera);
                  //   });
                  // } else {
                  //   Toasts.showToast(
                  //       "Please update ${taskDetailsList.title} task details.");
                  // }
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

  categoryListBottomSet() {
    showModalBottomSheet(
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5.0),
      ),
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, state) {
          return Container(
            height: 80.h,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10), color: AppColor.white),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.all(5.w),
                  child: Text(
                    "Select or add New Issue category",
                    style:
                        Utils.mediumTextStyle(fontSize: AppDimens.large_font),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 5.w),
                  child: InkWell(
                    onTap: () {
                      state(() {
                        issueController.text = "";
                        bottomSet(state, 0, null, null);
                      });
                    },
                    child: Row(
                      children: [
                        Icon(
                          Icons.add,
                          color: AppColor.dotColor,
                        ),
                        Padding(
                          padding: EdgeInsets.all(3.w),
                          child: Text(
                            "Add New Category",
                            style: Utils.mediumTextStyle(
                                color: AppColor.dotColor,
                                fontSize: AppDimens.medium_font),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Divider(),
                SearchTextFormField(
                    labelText: "Search Issue Category",
                    onChanged: (value) {
                      onSearchTextChanged(value, state);
                    },
                    searchController: searchController),
                searchController.text.isNotEmpty
                    ? Expanded(
                        child: ListView.separated(
                            separatorBuilder:
                                (BuildContext context, int index) =>
                                    const Divider(),
                            shrinkWrap: true,
                            itemCount: searchIssueCategory.length,
                            itemBuilder: (context, index) {
                              return InkWell(
                                onTap: () {
                                  setState(() {
                                    state(() {
                                      selectCategory =
                                          searchIssueCategory[index].title ??
                                              "";
                                      selectIssueCategory =
                                          searchIssueCategory[index].id!;
                                      Navigator.pop(context);
                                    });
                                  });
                                },
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      left: 5.w,
                                      top: 3.w,
                                      bottom: 3.w,
                                      right: 5.w),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        searchIssueCategory[index].title!,
                                        overflow: TextOverflow.clip,
                                        style: Utils.mediumTextStyle(
                                            fontSize: AppDimens.medium_font,
                                            color: AppColor.textColor),
                                      ),
                                      searchIssueCategory[index]
                                                  .registerUserId !=
                                              null
                                          ? InkWell(
                                              onTap: () {
                                                state(() {
                                                  issueController.text =
                                                      searchIssueCategory[index]
                                                          .title!;
                                                  bottomSet(
                                                      state,
                                                      1,
                                                      searchIssueCategory[index]
                                                          .id,
                                                      index);
                                                });
                                              },
                                              child: Icon(
                                                Icons.edit,
                                                color: AppColor.dotColor,
                                              ),
                                            )
                                          : Container()
                                    ],
                                  ),
                                ),
                              );
                            }),
                      )
                    : Expanded(
                        child: ListView.separated(
                            separatorBuilder:
                                (BuildContext context, int index) =>
                                    const Divider(),
                            shrinkWrap: true,
                            itemCount: issueCategory.length,
                            itemBuilder: (context, index) {
                              return InkWell(
                                onTap: () {
                                  setState(() {
                                    state(() {
                                      selectCategory =
                                          issueCategory[index].title ?? "";
                                      selectIssueCategory =
                                          issueCategory[index].id!;
                                      Navigator.pop(context);
                                    });
                                  });
                                },
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      left: 5.w,
                                      top: 3.w,
                                      bottom: 3.w,
                                      right: 5.w),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        issueCategory[index].title!,
                                        style: Utils.mediumTextStyle(
                                            fontSize: AppDimens.medium_font,
                                            color: AppColor.textColor),
                                      ),
                                      issueCategory[index].registerUserId !=
                                              null
                                          ? InkWell(
                                              onTap: () {
                                                state(() {
                                                  issueController.text =
                                                      issueCategory[index]
                                                          .title!;
                                                  bottomSet(
                                                      state,
                                                      1,
                                                      issueCategory[index].id,
                                                      index);
                                                });
                                              },
                                              child: Icon(
                                                Icons.edit,
                                                color: AppColor.dotColor,
                                              ),
                                            )
                                          : Container()
                                    ],
                                  ),
                                ),
                              );
                            }),
                      ),
              ],
            ),
          );
        });
      },
    );
  }

  bottomSet(StateSetter setter, int edit, dynamic id, dynamic index) {
    showModalBottomSheet(
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5.0),
      ),
      context: context,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: StatefulBuilder(builder: (context, state) {
            return Container(
              color: AppColor.white,
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(5.w),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          edit == 0
                              ? "Add Issue Category"
                              : "Edit Issue Category",
                          style: Utils.mediumTextStyle(
                              fontSize: AppDimens.medium_font),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Icon(
                            Icons.clear,
                            size: 25,
                            color: AppColor.gray,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Divider(),
                  Padding(
                    padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom),
                    child: CommandTextFormField(
                        controller: issueController,
                        hint: "Enter category",
                        textInputAction: TextInputAction.done,
                        textInputType: TextInputType.text,
                        onChange: (value) {}),
                  ),
                  Padding(
                    padding: EdgeInsets.all(5.w),
                    child: commandButton(
                        name: "Submit",
                        bg: AppColor.mainColor,
                        onPress: () {
                          if (edit == 0) {
                            if (issueController.text.isEmpty) {
                              Toasts.showToast("please enter task category");
                            } else {
                              ApiServices.postIssueCategory(
                                      issueController.text, null)
                                  .then((value) {
                                print("value :${value.title}");
                                setter(() {
                                  state(() {
                                    issueCategory.add(value);
                                    print(
                                        "issueCategory size :${issueCategory.length}");
                                    Navigator.pop(context);
                                  });
                                });
                              });
                            }
                          } else {
                            ApiServices.postIssueCategory(
                                    issueController.text, id)
                                .then((value) {
                              print("value :${value.title}");
                              setter(() {
                                state(() {
                                  issueCategory[index].title = value.title;
                                  print(
                                      "issueCategory size :${issueCategory.length}");
                                  Navigator.pop(context);
                                });
                              });
                            });
                          }
                        },
                        strColor: AppColor.white),
                  ),
                ],
              ),
            );
          }),
        );
      },
    );
  }

  onSearchTextChanged(String text, StateSetter setter) async {
    searchIssueCategory.clear();
    if (text.isEmpty) {
      setState(() {});
      return;
    }

    issueCategory.forEach((task) {
      if (task.title!.toUpperCase().contains(text) ||
          task.title!.toLowerCase().contains(text))
        searchIssueCategory.add(task);
    });

    setter(() {});
  }
}
