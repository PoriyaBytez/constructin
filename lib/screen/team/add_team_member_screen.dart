import 'dart:typed_data';

import 'package:constructin/screen/team/contacts_screen.dart';
import 'package:constructin/utils/app_color.dart';
import 'package:constructin/utils/app_dimens.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:sizer/sizer.dart';

import '../../bloc/team_member/team_member_bloc.dart';
import '../../model/contact_model.dart';
import '../../model/team_model.dart';
import '../../utils/api_services.dart';
import '../../utils/app_asset.dart';
import '../../utils/unil.dart';
import '../../widget/comman_widget.dart';
import '../../widget/search_text_form_field.dart';

class AddTeamMemberScreen extends StatefulWidget {
  int projectId;

  AddTeamMemberScreen({required this.projectId});

  @override
  State<AddTeamMemberScreen> createState() => _AddTeamMemberScreenState();
}

class _AddTeamMemberScreenState extends State<AddTeamMemberScreen> {
  TextEditingController searchController = TextEditingController();

  List<TeamData>? teamDataList = [];
  late TeamMemberBloc teamMemberBloc;
  bool isLoading = false;
  int? projectID;
  List<Contact>? contacts;
  List<Contact> list = [];
  late Contact contact;

  List<Contact> _contacts = [];
  List<CustomContact> _uiCustomContacts = [];
  List<CustomContact> searchContactsList = [];
  List<CustomContact> _allContacts = [];
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  bool _isLoading = false;
  int? currentIndex;
  int? currentIndexSearch;
  CustomContact? contactModel;

  @override
  void initState() {
    projectID = widget.projectId;
    print("projectID am page: ${projectID}");
    teamMemberBloc = BlocProvider.of<TeamMemberBloc>(context);
    teamMemberBloc.add(TeamMemberPressed(1, projectID!));
    getContact();
    super.initState();
  }

