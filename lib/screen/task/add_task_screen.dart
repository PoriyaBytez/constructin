import 'package:constructin/utils/api_services.dart';
import 'package:constructin/utils/app_asset.dart';
import 'package:constructin/utils/toasts.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../../utils/app_color.dart';
import '../../utils/app_dimens.dart';
import '../../utils/app_string.dart';
import '../../utils/unil.dart';
import '../../widget/comman_widget.dart';
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
  TextEditingController taskNameController = TextEditingController();

  List<String> taskCategory = [];
  String? taskCategoryValue;

  int selectTaskCategory = 0;

  TextEditingController taskController = TextEditingController();

  @override
  void initState() {
    ApiServices.getTaskCategoryList().then((value) {
      for (int i = 0; i < value.data!.length; i++) {
        setState(() {
          taskCategory.add(value.data![i].title ?? "");
        });
      }
    });
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
            SizedBox(
              height: 20.w,
            ),
            Expanded(
              child: ListView(
                shrinkWrap: true,
                children: [
                  Padding(
                    padding: EdgeInsets.all(3.w),
                    child: Container(
                      height: 15.w,
                      width: double.infinity,
                      decoration: BoxDecoration(
                          color: AppColor.textFormFieldBg,
                          border: Border.all(
                              color: AppColor.textFormFieldBg, width: 1),
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      child: Center(
                        child: Padding(
                          padding: EdgeInsets.only(
                            left: 3.w,
                          ),
                          child: DropdownButton<String>(
                            isExpanded: true,
                            underline: Container(
                              color: AppColor.textFormFieldBg,
                              height: 1,
                              width: double.infinity,
                            ),
                            // value: valueTarget,
                            hint: Text(
                              'Select/Add Tack category',
                              style: Utils.regularTextStyle(
                                  color: AppColor.hintText, fontSize: 4.w),
                            ),
                            value: taskCategoryValue,
                            iconEnabledColor: AppColor.textFormFieldBg,
                            dropdownColor: AppColor.textFormFieldBg,
                            icon: const Icon(
                              Icons.arrow_drop_down,
                              size: 40,
                              color: AppColor.textColor,
                            ),
                            elevation: 0,
                            style: Utils.regularTextStyle(
                                color: AppColor.textColor,
                                fontSize: AppDimens.medium_font),
                            onChanged: (String? newValue) {
                              setState(() {
                                taskCategoryValue = newValue!;
                                selectTaskCategory =
                                    1 + taskCategory.indexOf(newValue);
                              });
                            },
                            items: taskCategory
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 7.w,
                  ),
                  CommandTextFormField(
                    title: AppString.strEnterTaskName,
                    controller: taskNameController,
                    hint: AppString.strEnterTaskName,
                    textInputAction: TextInputAction.done,
                    textInputType: TextInputType.text,
                    onChange: (value) {},
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
                            taskController.clear();
                            bottomSet();
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
                  SizedBox(
                    height: 40.w,
                  ),
                  InkWell(
                    onTap: () {
                      if (taskNameController.text.isEmpty) {
                        Toasts.showToast("Please enter task name");
                      } else {
                        ApiServices.postTask(widget.projectId,
                                selectTaskCategory, taskNameController.text)
                            .then((value) {
                          Navigator.pop(context, value);
                        });
                      }
                    },
                    child: SizedBox(
                        height: 25.w,
                        width: 50.w,
                        child: Image.asset(ImageAsset.btnSave)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  bottomSet() {
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
                          "Add Task Category",
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
                          if (taskController.text.isEmpty) {
                            Toasts.showToast("please enter task category");
                          } else {
                            ApiServices.postTaskCategory(taskController.text)
                                .then((value) {
                              print("value :${value.title}");
                              setState(() {
                                state(() {
                                  taskCategory.add(value.title);
                                  print(
                                      "taskCategory size :${taskCategory.length}");
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
    ).then((value) {});
  }
}
