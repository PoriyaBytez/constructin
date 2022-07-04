import 'dart:io';
import 'dart:typed_data';

import 'package:constructin/model/comment_model.dart';
import 'package:constructin/screen/task/full_screen_image.dart';
import 'package:constructin/utils/app_color.dart';
import 'package:constructin/utils/app_dimens.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

import '../model/contact_model.dart';
import '../model/customTeamList.dart';
import '../model/issue_model.dart';
import '../model/team_model.dart';
import '../utils/api_services.dart';
import '../utils/app_asset.dart';
import '../utils/app_string.dart';
import '../utils/shared_preferences/preferences_key.dart';
import '../utils/shared_preferences/preferences_manager.dart';
import '../utils/toasts.dart';
import '../utils/unil.dart';
import '../widget/comman_widget.dart';
import '../widget/text_form_field.dart';

class IssueDetailsScreen extends StatefulWidget {
  IssueData data;

  IssueDetailsScreen({required this.data});

  @override
  State<IssueDetailsScreen> createState() => _IssueDetailsScreenState();
}

class _IssueDetailsScreenState extends State<IssueDetailsScreen> {
  int selectIndex = 1;
  var outputDate;

  int? currentIndexTeam;
  int? currentIndex;
  List<Contact> _contacts = [];
  List<CustomContact> _uiCustomContacts = [];
  List<CustomContact> _allContacts = [];
  List<Contact>? contacts;
  bool isPermissionGrad = false;
  List<CustomTeamList> allTeamMember = [];
  List<CustomTeamList> teamList = [];

  List<TeamData> members = [];
  List<TeamData> membersAssign = [];
  TextEditingController commentController = TextEditingController();

  List<CommentData> commentList = [];
  List<CommentData> attachment = [];

  @override
  void initState() {
    var outputFormat = DateFormat("hh:mm a, dd MMM, yyyy");
    outputDate = outputFormat.format(widget.data.createdAt!);
    attachment = widget.data.attachment!;
    getTeamList();
    getCommentList();
    super.initState();
  }

  getTeamList() async {
    print("member : ${widget.data.members?.length}");
    print("issue id : ${widget.data.id}");
    members = widget.data.members!;
    allTeamMember = widget.data.members!
        .map((e) => CustomTeamList(teamDataList: e))
        .toList();

    for (int i = 0; i < members.length; i++) {
      setState(() {
        print(" issue Right  ${members[i].issuesRight}");
        final issuesRight = members[i].issuesRight;
        if (issuesRight != null) {
          List mList = (issuesRight.split(','));
          if (mList.isNotEmpty) {
            for (int j = 0; j < mList.length; j++) {
              if (widget.data.id.toString().trim() ==
                  mList[j].toString().trim()) {
                membersAssign.add(members[i]);
              }
            }
          }
        }
      });
    }
  }