  void getContact() async {
    if (await FlutterContacts.requestPermission()) {
      contacts = await FlutterContacts.getContacts(
          withProperties: true, withPhoto: true);
      _populateContacts(contacts!);
      print(contacts);
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
      child: BlocListener<TeamMemberBloc, TeamMemberState>(
        listener: (context, state) {
          if (state is TeamMemberLoading) {
            setState(() {
              isLoading = true;
            });
          } else if (state is TeamMemberSuccess) {
            setState(() {
              isLoading = false;
              teamDataList = state.teamModel?.data!;
            });
          }
        },
        child: Scaffold(
          backgroundColor: AppColor.white,
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 15.w,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColor.white,
                  boxShadow: const <BoxShadow>[
                    BoxShadow(
                        color: AppColor.bg,
                        blurRadius: 10.0,
                        offset: Offset(0.0, 0.75))
                  ],
                ),
                child: Padding(
                  padding: EdgeInsets.only(left: 5.w, top: 3.w, bottom: 3.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          InkWell(
                            onTap: () {
                              Get.back();
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(0.0),
                              child: SizedBox(
                                  height: 5.w,
                                  width: 7.w,
                                  child: Image.asset(ImageAsset.arrow_back)),
                            ),
                          ),
                          SizedBox(
                            width: 5.w,
                          ),
                          Text(
                            "Add Team",
                            style: Utils.mediumTextStyle(
                                color: AppColor.textColor,
                                fontSize: AppDimens.large_font),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                                right: 6.w, top: 1.w, bottom: 1.w),
                            child: Image.asset(ImageAsset.iconFilter),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                right: 5.w, top: 1.w, bottom: 1.w),
                            child: Image.asset(ImageAsset.iconsSearch),
                          ),
                          SizedBox(
                            width: 10.w,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SearchTextFormField(labelText: "Search Party",
                  onChanged: (value) {
                    onSearchTextChanged(value);
                  },
                  searchController
                      :searchController),
              Center(
                child: Text(
                  "OR",
                  style: Utils.regularTextStyle(color: AppColor.black),
                ),
              ),
              SizedBox(
                height: 2.w,
              ),
              Container(
                height: 15.w,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColor.white,
                  boxShadow: const <BoxShadow>[
                    BoxShadow(
                        color: AppColor.bg,
                        blurRadius: 10.0,
                        offset: Offset(0.0, 0.75))
                  ],
                ),
                child: Padding(
                  padding: EdgeInsets.only(left: 10.w, right: 10.w),
                  child: InkWell(
                    onTap: () {
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (c) {
                        return ContactScreen(
                          projectID: projectID!,
                          flag: 0,
                        );
                      }));
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "+ Add new Contact",
                          style:
                              Utils.regularTextStyle(color: AppColor.hintText),
                        ),
                        Text(
                          ">",
                          style: Utils.regularTextStyle(
                              color: AppColor.black,
                              fontSize: AppDimens.large_font),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 2.w,
              ),
              Padding(
                padding: EdgeInsets.all(3.w),
                child: Text(
                  "Contact directory",
                  style: Utils.mediumTextStyle(color: AppColor.textColor3),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(3.w),
                  child: (contacts) == null
                      ? Center(child: CircularProgressIndicator())
                      : searchContactsList.isNotEmpty ||
                              searchController.text.isNotEmpty
                          ? ListView.separated(
                              itemCount: searchContactsList.length,
                              separatorBuilder: (context, index) {
                                return Container(
                                  height: 0.5,
                                  width: double.infinity,
                                  color: AppColor.gray2,
                                );
                              },
                              itemBuilder: (context, index) {
                                return InkWell(
                                    onTap: () {
                                      for (int i = 0;
                                          i < searchContactsList.length;
                                          i++) {
                                        if (index == i) {
                                          setState(() {
                                            currentIndexSearch = index;
                                            searchContactsList[index]
                                                .isChecked = true;
                                          });
                                        } else {
                                          setState(() {
                                            searchContactsList[i].isChecked =
                                                false;
                                          });
                                        }
                                      }
                                    },
                                    child: _buildListTile(
                                        searchContactsList, index));
                              })
                          : ListView.separated(
                              itemCount: _uiCustomContacts.length,
                              separatorBuilder: (context, index) {
                                return Container(
                                  height: 0.5,
                                  width: double.infinity,
                                  color: AppColor.gray2,
                                );
                              },
                              itemBuilder: (BuildContext context, int index) {
                                return InkWell(
                                  onTap: () {
                                    setState(() {
                                      // numberController.text = _contact
                                      //     .contact.phones[0].number
                                      //     .replaceFirst(code!, "")
                                      //     .replaceAll(" ", "");
                                      // nameController.text =
                                      //     _contact.contact.displayName;

                                      for (int i = 0;
                                          i < _uiCustomContacts.length;
                                          i++) {
                                        if (index == i) {
                                          setState(() {
                                            currentIndex = index;
                                            _uiCustomContacts[index].isChecked =
                                                true;
                                          });
                                        } else {
                                          setState(() {
                                            _uiCustomContacts[i].isChecked =
                                                false;
                                          });
                                        }
                                      }
                                    });
                                  },
                                  // child: _buildListTile(_contact)
                                  child:
                                      _buildListTile(_uiCustomContacts, index),
                                );
                              },
                            ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(3.w),
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: commandButton(
                      name: "Add Member",
                      bg: AppColor.mainColor,
                      onPress: () {
                        searchController.text.isNotEmpty
                            ? ApiServices.postAddMember(
                                    searchContactsList[currentIndexSearch!]
                                        .contact
                                        .displayName,
                                    "91",
                                    searchContactsList[currentIndexSearch!]
                                        .contact
                                        .phones[0]
                                        .number
                                        .replaceAll(" ", ""),
                                    projectID)
                                .then((value) {
                                setState(() {
                                  if (value == false) {
                                  } else {
                                    TeamData data = TeamData(
                                      teamDetails: value.teamDetails,
                                      rights: value.rights,
                                      registerUserId: value.registerUserId,
                                      projectId: value.projectId,
                                      projectRights: value.projectRights,
                                      joined: value.joined,
                                    );
                                    Navigator.pop(context, data);
                                  }
                                });
                              })
                            : ApiServices.postAddMember(
                                    _uiCustomContacts[currentIndex!]
                                        .contact
                                        .displayName,
                                    "91",
                                    _uiCustomContacts[currentIndex!]
                                        .contact
                                        .phones[0]
                                        .number
                                        .replaceFirst("+91", ""),
                                    projectID)
                                .then((value) {
                                setState(() {
                                  if (value != false) {
                                    TeamData data = TeamData(
                                      teamDetails: value.teamDetails,
                                      rights: value.rights,
                                      registerUserId: value.registerUserId,
                                      projectId: value.projectId,
                                      projectRights: value.projectRights,
                                      joined: value.joined,
                                    );
                                    Navigator.pop(context, data);
                                  }
                                });
                              });
                      },
                      strColor: AppColor.white),
                ),
              )

              /*  Padding(
                padding: EdgeInsets.all(4.w),
                child: Text(
                  "Company Parties",
                  style: Utils.regularTextStyle(
                      color: AppColor.black, fontSize: AppDimens.medium_font),
                ),
              ),
              Expanded(
                  child: isLoading
                      ? Center(
                          child: CircularProgressIndicator(
                            color: AppColor.mainColor,
                          ),
                        )
                      : teamDataList!.isEmpty
                          ? Center(
                              child: Padding(
                              padding: EdgeInsets.all(20.w),
                              child: Text("No Data Found."),
                            ))
                          : ListView.builder(
                              shrinkWrap: true,
                              itemCount: teamDataList!.length,
                              itemBuilder: (context, index) {
                                return InkWell(
                                  onTap: () {
                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (_) {
                                      return ManageRole(
                                        projectId: projectID,
                                        teamData: teamDataList![index],
                                      );
                                    }));
                                  },
                                  child: Padding(
                                    padding: EdgeInsets.all(2.w),
                                    child: Row(
                                      children: [
                                        Container(
                                          height: 8.w,
                                          width: 8.w,
                                          decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: AppColor.gray),
                                        ),
                                        SizedBox(width: 2.w),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              teamDataList![index]
                                                      .teamDetails
                                                      ?.name ??
                                                  "-",
                                              style: Utils.regularTextStyle(
                                                  color: AppColor.black,
                                                  fontSize:
                                                      AppDimens.medium_font),
                                            ),
                                            Text(
                                              teamDataList![index]
                                                      .teamDetails
                                                      ?.mobile ??
                                                  "",
                                              style: Utils.regularTextStyle(
                                                  color: AppColor.black,
                                                  fontSize:
                                                      AppDimens.medium_font),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              })),*/
            ],
          ),
        ),
      ),
    );
  }

  ListTile _buildListTile(List<CustomContact> c, int index) {
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
          }),
    );
  }

  onSearchTextChanged(String text) async {
    searchContactsList.clear();
    if (text.isEmpty) {
      setState(() {});
      return;
    }

    _uiCustomContacts.forEach((userDetail) {
      if (userDetail.contact.displayName.toUpperCase().contains(text) ||
          userDetail.contact.displayName.toLowerCase().contains(text))
        searchContactsList.add(userDetail);
    });

    setState(() {});
  }
}
