import 'package:constructin/utils/app_string.dart';
import 'package:constructin/widget/text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

import '../../bloc/create_project_bloc/create_project_bloc.dart';
import '../../helper/route_helper.dart';
import '../../model/project_model.dart';
import '../../utils/api_services.dart';
import '../../utils/app_asset.dart';
import '../../utils/app_color.dart';
import '../../utils/app_dimens.dart';
import '../../utils/util.dart';
import '../../widget/comman_widget.dart';

class CreateProjectScreen extends StatefulWidget {
  const CreateProjectScreen({Key? key, this.restorationId}) : super(key: key);
  final String? restorationId;

  @override
  State<CreateProjectScreen> createState() => _CreateProjectScreenState();
}

class _CreateProjectScreenState extends State<CreateProjectScreen> {
  TextEditingController projectNameController = TextEditingController();
  TextEditingController clientNameController = TextEditingController();
  TextEditingController siteController = TextEditingController();
  TextEditingController startDateController = TextEditingController();
  TextEditingController endDateController = TextEditingController();
  TextEditingController saleValueController = TextEditingController();
  TextEditingController budgetController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  FocusNode projectNameNode = FocusNode();
  FocusNode clientNameNode = FocusNode();
  FocusNode siteNode = FocusNode();
  FocusNode startDateNode = FocusNode();
  FocusNode endDateNode = FocusNode();
  FocusNode saleValueNode = FocusNode();
  FocusNode budgetNode = FocusNode();

  bool nextPage = false;
  bool selectType = false;
  bool selectStartDate = false;
  bool selectEndDate = false;

  DateTime selectedDate = DateTime.now();

  bool focusedBorder = false;

