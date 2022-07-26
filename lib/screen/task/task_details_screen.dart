import 'dart:typed_data';

import 'package:constructin/model/customTeamList.dart';
import 'package:constructin/utils/api_services.dart';
import 'package:constructin/utils/toasts.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

import '../../model/contact_model.dart';
import '../../model/task_model.dart';
import '../../model/team_model.dart';
import '../../model/unit_list_model.dart';
import '../../utils/app_asset.dart';
import '../../utils/app_color.dart';
import '../../utils/app_dimens.dart';
import '../../utils/app_string.dart';
import '../../utils/shared_preferences/preferences_key.dart';
import '../../utils/shared_preferences/preferences_manager.dart';
import '../../utils/util.dart';
import '../../widget/comman_widget.dart';
import '../../widget/text_form_field.dart';

class TaskDetailsScreen extends StatefulWidget {
  late TaskDetailsList taskDetailsList;
  int id, unitValue, projectID;
  String startDate, endDate, totalWork;

  TaskDetailsScreen(
      {required this.taskDetailsList,
      required this.projectID,
      required this.id,
      required this.unitValue,
      required this.startDate,
      required this.endDate,
      required this.totalWork});

  @override
  State<TaskDetailsScreen> createState() => _TaskDetailsScreenState();
}

class _TaskDetailsScreenState extends State<TaskDetailsScreen> {
  TextEditingController startDateController = TextEditingController();
  TextEditingController endDateController = TextEditingController();
  TextEditingController totalController = TextEditingController();
  TextEditingController unitController = TextEditingController();
  FocusNode startDateNode = FocusNode();
  FocusNode endDateNode = FocusNode();
  FocusNode totalNode = FocusNode();
  FocusNode unitNode = FocusNode();
  DateTime selectedDate = DateTime.now();

  String? unitListValue;

  List<String> unitList = [];
  int selectUnit = 0;
  List<CustomTeamList> allTeamMember = [];
  List<CustomTeamList> teamList = [];
  List<TeamDetails> assignTeamMember = [];
  bool selectStartDate = false;
  bool selectEndDate = false;
  bool selectTotal = false;
  bool isUnit = false;
  List<UnitData> unitModel = [];
  bool readOnly = false;

  @override
  void initState() {
    ApiServices.getUnitList().then((value) {
      unitModel = value.data!;
      for (int i = 0; i < value.data!.length; i++) {
        setState(() {
          unitList.add(value.data![i].title ?? "");
        });
      }
      initValue();
    });
    getTeamList();
    isPermissionGrad =
        PreferencesManager.getBool(PreferencesKey.isContact, false);
    if (isPermissionGrad) {
      getContact();
    }
    super.initState();
  }

  getTeamList() async {
    await ApiServices.getTeamMemberList(widget.projectID).then((value) {
      setState(() {
        allTeamMember = value.data!
            .map((contact) => CustomTeamList(teamDataList: contact))
            .toList();
        if (value.data != null) {
          for (int i = 0; i < value.data!.length; i++) {
            print(" task Right ${value.data![i].taskRight}");
            if (value.data![i].taskRight != null) {
              List ab = (value.data![i].taskRight.split(','));
              if (ab.isNotEmpty) {
                for (int j = 0; j < ab.length; j++) {
                  if (widget.id.toString().trim() == ab[j].toString().trim()) {
                    assignTeamMember.add(value.data![i].teamDetails!);
                  }
                }
              }
            }
          }
        }
      });
    });
  }

  initValue() {
    startDateController.text = Utils.showData(widget.startDate);
    endDateController.text = Utils.showData(widget.endDate);
    totalController.text =
        widget.totalWork == "null" ? '' : widget.totalWork.toString();
    if (widget.unitValue != 0) {
      selectUnit = widget.unitValue;
      unitListValue = unitList[widget.unitValue - 1];
    }
  }

  List<Contact>? contacts;

