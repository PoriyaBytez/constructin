import 'dart:io';
import 'dart:typed_data';

import 'package:country_code_picker/country_code_picker.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:sizer/sizer.dart';

import '../../model/contact_model.dart';
import '../../model/customTeamList.dart';
import '../../model/issue_model.dart';
import '../../model/task_category_model.dart';
import '../../model/team_model.dart';
import '../../utils/api_services.dart';
import '../../utils/app_asset.dart';
import '../../utils/app_color.dart';
import '../../utils/app_dimens.dart';
import '../../utils/app_string.dart';
import '../../utils/shared_preferences/preferences_key.dart';
import '../../utils/shared_preferences/preferences_manager.dart';
import '../../utils/toasts.dart';
import '../../utils/util.dart';
import '../../widget/comman_widget.dart';
import '../../widget/search_text_form_field.dart';
import '../../widget/text_form_field.dart';

class TaskIssueScreen extends StatefulWidget {
  int? projectID;
  int? taskId;
  int tag;
  int edit;
  int? id;
  IssueData? issueData;

  TaskIssueScreen(
      {Key? key,
      required this.tag,
      this.projectID,
      this.taskId,
      required this.edit,
      this.id,
      this.issueData})
      : super(key: key);

  @override
  State<TaskIssueScreen> createState() => _TaskIssueScreenState();
}

class _TaskIssueScreenState extends State<TaskIssueScreen> {
  TextEditingController descriptionController = TextEditingController();
  TextEditingController tagController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  List<TaskCategoryData> issueCategory = [];
  List<TaskCategoryData> searchIssueCategory = [];

  bool isSelect = false;
  String selectCategory = '';
  int selectIssueCategory = 0;
  TextEditingController issueController = TextEditingController();
  TextEditingController searchController = TextEditingController();
  List<File> imageList = [];
  List<CustomTeamList> teamList = [];
  List<CustomTeamList> allTeamMember = [];
  List<TeamDetails> assignTeamMember = [];

  // int? currentIndexTeam;
  int? currentIndex;
  List<Contact> _contacts = [];
  List<CustomContact> _uiCustomContacts = [];
  List<CustomContact> _allContacts = [];
  bool _isLoading = false;
  bool isPermissionGrad = false;

