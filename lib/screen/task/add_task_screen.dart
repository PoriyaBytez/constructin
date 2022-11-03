import 'package:constructin/utils/api_services.dart';
import 'package:constructin/utils/app_asset.dart';
import 'package:constructin/utils/toasts.dart';
import 'package:constructin/widget/comman_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../../model/task_category_model.dart';
import '../../utils/app_color.dart';
import '../../utils/app_dimens.dart';
import '../../utils/app_string.dart';
import '../../utils/util.dart';
import '../../widget/search_text_form_field.dart';
import '../../widget/text_form_field.dart';

class AddTaskScreen extends StatefulWidget {
  int projectId;

  AddTaskScreen({required this.projectId});

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  List<String> taskType = [];
  String? taskTypeValue;
  int selectTaskType = 0;
  List<TaskCategoryData> taskCategory = [];
  List<TaskCategoryData> searchTaskCategory = [];
  String? taskCategoryValue;
  List<CommandTextFormField> commandTextFormFieldList = [];
  int selectTaskCategory = 0;
  bool isSelect = false;
  TextEditingController taskNameController = TextEditingController();
  int task = 2;
  String selectCategory = '';
  TextEditingController taskController = TextEditingController();
  TextEditingController searchController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    ApiServices.getTaskCategoryList().then((value) {
      for (int i = 0; i < value.data!.length; i++) {
        setState(() {
          taskCategory.add(value.data![i]);
        });
      }
    });
    commandTextFormFieldList.add(CommandTextFormField(
      hint: "Task 1",
      controller: taskNameController,
    ));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColor.white,
        body: Column(
          children: [
            appBar("Add Task", () {
              Get.back();
            }),
            Expanded(
              child: ListView(
                shrinkWrap: true,
                children: [
                  Padding(
                    padding: EdgeInsets.all(3.w),
                    child: InkWell(
                      onTap: () {
                        searchController.text = '';
                        categoryListBottomSet();
                        isSelect = false;
                      },
                      child: Container(
                          height: 15.w,
                          width: double.infinity,
                          decoration: BoxDecoration(
                              color: AppColor.textFormFieldBg,
                              border: Border.all(
                                  color: AppColor.textFormFieldBg, width: 1),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          child: Row(
                            children: [
                              Padding(
                                padding: EdgeInsets.only(left: 3.w),
                                child: Text(
                                  selectCategory == ''
                                      ? "Select/Add Task category"
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
                            style:
                                TextStyle(color: AppColor.red1, fontSize: 12.0),
                          ),
                        )
                      : Container(),
                  SizedBox(
                    height: 3.w,
                  ),
                  Form(
                    key: _formKey,
                    child: ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: commandTextFormFieldList.length,
                        itemBuilder: (context, index) {
                          return Stack(
                            children: [
                              CommandTextFormField(
                                hint: commandTextFormFieldList[index].hint,
                                controller:
                                    commandTextFormFieldList[index].controller,
                                textInputAction: TextInputAction.done,
                                textInputType: TextInputType.text,
                                validator: (value) {
                                  if (value == "") {
                                    return "Please enter task ${index + 1} name";
                                  }
                                  return null;
                                },
                                onChange: (value) {},
                              ),
                              Padding(
                                padding: EdgeInsets.only(right: 5.w, top: 7.w),
                                child: Align(
                                  alignment: Alignment.centerRight,
                                  child: InkWell(
                                    onTap: () {
                                      setState(() {
                                        commandTextFormFieldList
                                            .removeAt(index);
                                        task--;
                                      });
                                    },
                                    child: index == 0
                                        ? Container()
                                        : Icon(
                                            Icons.delete_outline,
                                            color: AppColor.red,
                                          ),
                                  ),
                                ),
                              )
                            ],
                          );
                        }),
                  ),
                  Padding(
                    padding: EdgeInsets.all(4.w),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          AppString.strAddAnotherTask,
                          style: Utils.regularTextStyle(),
                        ),
                        SizedBox(width: 3.w),
                        InkWell(
                          onTap: () {
                            setState(() {
                              if (commandTextFormFieldList[
                                          commandTextFormFieldList.length - 1]
                                      .controller
                                      ?.text !=
                                  "") {
                                if (commandTextFormFieldList.length < 9) {
                                  TextEditingController
                                      taskNameController$task =
                                      TextEditingController();
                                  commandTextFormFieldList
                                      .add(CommandTextFormField(
                                    hint: "Task $task",
                                    controller: taskNameController$task,
                                  ));
                                  task++;
                                } else {
                                  Toasts.showToast("Maximum 10 Task Add.");
                                }
                              } else {
                                Toasts.showToast(
                                    "Please enter last task ${commandTextFormFieldList.length} name");
                              }
                            });
                          },
                          child: Container(
                              height: 15.w,
                              width: 15.w,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColor.floatBg1,
                                boxShadow: const <BoxShadow>[
                                  BoxShadow(
                                      color: AppColor.white3,
                                      blurRadius: 50.0,
                                      offset: Offset(0.0, 0.75))
                                ],
                              ),
                              child: Icon(
                                Icons.add,
                                color: AppColor.textColor3,
                                size: 8.w,
                              )),
                        )
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      List<String> taskList = [];
                      if (selectCategory == '') {
                        setState(() {
                          isSelect = true;
                        });
                      } else {
                        setState(() {
                          isSelect = false;
                        });
                      }
                      if (_formKey.currentState!.validate()) {
                        for (int i = 0;
                            i < commandTextFormFieldList.length;
                            i++) {
                          taskList.add(
                              commandTextFormFieldList[i].controller?.text ??
                                  "");
                        }
                        ApiServices.postTask(widget.projectId,
                                selectTaskCategory, taskList.join(","))
                            .then((value) {
                          Navigator.pop(context, value);
                        });
                      }
                    },
                    child: SizedBox(
                        height: 25.w, child: Image.asset(ImageAsset.btnSave)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
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
                    "Select or add new task category",
                    style:
                        Utils.mediumTextStyle(fontSize: AppDimens.large_font),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 5.w),
                  child: InkWell(
                    onTap: () {
                      state(() {
                        taskController.text = "";
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
                    labelText: "Search Task Category",
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
                            itemCount: searchTaskCategory.length,
                            itemBuilder: (context, index) {
                              return InkWell(
                                onTap: () {
                                  setState(() {
                                    state(() {
                                      selectCategory =
                                          searchTaskCategory[index].title ?? "";
                                      selectTaskCategory =
                                          searchTaskCategory[index].id!;
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
                                        searchTaskCategory[index].title!,
                                        overflow: TextOverflow.clip,
                                        style: Utils.mediumTextStyle(
                                            fontSize: AppDimens.medium_font,
                                            color: AppColor.textColor),
                                      ),
                                      searchTaskCategory[index]
                                                  .registerUserId !=
                                              null
                                          ? InkWell(
                                              onTap: () {
                                                state(() {
                                                  taskController.text =
                                                      searchTaskCategory[index]
                                                          .title!;
                                                  bottomSet(
                                                      state,
                                                      1,
                                                      searchTaskCategory[index]
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
                            itemCount: taskCategory.length,
                            itemBuilder: (context, index) {
                              return InkWell(
                                onTap: () {
                                  setState(() {
                                    state(() {
                                      selectCategory =
                                          taskCategory[index].title ?? "";
                                      selectTaskCategory =
                                          taskCategory[index].id!;
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
                                        taskCategory[index].title!,
                                        style: Utils.mediumTextStyle(
                                            fontSize: AppDimens.medium_font,
                                            color: AppColor.textColor),
                                      ),
                                      taskCategory[index].registerUserId != null
                                          ? InkWell(
                                              onTap: () {
                                                state(() {
                                                  taskController.text =
                                                      taskCategory[index]
                                                          .title!;
                                                  bottomSet(
                                                      state,
                                                      1,
                                                      taskCategory[index].id,
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

  onSearchTextChanged(String text, StateSetter setter) async {
    searchTaskCategory.clear();
    if (text.isEmpty) {
      setState(() {});
      return;
    }

    taskCategory.forEach((task) {
      if (task.title!.toUpperCase().contains(text) ||
          task.title!.toLowerCase().contains(text)) {
        searchTaskCategory.add(task);
      }
    });

    setter(() {});
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
                              ? "Add Task Category"
                              : "Edit Task Category",
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
                        controller: taskController,
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
                            if (taskController.text.isEmpty) {
                              Toasts.showToast("please enter task category");
                            } else {
                              ApiServices.postTaskCategory(
                                      taskController.text, null)
                                  .then((value) {
                                setter(() {
                                  state(() {
                                    taskCategory.add(value);
                                    Navigator.pop(context);
                                  });
                                });
                              });
                            }
                          } else {
                            ApiServices.postTaskCategory(
                                    taskController.text, id)
                                .then((value) {
                              setter(() {
                                state(() {
                                  taskCategory[index].title = value.title;
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
}