  void getContact() async {
    if (await FlutterContacts.requestPermission()) {
      contacts = await FlutterContacts.getContacts(
          withProperties: true, withPhoto: true);
      _populateContacts(contacts!);
      print(contacts);
      isPermissionGrad = true;
      PreferencesManager.setBool(PreferencesKey.isContact, true);
      setState(() {});
    }
  }

  int? currentIndexTeam;
  int? currentIndex;
  List<Contact> _contacts = [];
  List<CustomContact> _uiCustomContacts = [];
  List<CustomContact> _allContacts = [];
  bool _isLoading = false;
  bool isPermissionGrad = false;

  void _populateContacts(Iterable<Contact> contacts) {
    _contacts = contacts.where((item) => item.displayName != null).toList();
    _contacts.sort((a, b) => a.displayName.compareTo(b.displayName));
    _allContacts =
        _contacts.map((contact) => CustomContact(contact: contact)).toList();
    setState(() {
      _uiCustomContacts = _allContacts;
      _isLoading = false;
    });
  }

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

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: AppColor.white,
        bottomNavigationBar: InkWell(
            onTap: () {
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
              if (totalController.text.isEmpty) {
                setState(() {
                  selectTotal = true;
                });
              } else {
                setState(() {
                  selectTotal = false;
                });
              }
              if (selectUnit == 0) {
                setState(() {
                  isUnit = true;
                });
              } else {
                setState(() {
                  isUnit = false;
                });
              }
              if (startDateController.text.isEmpty &&
                  endDateController.text.isEmpty &&
                  totalController.text.isEmpty &&
                  selectUnit == 0) {
              } else {
                ApiServices.updateTask(
                        widget.id,
                        Utils.passData(startDateController.text),
                        Utils.passData(endDateController.text),
                        int.parse(totalController.text),
                        selectUnit)
                    .then((value) {
                  Navigator.pop(context, value);
                  // getTeamList();
                });
              }
            },
            child: Image.asset(ImageAsset.btnSave1)),
        body: WillPopScope(
          onWillPop: () {
            Navigator.pop(context, assignTeamMember.length);
            return Future(() => false);
          },
          child: Column(
            children: [
              appBar("Task Details", () {
                Navigator.pop(context, assignTeamMember.length);
              }),
              Expanded(
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(3.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 30.w,
                          ),
                          Text(
                            "Task Details- ${widget.taskDetailsList.title}",
                            overflow: TextOverflow.clip,
                            style: Utils.regularTextStyle(
                                fontSize: AppDimens.large_font,
                                color: AppColor.textColor3),
                          ),
                          SizedBox(
                            height: 5.w,
                          ),
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
                                    // setState(() async {
                                    //   startDateController.text =
                                    //       await selectDate(context);
                                    // });
                                  },
                                  title: AppString.strStartDate,
                                  controller: startDateController,
                                  focusNode: startDateNode,
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
                                    focusNode: endDateNode,
                                    readOnly: true,
                                    onTab: () {
                                      selectDate(context).then((value) {
                                        endDateController.text =
                                            Utils.showData(value);
                                      });
                                      /* setState(() async {
                                        endDateController.text =
                                            await selectDate(context);
                                      });*/
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
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                flex: 5,
                                child: CommandTextFormField(
                                  onTab: () {},
                                  title: AppString.strEnterTotalWork,
                                  controller: totalController,
                                  focusNode: totalNode,
                                  readOnly: readOnly,
                                  hint: AppString.strEnterTotalWork,
                                  textInputAction: TextInputAction.next,
                                  textInputType: TextInputType.number,
                                ),
                              ),
                              Expanded(
                                flex: 3,
                                child: Container(
                                  height: 15.w,
                                  decoration: BoxDecoration(
                                      color: AppColor.textFormFieldBg,
                                      border: Border.all(
                                          color: AppColor.textFormFieldBg,
                                          width: 1),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10))),
                                  child: Center(
                                    child: Padding(
                                      padding: EdgeInsets.all(3.0),
                                      child: DropdownButton<String>(
                                        isExpanded: false,
                                        underline: Container(
                                          color: AppColor.textFormFieldBg,
                                          height: 1,
                                          width: double.infinity,
                                        ),
                                        // value: valueTarget,
                                        hint: Text(
                                          'Unit',
                                          style: Utils.regularTextStyle(
                                              color: AppColor.hintText,
                                              fontSize: AppDimens.medium_font),
                                        ),
                                        value: unitListValue,
                                        iconEnabledColor:
                                            AppColor.textFormFieldBg,
                                        dropdownColor: AppColor.textFormFieldBg,
                                        icon: const Icon(
                                          Icons.arrow_drop_down,
                                          size: 30,
                                          color: AppColor.textColor,
                                        ),
                                        elevation: 0,
                                        style: Utils.regularTextStyle(
                                            color: AppColor.textColor,
                                            fontSize: AppDimens.medium_font),
                                        onChanged: (String? newValue) {
                                          setState(() {
                                            readOnly = false;
                                            unitListValue = newValue!;
                                            selectUnit =
                                                1 + unitList.indexOf(newValue);
                                            if (unitModel[(unitList
                                                        .indexOf(newValue))]
                                                    .measurementType ==
                                                1) {
                                              readOnly = true;
                                              totalController.text = "100";
                                            }
                                          });
                                        },
                                        items: unitList
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
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              selectTotal
                                  ? Expanded(
                                      child: Padding(
                                        padding: EdgeInsets.only(
                                          left: 5.5.w,
                                        ),
                                        child: Text(
                                          "Please enter total work",
                                          style: TextStyle(
                                              color: AppColor.red1,
                                              fontSize: 12.0),
                                        ),
                                      ),
                                    )
                                  : Expanded(child: Container()),
                              isUnit
                                  ? Expanded(
                                      child: Padding(
                                        padding: EdgeInsets.only(
                                          left: 5.5.w,
                                        ),
                                        child: Text(
                                          "Please select unit",
                                          style: TextStyle(
                                              color: AppColor.red1,
                                              fontSize: 12.0),
                                        ),
                                      ),
                                    )
                                  : Expanded(child: Container())
                            ],
                          ),
                          SizedBox(
                            height: 10.w,
                          ),
                          InkWell(
                            onTap: () {
                              assignTask();
                              assignTaskBottomSheet();
                            },
                            child: Container(
                              height: 10.w,
                              width: double.infinity,
                              child: Text(
                                "+ Assign team member",
                                style: Utils.regularTextStyle(
                                    fontSize: AppDimens.large_font,
                                    color: AppColor.textColor3),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 60.w,
                            width: double.infinity,
                            child: ListView.builder(
                                itemCount: assignTeamMember.length,
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Container(
                                              height: 10.w,
                                              width: 10.w,
                                              decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: AppColor.gray1),
                                              child: assignTeamMember[index]
                                                          .image ==
                                                      null
                                                  ? Icon(
                                                      Icons.person,
                                                      size: 25,
                                                      color: AppColor.gray,
                                                    )
                                                  : CircleAvatar(
                                                      radius: 200.0,
                                                      backgroundImage:
                                                          NetworkImage(AppString
                                                                  .basePath +
                                                              assignTeamMember[
                                                                      index]
                                                                  .image),
                                                    ),
                                            ),
                                            SizedBox(
                                              width: 5.w,
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  assignTeamMember[index]
                                                          .name ??
                                                      "-",
                                                  overflow: TextOverflow.clip,
                                                  style: Utils.regularTextStyle(
                                                      color: AppColor.black),
                                                ),
                                                SizedBox(
                                                  height: 1.w,
                                                ),
                                                Text(
                                                  assignTeamMember[index]
                                                          .mobile ??
                                                      "-",
                                                  overflow: TextOverflow.clip,
                                                  style: Utils.regularTextStyle(
                                                      color: AppColor.gray),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        InkWell(
                                          onTap: () {
                                            setState(() {
                                              ApiServices.postTaskRight(
                                                  widget.id,
                                                  widget.projectID,
                                                  assignTeamMember[index].id ??
                                                      0);
                                              showMyDialog(context,
                                                  "are you sure, remove this members?",
                                                  () {
                                                assignTeamMember
                                                    .removeAt(index);
                                                Navigator.pop(context);
                                              });
                                            });
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                                color: AppColor.red,
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(5))),
                                            child: Padding(
                                              padding: EdgeInsets.all(2.w),
                                              child: Text(
                                                "Remove",
                                                style: Utils.regularTextStyle(
                                                    color: AppColor.white),
                                              ),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  );
                                }),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  assignTask() {
    if (assignTeamMember.isNotEmpty) {
      teamList.clear();
      for (int j = 0; j < allTeamMember.length; j++) {
        bool isCheck = false;
        CustomTeamList? data;
        for (int k = 0; k < assignTeamMember.length; k++) {
          // print(" id j ${AllTeamMember[j].teamDataList.teamDetails?.id}");
          // print("id k ${assignTeamMember[k].id}");
          if (assignTeamMember[k].id.toString().trim() ==
              allTeamMember[j].teamDataList.teamDetails?.id.toString().trim()) {
            // print(" ifff :  ");
            isCheck = true;
            break;
          }
          data = allTeamMember[j];
        }
        if (isCheck == false) {
          teamList.add(data!);
        }
      }
    } else {
      teamList.clear();
      teamList.addAll(allTeamMember);
    }
  }

  assignTaskBottomSheet() {
    showModalBottomSheet(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5.0),
      ),
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, state) {
          return SizedBox(
            height: 70.h,
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(5.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Assign Task",
                        style: Utils.mediumTextStyle(
                            fontSize: AppDimens.medium_font),
                      ),
                      Row(
                        children: [
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
                    ],
                  ),
                ),
                Divider(),
                Padding(
                  padding: EdgeInsets.only(left: 5.w, bottom: 2.w, top: 2.w),
                  child: InkWell(
                    onTap: () {
                      // addMember(state);
                      sendMobile(state);
                    },
                    child: Row(
                      children: [
                        Container(
                          height: 10.w,
                          width: 10.w,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle, color: AppColor.gray1),
                          child: Icon(
                            Icons.person_add_alt_1,
                            size: 25,
                            color: AppColor.mainColor,
                          ),
                        ),
                        SizedBox(
                          width: 5.w,
                        ),
                        Text(
                          "Add New Member",
                          style:
                              Utils.regularTextStyle(color: AppColor.mainColor),
                        ),
                      ],
                    ),
                  ),
                ),
                Divider(),
                SizedBox(
                  height: 40.5.h,
                  child: teamList.isEmpty
                      ? Center(
                          child: Text(
                            "Data Not Found.",
                            style:
                                Utils.regularTextStyle(color: AppColor.black),
                          ),
                        )
                      : ListView.separated(
                          separatorBuilder: (BuildContext context, int index) =>
                              const Divider(),
                          padding: EdgeInsets.zero,
                          shrinkWrap: true,
                          itemCount: teamList.length,
                          itemBuilder: (BuildContext context, index) {
                            return InkWell(
                              onTap: () {
                                for (int i = 0; i < teamList.length; i++) {
                                  if (index == i) {
                                    state(() {
                                      currentIndexTeam = index;
                                      teamList[index].isChecked = true;
                                    });
                                  } else {
                                    state(() {
                                      teamList[i].isChecked = false;
                                    });
                                  }
                                }
                              },
                              child: Padding(
                                padding: EdgeInsets.only(
                                    left: 5.w,
                                    right: 5.w,
                                    bottom: 2.w,
                                    top: 2.w),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          height: 10.w,
                                          width: 10.w,
                                          decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: AppColor.gray1),
                                          child: teamList[index]
                                                      .teamDataList
                                                      .teamDetails
                                                      ?.image ==
                                                  null
                                              ? Icon(
                                                  Icons.person,
                                                  size: 25,
                                                  color: AppColor.gray,
                                                )
                                              : CircleAvatar(
                                                  radius: 200.0,
                                                  backgroundImage: NetworkImage(
                                                      AppString.basePath +
                                                          teamList[index]
                                                              .teamDataList
                                                              .teamDetails
                                                              ?.image),
                                                ),
                                        ),
                                        SizedBox(
                                          width: 5.w,
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              teamList[index]
                                                      .teamDataList
                                                      .teamDetails
                                                      ?.name ??
                                                  "-",
                                              overflow: TextOverflow.clip,
                                              style: Utils.regularTextStyle(
                                                  color: AppColor.black),
                                            ),
                                            SizedBox(
                                              height: 1.w,
                                            ),
                                            Text(
                                              teamList[index]
                                                      .teamDataList
                                                      .teamDetails
                                                      ?.mobile ??
                                                  "",
                                              style: Utils.regularTextStyle(
                                                  color: AppColor.gray),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    Checkbox(
                                        activeColor: AppColor.mainColor,
                                        value: teamList[index].isChecked,
                                        onChanged: (bool? value) {
                                          for (int i = 0;
                                              i < teamList.length;
                                              i++) {
                                            if (index == i) {
                                              state(() {
                                                currentIndexTeam = index;
                                                teamList[index].isChecked =
                                                    true;
                                              });
                                            } else {
                                              state(() {
                                                teamList[i].isChecked = false;
                                              });
                                            }
                                          }
                                        }),
                                  ],
                                ),
                              ),
                            );
                          }),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 3.w, left: 5.w, right: 5.w),
                  child: commandButton(
                      name: "Submit",
                      bg: AppColor.mainColor,
                      onPress: () {
                        if (currentIndexTeam == null) {
                          Toasts.showToast("please select member");
                        } else {
                          setState(() {
                            ApiServices.postTaskRight(
                                widget.id,
                                widget.projectID,
                                teamList[currentIndexTeam ?? 0]
                                        .teamDataList
                                        .registerUserId ??
                                    0);
                            assignTeamMember.add(teamList[currentIndexTeam ?? 0]
                                .teamDataList
                                .teamDetails!);
                            teamList[currentIndexTeam ?? 0].isChecked = false;
                            currentIndexTeam = null;
                            Navigator.pop(context);
                          });
                        }
                      },
                      strColor: AppColor.white),
                )
              ],
            ),
          );
        });
      },
    ).then((value) {});
  }

  addMember(StateSetter state) {
    showModalBottomSheet(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.0),
        ),
        isScrollControlled: true,
        context: context,
        builder: (BuildContext context) {
          return BottomSheet(
            onClosing: () {},
            builder: (BuildContext context) {
              return StatefulBuilder(
                  builder: (BuildContext context, StateSetter _setStates) {
                return SizedBox(
                  height: 70.h,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                            left: 5.w, right: 5.w, top: 2.w, bottom: 2.w),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Add Member",
                              style:
                                  Utils.mediumTextStyle(color: AppColor.black),
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
                            left: 5.w, right: 5.w, top: 1.w, bottom: 1.w),
                        child: Row(
                          children: [
                            Container(
                              height: 10.w,
                              width: 10.w,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: AppColor.green),
                              child: Icon(
                                Icons.whatsapp,
                                size: 25,
                                color: AppColor.white,
                              ),
                            ),
                            SizedBox(
                              width: 5.w,
                            ),
                            Text(
                              "send Invite On Whatsapp",
                              style:
                                  Utils.regularTextStyle(color: AppColor.black),
                            ),
                          ],
                        ),
                      ),
                      Divider(),
                      Padding(
                        padding: EdgeInsets.only(
                            left: 5.w, right: 5.w, top: 1.w, bottom: 1.w),
                        child: InkWell(
                          onTap: () {
                            Navigator.pop(context);
                            sendMobile(state);
                          },
                          child: Row(
                            children: [
                              Container(
                                height: 10.w,
                                width: 10.w,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: AppColor.dotColor),
                                child: Icon(
                                  Icons.call,
                                  size: 25,
                                  color: AppColor.white,
                                ),
                              ),
                              SizedBox(
                                width: 5.w,
                              ),
                              Text(
                                "send Invite On Mobile Number",
                                style: Utils.regularTextStyle(
                                    color: AppColor.black),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Divider(),
                      Padding(
                        padding: EdgeInsets.only(
                            left: 5.w, right: 5.w, top: 2.w, bottom: 2.w),
                        child: Text(
                          "Contacts List",
                          style: Utils.mediumTextStyle(color: AppColor.black),
                        ),
                      ),
                      Divider(),
                      SizedBox(
                        height: 35.h,
                        child: isPermissionGrad
                            ? (contacts) == null
                                ? Center(child: CircularProgressIndicator())
                                : ListView.separated(
                                    shrinkWrap: true,
                                    itemBuilder: (context, index) {
                                      return InkWell(
                                          onTap: () {
                                            _setStates(() {
                                              for (int i = 0;
                                                  i < _uiCustomContacts.length;
                                                  i++) {
                                                if (index == i) {
                                                  _setStates(() {
                                                    currentIndex = index;
                                                    _uiCustomContacts[index]
                                                        .isChecked = true;
                                                  });
                                                } else {
                                                  _setStates(() {
                                                    _uiCustomContacts[i]
                                                        .isChecked = false;
                                                  });
                                                }
                                              }
                                            });
                                          },
                                          child: _buildListTile(
                                              _uiCustomContacts,
                                              index,
                                              _setStates));
                                    },
                                    separatorBuilder:
                                        (BuildContext context, int index) =>
                                            const Divider(),
                                    itemCount: _uiCustomContacts.length)
                            : Center(
                                child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  primary: AppColor.mainColor,
                                ),
                                child: Text(
                                  'View Contacts',
                                  style: Utils.mediumTextStyle(
                                      color: AppColor.white),
                                ),
                                onPressed: () async {
                                  if (await FlutterContacts
                                      .requestPermission()) {
                                    _setStates(() {
                                      isPermissionGrad = true;
                                    });
                                    contacts =
                                        await FlutterContacts.getContacts(
                                            withProperties: true,
                                            withPhoto: true);
                                    _populateContacts(contacts!);
                                    print(contacts);

                                    PreferencesManager.setBool(
                                        PreferencesKey.isContact, true);
                                    _setStates(() {});
                                  }
                                },
                              )),
                      ),
                      Padding(
                        padding:
                            EdgeInsets.only(top: 3.w, left: 5.w, right: 5.w),
                        child: commandButton(
                            name: "Submit",
                            bg: AppColor.mainColor,
                            onPress: () {
                              if (currentIndex == null) {
                                Toasts.showToast("please select member");
                              } else {
                                ApiServices.postAddMember(
                                        _uiCustomContacts[currentIndex!]
                                            .contact
                                            .displayName,
                                        "91",
                                        _uiCustomContacts[currentIndex!]
                                            .contact
                                            .phones[0]
                                            .number
                                            .replaceFirst("+91", ""),
                                        widget.projectID)
                                    .then((value) {
                                  state(() {
                                    print("value re----");
                                    state(() {
                                      _uiCustomContacts[currentIndex ?? 0]
                                          .isChecked = false;
                                      currentIndex = null;
                                      teamList.add(
                                          CustomTeamList(teamDataList: value));
                                      allTeamMember.add(
                                          CustomTeamList(teamDataList: value));
                                    });
                                    Navigator.pop(context);
                                  });
                                });
                              }
                            },
                            strColor: AppColor.white),
                      )
                    ],
                  ),
                );
              });
            },
          );
        });
  }

  TextEditingController numberController = TextEditingController();
  String? code = "+91";
  String? code1 = "91";

  sendMobile(StateSetter state) {
    showModalBottomSheet(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.0),
        ),
        isScrollControlled: true,
        context: context,
        builder: (BuildContext context) {
          return SingleChildScrollView(
            child: Container(
              color: AppColor.white,
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.all(5.w),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Sead Invite",
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
                  Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                            left: 3.w,
                            bottom: MediaQuery.of(context).viewInsets.bottom),
                        child: Container(
                          height: 14.5.w,
                          decoration: BoxDecoration(
                            color: AppColor.textFormFieldBg,
                            border: Border.all(
                                color: AppColor.textFormFieldBg, width: 1),
                            borderRadius: BorderRadius.all(
                              Radius.circular(10),
                            ),
                          ),
                          child: CountryCodePicker(
                            textStyle: Utils.regularTextStyle(
                                fontSize: AppDimens.large_font),
                            onChanged: (value) {
                              print("contry Code ${value.dialCode}");
                              setState(() {
                                code = value.dialCode;
                                code1 = value.dialCode?.replaceFirst("+", "");
                                print("code $code");
                              });
                            },
                            // Initial selection and favorite can be one of code ('IT') OR dial_code('+39')
                            initialSelection: 'In',
                            favorite: [code ?? '+91', 'In'],
                            // optional. Shows only country name and flag
                            showCountryOnly: true,
                            // optional. Shows only country name and flag when popup is closed.
                            showOnlyCountryWhenClosed: false,
                            // optional. aligns the flag and the Text left
                            alignLeft: false,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(
                              left: 3.w,
                              bottom: MediaQuery.of(context).viewInsets.bottom),
                          child: CommandTextFormField(
                              controller: numberController,
                              hint: "Enter your mobile number",
                              textInputAction: TextInputAction.next,
                              textInputType: TextInputType.number,
                              onChange: (value) {}),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 3.h,
                  ),
                  Padding(
                    padding: EdgeInsets.all(5.w),
                    child: commandButton(
                        name: "Submit",
                        bg: AppColor.mainColor,
                        onPress: () {
                          if (numberController.text.isEmpty) {
                            Toasts.showToast("please enter mobile number");
                          } else {
                            ApiServices.postAddMember("", code1!,
                                    numberController.text, widget.projectID)
                                .then((value) {
                              state(() {
                                code = "+91";
                                numberController.clear();
                                print("value re----");
                                teamList
                                    .add(CustomTeamList(teamDataList: value));
                                Navigator.pop(context);
                              });
                            });
                          }
                        },
                        strColor: AppColor.white),
                  ),
                ],
              ),
            ),
          );
        });
  }

  ListTile _buildListTile(
      List<CustomContact> c, int index, StateSetter setState) {
    Uint8List? image = c[index].contact.photo;
    return ListTile(
        leading: (c[index].contact.photo != null)
            ? CircleAvatar(backgroundImage: MemoryImage(image!))
            : CircleAvatar(
                child: Text(
                    (c[index].contact.displayName[0] +
                        c[index].contact.displayName[1].toUpperCase()),
                    style: TextStyle(color: Colors.white)),
              ),
        title: Text(c[index].contact.displayName,
            overflow: TextOverflow.clip,
            style: Utils.regularTextStyle(color: AppColor.black)),
        subtitle: c[index].contact.phones.isNotEmpty
            ? Text(c[index].contact.phones[0].number,
                overflow: TextOverflow.clip,
                style: Utils.regularTextStyle(color: AppColor.gray))
            : Text(''),
        trailing: Checkbox(
            activeColor: AppColor.mainColor,
            value: c[index].isChecked,
            onChanged: (bool? value) {
              for (int i = 0; i < _uiCustomContacts.length; i++) {
                if (index == i) {
                  setState(() {
                    currentIndex = index;
                    _uiCustomContacts[index].isChecked = true;
                  });
                } else {
                  setState(() {
                    _uiCustomContacts[i].isChecked = false;
                  });
                }
              }
            }));
  }

  inviteNumber() {
    showModalBottomSheet<void>(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.0),
        ),
        context: context,
        builder: (BuildContext context) {
          return Container();
        });
  }
}
