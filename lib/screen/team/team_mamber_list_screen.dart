import 'package:animated_size_and_fade/animated_size_and_fade.dart';
import 'package:constructin/screen/team/contacts_screen.dart';
import 'package:constructin/utils/app_color.dart';
import 'package:constructin/utils/app_string.dart';
import 'package:constructin/widget/comman_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

import '../../bloc/team_member_list_bloc/team_member_list_bloc.dart';
import '../../model/team_model.dart';
import '../../utils/api_services.dart';
import '../../utils/app_asset.dart';
import '../../utils/app_dimens.dart';
import '../../utils/util.dart';

class TeamMemberListScreen extends StatefulWidget {
  TeamData? teamData;
  int? projectID;

  TeamMemberListScreen({this.teamData, this.projectID});

  @override
  State<TeamMemberListScreen> createState() => _TeamMemberListScreenState();
}

class _TeamMemberListScreenState extends State<TeamMemberListScreen> {
  List<TeamData>? teamDataList = [];

  late TeamMemberListBloc teamMemberBloc;

  bool isLoading = false;

  @override
  void initState() {
    teamMemberBloc = BlocProvider.of<TeamMemberListBloc>(context);
    teamMemberBloc.add(TeamMemberListPressed(1, widget.projectID!));
  }

  int isShow = 0;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BlocListener<TeamMemberListBloc, TeamMemberListState>(
        listener: (context, state) {
          if (state is TeamMemberListLoading) {
            setState(() {
              isLoading = true;
            });
          } else if (state is TeamMemberListSuccess) {
            setState(() {
              isLoading = false;
              teamDataList = state.teamModel?.data;
            });
          }
        },
        child: Scaffold(
          backgroundColor: AppColor.white,
          body: Column(
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
                              Navigator.pop(context, teamDataList!.length);
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
                            style: Utils.regularTextStyle(
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
              isLoading
                  ? Expanded(
                      child: Center(
                        child: CircularProgressIndicator(
                          color: AppColor.mainColor,
                        ),
                      ),
                    )
                  : teamDataList!.isEmpty
                      ? Expanded(
                          child: Center(
                              child: Padding(
                            padding: EdgeInsets.all(20.w),
                            child: Text("No Data Found."),
                          )),
                        )
                      : Expanded(
                          child: ListView.builder(
                            itemCount: teamDataList!.length,
                            itemBuilder: (context, index) {
                              int? joined = teamDataList![index].joined;
                              String projectRight =
                                  teamDataList![index].projectRights ?? "";
                              List b = [];
                              if (projectRight.isNotEmpty) {
                                b = projectRight.split(',');
                              }
                              return listItem(index, joined!, b.length);
                            },
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
                        addMember();
                      },
                      strColor: AppColor.white),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget listItem(int index, int joined, int roleSize) {
    return Padding(
      padding: EdgeInsets.only(top: 4.w, bottom: 4.w),
      child: Column(
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
            child: InkWell(
              onTap: () {},
              child: Padding(
                padding: EdgeInsets.only(left: 4.w, right: 4.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          height: 10.w,
                          width: 10.w,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle, color: AppColor.gray1),
                          child: teamDataList![index].teamDetails?.image == null
                              ? Icon(
                                  Icons.person,
                                  size: 25,
                                  color: AppColor.gray,
                                )
                              : CircleAvatar(
                                  radius: 200,
                                  backgroundImage: NetworkImage(AppString
                                          .basePath +
                                      teamDataList![index].teamDetails?.image),
                                ),
                        ),
                        SizedBox(
                          width: 2.w,
                        ),
                        SizedBox(
                          width: 25.w,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                teamDataList![index].teamDetails?.name ?? "-",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: Utils.regularTextStyle(),
                              ),
                              SizedBox(
                                height: 2.w,
                              ),
                              Text(
                                teamDataList![index].teamDetails?.mobile ?? "",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: Utils.regularTextStyle(),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Text(
                      joined == 1 ? "joined" : "Not joined",
                      style: Utils.regularTextStyle(
                          fontSize: AppDimens.indicator_size,
                          color: AppColor.green),
                    ),
                    InkWell(
                      onTap: () {
                        for (int i = 0; i < teamDataList!.length; i++) {
                          if (teamDataList![index].teamDetails?.isShow ==
                              true) {
                            teamDataList![i].teamDetails?.isShow = false;
                          } else {
                            if (i == index) {
                              teamDataList![i].teamDetails?.isShow = true;
                            } else {
                              teamDataList![i].teamDetails?.isShow = false;
                            }
                          }
                        }
                        setState(() {});
                      },
                      child: Row(
                        children: [
                          roleSize == 0
                              ? Text(
                                  "Add Role",
                                  style: Utils.regularTextStyle(
                                      color: AppColor.textColor2),
                                )
                              : roleSize == 6
                                  ? Text(
                                      "Admin",
                                      style: Utils.regularTextStyle(
                                          color: AppColor.textColor2),
                                    )
                                  : Text(
                                      "${roleSize} roles",
                                      style: Utils.regularTextStyle(
                                          color: AppColor.textColor2),
                                    ),
                          Icon(
                            teamDataList![index].teamDetails?.isShow == true
                                ? Icons.arrow_drop_up
                                : Icons.arrow_drop_down_sharp,
                            color: AppColor.textColor2,
                            size: 30,
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      Icons.more_vert,
                      color: AppColor.black,
                      size: 30,
                    ),
                  ],
                ),
              ),
            ),
          ),
          AnimatedSizeAndFade.showHide(
            show: teamDataList![index].teamDetails?.isShow ?? false,
            child: Column(
              children: [
                ListView.builder(
                    itemCount: teamDataList![index].rights!.length,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (context, i) {
                      return Padding(
                        padding: EdgeInsets.only(top: 3),
                        child: Container(
                          height: 12.w,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: AppColor.white,
                            boxShadow: const <BoxShadow>[
                              BoxShadow(
                                  color: AppColor.bg,
                                  blurRadius: 1.0,
                                  offset: Offset(0.0, 0.75))
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Checkbox(
                                    activeColor: AppColor.mainColor,
                                    value:
                                        teamDataList![index].rights![i].isAllow,
                                    onChanged: (bool? value) {
                                      print("value  bool $value");
                                      setState(() {
                                        if (teamDataList![index]
                                                .rights![i]
                                                .title ==
                                            "Admin") {
                                          for (int k = 0;
                                              k <
                                                  teamDataList![index]
                                                      .rights!
                                                      .length;
                                              k++) {
                                            teamDataList![index]
                                                .rights![k]
                                                .isAllow = value;
                                          }
                                        } else {
                                          int count = 0;
                                          for (int k = 0;
                                              k <
                                                  teamDataList![index]
                                                      .rights!
                                                      .length;
                                              k++) {
                                            if (teamDataList![index]
                                                    .rights![k]
                                                    .isAllow ==
                                                true) {
                                              count++;
                                            }
                                            if (teamDataList![index]
                                                    .rights![k]
                                                    .title ==
                                                "Admin") {
                                              if (value == false) {
                                                teamDataList![index]
                                                    .rights![k]
                                                    .isAllow = value;
                                              } else if (count ==
                                                  (teamDataList![index]
                                                          .rights!
                                                          .length -
                                                      2)) {
                                                teamDataList![index]
                                                    .rights![k]
                                                    .isAllow = true;
                                              }
                                            }
                                          }
                                          teamDataList![index]
                                              .rights![i]
                                              .isAllow = value;
                                        }
                                      });
                                    }),
                                Text(
                                  "${teamDataList![index].rights![i].title} - ",
                                  style: Utils.mediumTextStyle(
                                      fontSize: AppDimens.indicator_size,
                                      color: AppColor.textColor),
                                ),
                                Expanded(
                                  child: Text(
                                    teamDataList![index]
                                            .rights![i]
                                            .description ??
                                        "",
                                    style: Utils.regularTextStyle(
                                        fontSize: AppDimens.indicator_size,
                                        color: AppColor.textColor),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
                commandButton(
                    name: "Save",
                    bg: AppColor.textFormFieldBg,
                    onPress: () {
                      List<int> projectRights = [];
                      teamDataList![index].rights!.asMap().entries.map((e) {
                        setState(() {
                          teamDataList![index].teamDetails?.isShow = false;
                        });
                        if (teamDataList![index].rights![e.key].isAllow ==
                            true) {
                          projectRights.add(e.key + 1);
                        }
                      }).toList();
                      print(projectRights.join(','));
                      ApiServices.postRoleAssignee(
                              teamDataList![index].registerUserId!,
                              teamDataList![index].projectId!,
                              projectRights.join(','))
                          .then((value) {
                        if (value == true) {
                          teamMemberBloc
                              .add(TeamMemberListPressed(1, widget.projectID!));
                        }
                      });
                    },
                    strColor: AppColor.textColor3)
              ],
            ),
          )
        ],
      ),
    );
  }

  Future addMember() async {
    // if (await FlutterContacts.requestPermission()) {
    //   Navigator.push(context, MaterialPageRoute(builder: (_) {
    //     return AddTeamMemberScreen(projectId: widget.projectID!);
    //   })).then((value) {
    //     if (value != null) {
    //       setState(() {
    //         teamDataList?.add(value);
    //       });
    //     }
    //   });
    // } else {
    Navigator.push(context, MaterialPageRoute(builder: (_) {
      return ContactScreen(
        projectID: widget.projectID!,
        flag: 1,
      );
    })).then((value) {
      if (value != null) {
        setState(() {
          teamDataList?.add(value);
        });
      }
    });
    // }
  }
}