  Future<String> selectDate(BuildContext context) async {
    String formatted = "";
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate) {
      setState(() {
        final DateFormat formatter = DateFormat('yyyy-MM-dd');
        formatted = formatter.format(picked);
      });
    }
    return formatted;
  }

  List<String> projectType = [];
  String? projectTypeValue;

  int selectProjectType = 0;
  bool isLoading = false;
  CreateProjectBloc createProjectBloc = CreateProjectBloc();
  Color? focusColor;
  int listPage = 0;
  ProjectDetail? projectData;

  @override
  void initState() {
    getProjectType();
    createProjectBloc = BlocProvider.of<CreateProjectBloc>(context);
    listPage = Get.arguments[0]['lastPage'];
    super.initState();
  }

  getProjectType() {
    ApiServices.getProject().then((value) {
      for (int i = 0; i < value.data!.length; i++) {
        setState(() {
          projectType.add(value.data![i].title ?? "");
        });
      }
      if (Get.arguments[1]['update'] != null) {
        projectData = Get.arguments[1]['update'];
        initData();
      }
    });
  }

  initData() {
    projectNameController.text = projectData!.projectName!;
    clientNameController.text = projectData!.clientName!;
    siteController.text = projectData!.siteLocation!;
    startDateController.text = Utils.showData(projectData!.startDate ?? "");
    endDateController.text = Utils.showData(projectData!.endDate ?? "");
    budgetController.text = projectData!.budget ?? '';
    saleValueController.text = projectData!.saleValue ?? '';
    projectTypeValue = projectType[projectData!.projectTypeId! - 1];
    selectProjectType = projectData!.projectTypeId!;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColor.white,
        body: BlocListener<CreateProjectBloc, CreateProjectState>(
          listener: (context, state) {
            if (state is CreateProjectLoading) {
              setState(() {
                isLoading = true;
              });
            } else if (state is CreateProjectSuccess) {
              setState(() {
                isLoading = false;
              });
              Get.offAndToNamed(RouteHelper.projectList);
            }
          },
          child: SingleChildScrollView(
            child: Column(
              children: [
                appBar("Create Project", () {
                  if (listPage == 1 && nextPage == false) {
                    Get.back();
                  }
                  setState(() {
                    nextPage = false;
                  });
                }),
                SizedBox(
                  height: 3.w,
                ),
                Container(
                  height: 40.w,
                  width: 40.w,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: AssetImage(ImageAsset.under_maintenance),
                    ),
                  ),
                ),
                SizedBox(
                  height: 5.w,
                ),
                nextPage
                    ? Stack(children: [
                        Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: CommandTextFormField(
                                    onTab: () {
                                      selectDate(context).then((value) {
                                        startDateController.text =
                                            Utils.showData(value);
                                      });
                                      selectStartDate = false;
                                    },
                                    title: AppString.strStartDate,
                                    controller: startDateController,
                                    // focusNode: startDateNode,
                                    readOnly: true,
                                    hint: AppString.strStartDate,
                                    textInputAction: TextInputAction.next,
                                    textInputType: TextInputType.text,
                                  ),
                                ),
                                Expanded(
                                  child: InkWell(
                                    onTap: () {},
                                    child: CommandTextFormField(
                                      title: AppString.strEndDate,
                                      controller: endDateController,
                                      // focusNode: endDateNode,
                                      readOnly: true,
                                      onTab: () {
                                        selectDate(context).then((value) {
                                          endDateController.text =
                                              Utils.showData(value);
                                        });
                                        selectEndDate = false;
                                      },
                                      hint: AppString.strEndDate,
                                      textInputAction: TextInputAction.next,
                                      textInputType: TextInputType.text,
                                      onChange: (value) {},
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                selectStartDate
                                    ? Expanded(
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                            left: 5.5.w,
                                          ),
                                          child: Text(
                                            "Please select start date",
                                            style: TextStyle(
                                                color: AppColor.red1,
                                                fontSize: 12.0),
                                          ),
                                        ),
                                      )
                                    : Expanded(child: Container()),
                                selectEndDate
                                    ? Expanded(
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                            left: 5.5.w,
                                          ),
                                          child: Text(
                                            "Please select end date",
                                            style: TextStyle(
                                                color: AppColor.red1,
                                                fontSize: 12.0),
                                          ),
                                        ),
                                      )
                                    : Expanded(child: Container())
                              ],
                            ),
                            CommandTextFormField(
                              title: AppString.strSaleValue,
                              controller: saleValueController,
                              // focusNode: siteNode,
                              hint: AppString.strSaleValue,
                              textInputAction: TextInputAction.next,
                              textInputType: TextInputType.number,
                              onChange: (value) {},
                            ),
                            CommandTextFormField(
                              title: AppString.strBudgetValue,
                              controller: budgetController,
                              // focusNode: budgetNode,
                              hint: AppString.strBudgetValue,
                              textInputAction: TextInputAction.done,
                              textInputType: TextInputType.number,
                              onChange: (value) {},
                            ),
                            SizedBox(
                              height: 30.w,
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 3.w, right: 3.w),
                              child: commandButton(
                                  name: AppString.strCreateProject,
                                  strColor: AppColor.white,
                                  bg: AppColor.mainColor,
                                  onPress: () {
                                    if (startDateController.text.isEmpty) {
                                      setState(() {
                                        selectStartDate = true;
                                      });
                                    } else {
                                      setState(() {
                                        selectStartDate = false;
                                      });
                                    }
                                    if (endDateController.text.isEmpty) {
                                      setState(() {
                                        selectEndDate = true;
                                      });
                                    } else {
                                      setState(() {
                                        selectEndDate = false;
                                      });
                                    }
                                    if (startDateController.text.isEmpty &&
                                        endDateController.text.isEmpty) {
                                    } else {
                                      ProjectDetail createProjectData =
                                          ProjectDetail(
                                              id: projectData
                                                          ?.id ==
                                                      null
                                                  ? null
                                                  : projectData!.id,
                                              projectName: projectNameController
                                                  .text,
                                              clientName:
                                                  clientNameController.text,
                                              siteLocation: siteController.text,
                                              projectTypeId: selectProjectType,
                                              startDate: Utils
                                                  .passData(
                                                      startDateController.text),
                                              endDate: Utils.passData(
                                                  endDateController.text),
                                              saleValue:
                                                  saleValueController.text,
                                              budget: budgetController.text);
                                      createProjectBloc.add(
                                          CreateProjectButtonPressed(
                                              projectDetail:
                                                  createProjectData));
                                    }
                                  }),
                            ),
                          ],
                        ),
                        isLoading
                            ? Center(
                                child: CircularProgressIndicator(
                                  color: AppColor.mainColor,
                                ),
                              )
                            : Container()
                      ])
                    : Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CommandTextFormField(
                              title: AppString.strProjectName,
                              controller: projectNameController,
                              focusNode: projectNameNode,
                              hint: AppString.strEnterProjectName,
                              textInputAction: TextInputAction.next,
                              textInputType: TextInputType.text,
                              validator: (value) {
                                if (value == "") {
                                  return "Please enter project name";
                                }
                                return null;
                              },
                              onChange: (value) {},
                            ),
                            CommandTextFormField(
                              title: AppString.strClientName,
                              controller: clientNameController,
                              focusNode: clientNameNode,
                              hint: AppString.strEnterClientName,
                              textInputAction: TextInputAction.next,
                              textInputType: TextInputType.text,
                              validator: (value) {
                                if (value == "") {
                                  return "Please enter client name";
                                }
                                return null;
                              },
                              onChange: (value) {},
                            ),
                            CommandTextFormField(
                              title: AppString.strSiteLocation,
                              controller: siteController,
                              focusNode: siteNode,
                              hint: AppString.strEnterLocation,
                              textInputAction: TextInputAction.done,
                              textInputType: TextInputType.text,
                              validator: (value) {
                                if (value == "") {
                                  return "Please enter site location";
                                }
                                return null;
                              },
                              onChange: (value) {},
                            ),
                            Padding(
                              padding: EdgeInsets.all(3.w),
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
                                        'Select type of project',
                                        style: Utils.regularTextStyle(
                                            color: AppColor.hintText,
                                            fontSize: 4.w),
                                      ),
                                      value: projectTypeValue,
                                      iconEnabledColor:
                                          AppColor.textFormFieldBg,
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
                                          projectTypeValue = newValue!;
                                          selectProjectType =
                                              1 + projectType.indexOf(newValue);
                                          selectType = false;
                                        });
                                      },
                                      items: projectType
                                          .map<DropdownMenuItem<String>>(
                                              (String value) {
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
                            selectType
                                ? Padding(
                                    padding: EdgeInsets.only(
                                      left: 5.5.w,
                                    ),
                                    child: Text(
                                      "Please select type of project",
                                      style: TextStyle(
                                          color: AppColor.red1, fontSize: 12.0),
                                    ),
                                  )
                                : Container(),
                            SizedBox(
                              height: 30.w,
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 3.w, right: 3.w),
                              child: commandButton(
                                  name: AppString.strContinue,
                                  strColor: AppColor.white,
                                  bg: AppColor.mainColor,
                                  onPress: () {
                                    setState(() {
                                      if (selectProjectType == 0) {
                                        setState(() {
                                          selectType = true;
                                        });
                                      } else {
                                        setState(() {
                                          selectType = false;
                                        });
                                      }
                                      if (_formKey.currentState!.validate()) {
                                        nextPage = true;
                                      }
                                    });
                                  }),
                            ),
                            SizedBox(
                              height: 5.w,
                            ),
                          ],
                        ),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