  List<Contact>? contacts;

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
    if (widget.projectID != null) {
      getTeamList();
    }
    isPermissionGrad =
        PreferencesManager.getBool(PreferencesKey.isContact, false);
    if (isPermissionGrad) {
      getContact();
    }
    if (widget.issueData != null) {
      selectIssueCategory = widget.issueData!.issueCategoryId!;
      selectCategory = widget.issueData?.issueCategory?.title ?? "";
      descriptionController.text = widget.issueData?.title ?? " ";
      tagController.text = widget.issueData?.tag ?? "";
    }
    super.initState();
  }

  List<MultipartFile> list = [];

  openCamera(ImageSource source) async {
    XFile? pickedFile = (await ImagePicker().pickImage(
        source: source, maxWidth: 1000, maxHeight: 1000, imageQuality: 50));
    setState(() async {
      String fileName = File(pickedFile!.path).path.split('/').last;
      imageList.add(File(pickedFile.path));
      list.add(await MultipartFile.fromFile(File(pickedFile.path).path,
          filename: fileName));
      setState(() {});
      Navigator.pop(context);
    });
  }

  getFilePicker() async {
    final dir = await path_provider.getTemporaryDirectory();
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.custom,
      allowCompression: true,
      allowedExtensions: ['jpg', 'pdf', 'png'],
    );
    for (int i = 0; i < result!.files.length; i++) {
      String fileName = File(result.files[i].path!).path.split('/').last;
      imageList.add(File(result.files[i].path!));
      var mb = ((result.files[i].size) / 1024) / 1024;
      int? quality = Utils.getQuality(mb);
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
    setState(() {});
    Navigator.pop(context);
  }

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

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColor.white,
        bottomNavigationBar: InkWell(
            onTap: () async {
              List<int> registerUserIdes = [];
              for (int i = 0; i < assignTeamMember.length; i++) {
                registerUserIdes.add(assignTeamMember[i].id!);
              }
              if (selectCategory == '') {
                setState(() {
                  isSelect = true;
                });
              } else {
                setState(() {
                  isSelect = false;
                });
                if (_formKey.currentState!.validate()) {
                  setState(() {
                    _isLoading = true;
                  });
                  if (widget.edit == 0) {
                    await ApiServices.postIssue(
                            widget.projectID.toString(),
                            widget.taskId.toString(),
                            selectIssueCategory.toString(),
                            descriptionController.text,
                            widget.tag == 1 ? tagController.text : "",
                            list,
                            registerUserIdes.join(","))
                        .then((value) {
                      setState(() {
                        _isLoading = false;
                      });
                      Navigator.pop(context, value);
                    });
                  } else {
                    await ApiServices.editIssue(
                            widget.id!,
                            selectIssueCategory.toString(),
                            descriptionController.text,
                            widget.tag == 1 ? tagController.text : "")
                        .then((value) {
                      setState(() {
                        _isLoading = false;
                      });
                      Navigator.pop(context, value);
                    });
                  }
                }
              }
            },
            child: Container(
                height: 20.w,
                child: Image.asset(
                  ImageAsset.btnIssueSave,
                ))),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            appBar(widget.edit == 0 ? "Task issue" : "Update issue", () {
              Navigator.pop(context);
            }),
            SizedBox(
              height: 5.w,
            ),
            Expanded(
                child: Padding(
              padding: EdgeInsets.all(3.w),
              child: Stack(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // widget.tag == 1
                      //     ? Container()
                      //     : Padding(
                      //         padding: EdgeInsets.all(3.w),
                      //         child: Text(
                      //           "Task- ",
                      //           style: Utils.regularTextStyle(
                      //               fontSize: AppDimens.large_font,
                      //               color: AppColor.dotColor),
                      //         ),
                      //       ),
                      widget.edit == 0
                          ? Padding(
                              padding: EdgeInsets.all(3.w),
                              child: Text(
                                "New issue-",
                                style: Utils.regularTextStyle(
                                    fontSize: AppDimens.large_font,
                                    color: AppColor.dotColor),
                              ),
                            )
                          : Container(),
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
                      Form(
                        key: _formKey,
                        child: CommandTextFormField(
                          title: AppString.strEnterIssueDescription,
                          controller: descriptionController,
                          hint: AppString.strEnterIssueDescription,
                          textInputAction: TextInputAction.done,
                          textInputType: TextInputType.multiline,
                          maxLines: null,
                          validator: (value) {
                            if (value == "") {
                              return "Please enter Issuer Description";
                            }
                            return null;
                          },
                          onChange: (value) {},
                        ),
                      ),
                      widget.tag == 1
                          ? CommandTextFormField(
                              title: AppString.strAddTaskName,
                              controller: tagController,
                              hint: AppString.strAddTaskName,
                              textInputAction: TextInputAction.done,
                              textInputType: TextInputType.text,
                              maxLines: null,
                              onChange: (value) {},
                            )
                          : widget.issueData?.tag == null
                              ? Container()
                              : CommandTextFormField(
                                  title: AppString.strAddTaskName,
                                  controller: tagController,
                                  hint: AppString.strAddTaskName,
                                  textInputAction: TextInputAction.done,
                                  textInputType: TextInputType.text,
                                  maxLines: null,
                                  onChange: (value) {},
                                ),
                      widget.edit == 0
                          ? Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: 3.w,
                                  ),
                                  widgetImageList("+ Add Photos/attachment"),
                                  InkWell(
                                    onTap: () {
                                      assignTask();
                                      teamMemberBottomSheet();
                                    },
                                    child: Padding(
                                      padding:
                                          EdgeInsets.only(left: 3.w, top: 3.w),
                                      child: Text(
                                        "+ Add team member",
                                        style: Utils.regularTextStyle(
                                            fontSize: AppDimens.large_font,
                                            color: AppColor.dotColor),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    // height: 50.w,
                                    // width: double.infinity,
                                    child: ListView.builder(
                                        itemCount: assignTeamMember.length,
                                        shrinkWrap: true,
                                        reverse: false,
                                        itemBuilder: (context, index) {
                                          return Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Row(
                                                  children: [
                                                    Container(
                                                      height: 10.w,
                                                      width: 10.w,
                                                      decoration: BoxDecoration(
                                                          shape:
                                                              BoxShape.circle,
                                                          color:
                                                              AppColor.gray1),
                                                      child: assignTeamMember[
                                                                      index]
                                                                  .image ==
                                                              null
                                                          ? Icon(
                                                              Icons.person,
                                                              size: 25,
                                                              color:
                                                                  AppColor.gray,
                                                            )
                                                          : CircleAvatar(
                                                              radius: 200.0,
                                                              backgroundImage: NetworkImage(AppString
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
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          assignTeamMember[
                                                                      index]
                                                                  .name ??
                                                              "-",
                                                          overflow:
                                                              TextOverflow.clip,
                                                          style: Utils
                                                              .regularTextStyle(
                                                                  color: AppColor
                                                                      .black),
                                                        ),
                                                        SizedBox(
                                                          height: 1.w,
                                                        ),
                                                        Text(
                                                          assignTeamMember[
                                                                      index]
                                                                  .mobile ??
                                                              "-",
                                                          overflow:
                                                              TextOverflow.clip,
                                                          style: Utils
                                                              .regularTextStyle(
                                                                  color: AppColor
                                                                      .gray),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                                InkWell(
                                                  onTap: () {
                                                    showMyDialog(context,
                                                        "are you sure, remove this members?",
                                                        () {
                                                      setState(() {
                                                        assignTeamMember
                                                            .removeAt(index);
                                                        Navigator.pop(context);
                                                      });
                                                    });
                                                  },
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                        color: AppColor.red,
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    5))),
                                                    child: Padding(
                                                      padding:
                                                          EdgeInsets.all(2.w),
                                                      child: Text(
                                                        "Remove",
                                                        style: Utils
                                                            .regularTextStyle(
                                                                color: AppColor
                                                                    .white),
                                                      ),
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                          );
                                        }),
                                  )
                                ],
                              ),
                            )
                          : Container(),
                    ],
                  ),
                  _isLoading
                      ? Container(
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
            ))
          ],
        ),
      ),
    );
  }

  Widget widgetImageList(String name) {
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
                fontSize: AppDimens.large_font, color: AppColor.dotColor),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 3.w, top: 5.w),
          child: Row(
            children: [
              InkWell(
                onTap: () {
                  Utils.pickImageDialog(context, () {
                    getFilePicker();
                  }, () {
                    openCamera(ImageSource.camera);
                  });
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
                      itemCount: imageList.length,
                      itemBuilder: (context, index) {
                        final path = imageList[index].path.split(".").last;
                        print("extenstion $path");
                        return Padding(
                          padding: EdgeInsets.only(right: 2.w),
                          child: path != "pdf"
                              ? Container(
                                  height: 10.w,
                                  width: 10.w,
                                  decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(5)),
                                      image: DecorationImage(
                                          image: FileImage(imageList[index]),
                                          fit: BoxFit.cover)),
                                )
                              : Icon(
                                  Icons.picture_as_pdf_outlined,
                                  size: 10.w,
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

  sendMobile(StateSetter state) {
    showModalBottomSheet(
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5.0),
      ),
      context: context,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: StatefulBuilder(
            builder: (context, setState) {
              return Container(
                color: AppColor.white,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
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
                                bottom:
                                    MediaQuery.of(context).viewInsets.bottom),
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
                                setState(() {
                                  state(() {
                                    code = "+91";
                                    numberController.clear();
                                    print("value re----");
                                    teamList.add(
                                        CustomTeamList(teamDataList: value));
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
            },
          ),
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

  /// Team Member ///

  getTeamList() async {
    await ApiServices.getTeamMemberList(widget.projectID!).then((value) {
      setState(() {
        allTeamMember = value.data!
            .map((contact) => CustomTeamList(teamDataList: contact))
            .toList();
      });
    });
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

  teamMemberBottomSheet() {
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
                        "Team Member",
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
                                if (teamList[index].isChecked == false) {
                                  state(() {
                                    // currentIndexTeam = index;
                                    teamList[index].isChecked = true;
                                  });
                                } else {
                                  state(() {
                                    teamList[index].isChecked = false;
                                  });
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
                                          // for (int i = 0;
                                          //     i < teamList.length;
                                          //     i++) {
                                          if (teamList[index].isChecked ==
                                              false) {
                                            state(() {
                                              // currentIndexTeam = index;
                                              teamList[index].isChecked = true;
                                            });
                                          } else {
                                            state(() {
                                              teamList[index].isChecked = false;
                                            });
                                          }
                                          // }
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
                        // if (currentIndexTeam == null) {
                        //   Toasts.showToast("please select member");
                        // } else {
                        setState(() {
                          for (int i = 0; i < teamList.length; i++) {
                            if (teamList[i].isChecked == true) {
                              assignTeamMember
                                  .add(teamList[i].teamDataList.teamDetails!);
                              teamList[i].isChecked = false;
                            }
                          }
                          // currentIndexTeam = null;
                          Navigator.pop(context);
                        });
                        // }
                      },
                      strColor: AppColor.white),
                )
              ],
            ),
          );
        });
      },
    );
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

  TextEditingController numberController = TextEditingController();
  String? code = "+91";
  String? code1 = "91";
}