  getCommentList() {
    ApiServices.getCommentList(widget.data.id!).then((value) {
      setState(() {
        commentList = value.data!;
      });
      for (int i = 0; i < commentList.length; i++) {
        if (commentList[i].image != null) {
          attachment.add(commentList[i]);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColor.white,
        body: Column(
          children: [
            appBar("Material Shortage", () {
              Navigator.pop(context);
            }),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(
                    top: 8.w, left: 4.w, right: 3.w, bottom: 3.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                  color: AppColor.green1,
                                  borderRadius: BorderRadius.circular(5)),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  widget.data.issueCategory?.title ?? '',
                                  style: Utils.regularTextStyle(
                                      color: AppColor.green),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 5.w,
                            ),
                            widget.data.tag == null
                                ? Container(
                                    decoration: BoxDecoration(
                                        color: AppColor.btnUpdateBg,
                                        borderRadius: BorderRadius.circular(5)),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        widget.data.task.title ?? "",
                                        style: Utils.regularTextStyle(
                                            color: AppColor.textColor2),
                                      ),
                                    ),
                                  )
                                : Container(),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 3.w,
                    ),
                    Text(
                      widget.data.title ?? "",
                      maxLines: 10,
                      style: Utils.regularTextStyle(
                          color: AppColor.textColor3,
                          fontSize: AppDimens.large_font),
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
                              shape: BoxShape.circle,
                              border:
                                  Border.all(color: AppColor.black, width: 1)),
                          child: widget.data.teamDetails?.image == null
                              ? Icon(
                                  Icons.person,
                                  size: 8.w,
                                )
                              : CircleAvatar(
                                  radius: 200.0,
                                  backgroundImage: NetworkImage(
                                      AppString.basePath +
                                          widget.data.teamDetails?.image),
                                ),
                        ),
                        SizedBox(
                          width: 2.w,
                        ),
                        Text(
                          widget.data.teamDetails?.name ?? "",
                          style: Utils.regularTextStyle(
                              color: AppColor.textColor8, fontSize: 2.4.w),
                        ),
                        SizedBox(
                          width: 2.w,
                        ),
                        Container(
                          height: 8.w,
                          width: 8.w,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage(ImageAsset.iconSchedule))),
                        ),
                        SizedBox(
                          width: 2.w,
                        ),
                        Text(
                          outputDate,
                          style: Utils.regularTextStyle(
                              color: AppColor.textColor8, fontSize: 2.4.w),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10.w,
                    ),
                    Container(
                      height: 10.w,
                      color: AppColor.textFormFieldBg,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          InkWell(
                            onTap: () {
                              setState(() {
                                selectIndex = 1;
                              });
                            },
                            child: Text(
                              "Comments",
                              style: Utils.regularTextStyle(
                                  color: selectIndex == 1
                                      ? AppColor.textColor2
                                      : AppColor.textColor3),
                            ),
                          ),
                          Container(
                            width: 2,
                            color: AppColor.floatBg1,
                          ),
                          InkWell(
                            onTap: () {
                              setState(() {
                                selectIndex = 3;
                              });
                            },
                            child: Text(
                              "Details",
                              style: Utils.regularTextStyle(
                                  color: selectIndex == 3
                                      ? AppColor.textColor2
                                      : AppColor.textColor3),
                            ),
                          ),
                          Container(
                            width: 2,
                            color: AppColor.floatBg1,
                          ),
                          InkWell(
                            onTap: () {
                              setState(() {
                                selectIndex = 2;
                              });
                            },
                            child: Text(
                              "Attachments",
                              style: Utils.regularTextStyle(
                                  color: selectIndex == 2
                                      ? AppColor.textColor2
                                      : AppColor.textColor3),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10.w,
                    ),
                    selectIndex == 1
                        ? Expanded(
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: commentList.length,
                              itemBuilder: (context, index) {
                                var path;
                                if (commentList[index].image != null) {
                                  path =
                                      commentList[index].image?.split(".").last;
                                }

                                return Card(
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                        top: 3.w,
                                        bottom: 3.w,
                                        left: 3.w,
                                        right: 3.w),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Text(
                                          "just now",
                                          style: Utils.regularTextStyle(
                                              color: AppColor.textColor8,
                                              fontSize: AppDimens.default_font),
                                        ),
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              height: 8.w,
                                              width: 8.w,
                                              decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  border: Border.all(
                                                      color: AppColor.black,
                                                      width: 1)),
                                              child: commentList[index].image ==
                                                      ""
                                                  ? Icon(
                                                      Icons.person,
                                                      size: 8.w,
                                                    )
                                                  : CircleAvatar(
                                                      radius: 200.0,
                                                      backgroundImage:
                                                          NetworkImage(AppString
                                                                  .basePath +
                                                              commentList[index]
                                                                  .members
                                                                  ?.image),
                                                    ),
                                            ),
                                            SizedBox(
                                              width: 3.w,
                                            ),
                                            commentList[index].image == null
                                                ? Text(
                                                    commentList[index]
                                                            .comment ??
                                                        "",
                                                    style:
                                                        Utils.regularTextStyle(
                                                            color:
                                                                AppColor.black,
                                                            fontSize: AppDimens
                                                                .default_font),
                                                  )
                                                : InkWell(
                                                    onTap: () {
                                                      Navigator.push(context,
                                                          MaterialPageRoute(
                                                              builder: (_) {
                                                        return FullScreen(
                                                            url: commentList[
                                                                    index]
                                                                .image!,
                                                            extention: path!);
                                                      }));
                                                    },
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: path != "pdf"
                                                          ? Container(
                                                              height: 20.w,
                                                              width: 20.w,
                                                              decoration: BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius.all(
                                                                          Radius.circular(
                                                                              5)),
                                                                  image: DecorationImage(
                                                                      image: NetworkImage((AppString
                                                                              .basePath) +
                                                                          (commentList[index].image ??
                                                                              "")),
                                                                      fit: BoxFit
                                                                          .cover)),
                                                            )
                                                          : Icon(
                                                              Icons
                                                                  .picture_as_pdf_outlined,
                                                              size: 10.w,
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
                          )
                        : selectIndex == 2
                            ? Expanded(
                                child: GridView.builder(
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                ),
                                itemCount: widget.data.attachment!.length,
                                itemBuilder: (context, index) {
                                  final path = widget
                                      .data.attachment![index].image
                                      ?.split(".")
                                      .last;
                                  print(path?.split(".").last);
                                  print("extenstion $path");
                                  return InkWell(
                                    onTap: () {
                                      Navigator.push(context,
                                          MaterialPageRoute(builder: (_) {
                                        return FullScreen(
                                            url: widget
                                                .data.attachment![index].image!,
                                            extention: path!);
                                      }));
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: path != "pdf"
                                          ? Container(
                                              height: 10.w,
                                              width: 10.w,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(5)),
                                                  image: DecorationImage(
                                                      image: NetworkImage(
                                                          (AppString.basePath) +
                                                              (widget
                                                                      .data
                                                                      .attachment![
                                                                          index]
                                                                      .image ??
                                                                  "")),
                                                      fit: BoxFit.cover)),
                                            )
                                          : Icon(
                                              Icons.picture_as_pdf_outlined,
                                              size: 10.w,
                                            ),
                                    ),
                                  );
                                },
                              ))
                            : Expanded(
                                child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Issue raised on - ${outputDate}"),
                                  SizedBox(
                                    height: 5.w,
                                  ),
                                  Text(
                                      "Task Name- ${widget.data.tag == null ? widget.data.task.title : ''}"),
                                  SizedBox(
                                    height: 5.w,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("Team members- "),
                                      InkWell(
                                        onTap: () {
                                          assignTask();
                                          assignTaskBottomSheet();
                                        },
                                        child: Text(
                                          "add member +",
                                          style: Utils.regularTextStyle(
                                              color: AppColor.dotColor,
                                              fontSize: AppDimens.large_font),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 5.w,
                                  ),
                                  Expanded(
                                    child: ListView.builder(
                                      itemCount: membersAssign.length,
                                      shrinkWrap: true,
                                      itemBuilder: (context, index) {
                                        return Card(
                                          child: Padding(
                                            padding: EdgeInsets.all(3.w),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  membersAssign[index]
                                                          .teamDetails
                                                          ?.name ??
                                                      "",
                                                  style:
                                                      Utils.regularTextStyle(),
                                                ),
                                                InkWell(
                                                    onTap: () {
                                                      ApiServices
                                                          .postIssueRight(
                                                              widget.data.id!,
                                                              widget.data
                                                                  .projectId!,
                                                              widget.data
                                                                  .taskId!);
                                                    },
                                                    child: Text(
                                                      "remove",
                                                      style: Utils
                                                          .regularTextStyle(),
                                                    ))
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              )),
                    selectIndex != 1
                        ? Container()
                        : Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Align(
                                alignment: Alignment.bottomCenter,
                                child: Container(
                                  width: 100.w,
                                  decoration: BoxDecoration(
                                      border:
                                          Border.all(color: AppColor.otpBox),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10))),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        width: 67.w,
                                        child: TextField(
                                          controller: commentController,
                                          decoration: InputDecoration(
                                            hintText: "Add comment",
                                            hintStyle: Utils.regularTextStyle(
                                                color: AppColor.hintText),
                                            contentPadding: EdgeInsets.all(3.w),
                                            enabledBorder: InputBorder.none,
                                            focusedBorder: InputBorder.none,
                                          ),
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          Utils.pickImageDialog(context, () {
                                            getFilePicker();
                                          }, () {
                                            openCamera(ImageSource.camera);
                                          });
                                        },
                                        child: Container(
                                          height: 12.w,
                                          child: Icon(
                                            Icons.attach_file,
                                            color: AppColor.black,
                                            size: 30,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 2.w,
                                      ),
                                      InkWell(
                                          onTap: () {
                                            ApiServices.poseComment(
                                                    widget.data.projectId!,
                                                    widget.data.id!,
                                                    widget.data.taskId!,
                                                    null,
                                                    commentController.text)
                                                .then((value) {
                                              setState(() {
                                                commentController.clear();
                                                commentList.add(value);
                                              });
                                            });
                                          },
                                          child: Container(
                                              height: 12.w,
                                              child: Center(
                                                  child: Text(
                                                "Post",
                                                style: Utils.regularTextStyle(
                                                    fontSize: 4.5.w),
                                              )))),
                                      SizedBox(
                                        width: 2.w,
                                      ),
                                    ],
                                  ),
                                )),
                          ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    attachment.clear();
    super.dispose();
  }

  assignTask() {
    if (membersAssign.isNotEmpty) {
      members.clear();
      for (int j = 0; j < allTeamMember.length; j++) {
        bool isCheck = false;
        CustomTeamList? data;
        for (int k = 0; k < membersAssign.length; k++) {
          // print(" id j ${AllTeamMember[j].teamDataList.teamDetails?.id}");
          // print("id k ${assignTeamMember[k].id}");
          if (membersAssign[k].id.toString().trim() ==
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

  openCamera(ImageSource source) async {
    XFile? pickedFile = (await ImagePicker().pickImage(
        source: source, maxWidth: 1000, maxHeight: 1000, imageQuality: 50));

    String fileName = File(pickedFile!.path).path.split('/').last;
    ApiServices.poseComment(
            widget.data.projectId!,
            widget.data.id!,
            widget.data.taskId!,
            await MultipartFile.fromFile(File(pickedFile.path).path,
                filename: fileName),
            commentController.text)
        .then((value) {
      setState(() {
        commentList.add(value);
        attachment.add(value);
        Navigator.pop(context);
      });
    });
  }

  getFilePicker() async {
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: FileType.custom,
      allowedExtensions: ['jpg', 'pdf', 'png'],
    );
    for (int i = 0; i < result!.files.length; i++) {
      String fileName = File(result.files[i].path!).path.split('/').last;
      print(" name $fileName");
      ApiServices.poseComment(
              widget.data.projectId!,
              widget.data.id!,
              widget.data.taskId!,
              await MultipartFile.fromFile(File(result.files[i].path!).path,
                  filename: fileName),
              commentController.text)
          .then((value) {
        setState(() {
          commentList.add(value);
          attachment.add(value);
          Navigator.pop(context);
        });
      });
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
                      addMember(state);
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
                                widget.data.id!,
                                widget.data.projectId!,
                                teamList[currentIndexTeam ?? 0]
                                        .teamDataList
                                        .registerUserId ??
                                    0);
                            membersAssign.add(
                                teamList[currentIndexTeam ?? 0].teamDataList);
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
                                        widget.data.projectId)
                                    .then((value) {
                                  state(() {
                                    print("value re----");
                                    state(() {
                                      _uiCustomContacts[currentIndex ?? 0]
                                          .isChecked = false;
                                      currentIndex = null;
                                      teamList.add(
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
  bool _isLoading = false;

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

  sendMobile(StateSetter state) {
    showModalBottomSheet(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.0),
        ),
        isScrollControlled: true,
        context: context,
        builder: (BuildContext context) {
          return Container(
            color: AppColor.white,
            height: 40.h,
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
                      padding: EdgeInsets.only(left: 3.w),
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
                        padding: EdgeInsets.all(3.w),
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
                                  numberController.text, widget.data.projectId)
                              .then((value) {
                            state(() {
                              code = "+91";
                              numberController.clear();
                              print("value re----");
                              teamList.add(CustomTeamList(teamDataList: value));
                              Navigator.pop(context);
                            });
                          });
                        }
                      },
                      strColor: AppColor.white),
                ),
              ],
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
}
