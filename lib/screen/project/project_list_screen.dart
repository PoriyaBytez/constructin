import 'dart:convert';

import 'package:constructin/bloc/project_list/project_list_bloc.dart';
import 'package:constructin/helper/route_helper.dart';
import 'package:constructin/model/project_model.dart';
import 'package:constructin/screen/dashboard/dashboard_screen.dart';
import 'package:constructin/screen/profile_screen.dart';
import 'package:constructin/utils/toasts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../../model/user_model.dart';
import '../../utils/app_asset.dart';
import '../../utils/app_color.dart';
import '../../utils/app_dimens.dart';
import '../../utils/app_string.dart';
import '../../utils/shared_preferences/preferences_key.dart';
import '../../utils/shared_preferences/preferences_manager.dart';
import '../../utils/util.dart';
import '../../widget/comman_widget.dart';
import '../team/team_mamber_list_screen.dart';

class ProjectListScreen extends StatefulWidget {
  const ProjectListScreen({Key? key}) : super(key: key);

  @override
  State<ProjectListScreen> createState() => _ProjectListScreenState();
}

enum Menu { itemOne }

class _ProjectListScreenState extends State<ProjectListScreen> {
  ProjectListBloc projectListBloc = ProjectListBloc();

  bool isLoading = false;

  List<ProjectData>? data;
  late UserModel userModel;
  String imageUrl = "";

  @override
  void initState() {
    projectListBloc = BlocProvider.of<ProjectListBloc>(context);
    projectListBloc.add(ProjectListPressed());
    String body = PreferencesManager.getString(PreferencesKey.userModel);
    userModel = UserModel.fromJson(jsonDecode(body));
    AppString.basePath = userModel.data?.basePath ?? "";
    imageUrl = userModel.data?.image ?? "";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: AppColor.white,
      body: BlocListener<ProjectListBloc, ProjectListState>(
        listener: (context, state) {
          if (state is ProjectListLoading) {
            setState(() {
              isLoading = true;
            });
          } else if (state is ProjectListSuccess) {
            setState(() {
              isLoading = false;
              data = state.projectModel!.data;
            });
          }
        },
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
              child: Padding(
                padding: EdgeInsets.only(left: 5.w, top: 3.w, bottom: 3.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (_) {
                          return ProfileScreen();
                        })).then((value) {
                          if (value != "") {
                            setState(() {
                              imageUrl = value;
                            });
                          }
                        });
                      },
                      child: Row(
                        children: [
                          Container(
                            height: 10.w,
                            width: 10.w,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                    color: AppColor.black, width: 1)),
                            child: imageUrl == ""
                                ? Icon(
                                    Icons.person,
                                    size: 8.w,
                                  )
                                : CircleAvatar(
                                    radius: 200.0,
                                    backgroundImage: NetworkImage(
                                        AppString.basePath + imageUrl),
                                  ),
                          ),
                          SizedBox(
                            width: 5.w,
                          ),
                          Text(
                            "My Projects",
                            style: Utils.mediumTextStyle(
                                color: AppColor.textColor,
                                fontSize: AppDimens.large_font),
                          ),
                        ],
                      ),
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
                        Padding(
                          padding: EdgeInsets.only(
                              right: 3.w, top: 1.w, bottom: 1.w),
                          child: Image.asset(ImageAsset.icons_more),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 10.w,
            ),
            Expanded(
              child: isLoading
                  ? Center(
                      child: CircularProgressIndicator(
                        color: AppColor.mainColor,
                      ),
                    )
                  : ListView.builder(
                      itemCount: data?.length,
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        String? startDate, endDate;
                        startDate = Utils.showData(
                            data?[index].projectDetail?.startDate ?? "");
                        endDate = Utils.showData(
                            data?[index].projectDetail?.endDate ?? "");
                        return InkWell(
                          onTap: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (_) {
                              return DashBoardScreen(
                                projectData: data![index],
                              );
                            })).then((value) {
                              setState(() {
                                data?[index].issues_count = value;
                              });
                            });
                          },
                          child: SizedBox(
                            height: 70.w,
                            width: double.infinity,
                            child: PageView.builder(
                              key: UniqueKey(),
                              itemCount: 2,
                              itemBuilder: (context, pageIndex) {
                                return Column(
                                  children: [
                                    Container(
                                      padding: EdgeInsets.all(15.0),
                                      decoration: BoxDecoration(
                                        color: AppColor.cBg,
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.only(left: 2.w),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  data?[index]
                                                          .projectDetail
                                                          ?.projectName ??
                                                      "",
                                                  overflow: TextOverflow.clip,
                                                  style: Utils.regularTextStyle(
                                                      color:
                                                          AppColor.textColor2,
                                                      fontSize:
                                                          AppDimens.large_font),
                                                ),
                                                SizedBox(
                                                  height: 1.w,
                                                ),
                                                Text(
                                                  "${startDate ?? ""} to ${endDate ?? ""}",
                                                  overflow: TextOverflow.clip,
                                                  style: Utils.regularTextStyle(
                                                      color:
                                                          AppColor.textColor2,
                                                      fontSize: AppDimens
                                                          .default_font),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Row(
                                            children: [
                                              Container(
                                                height: 8.w,
                                                width: 20.w,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(5.0)),
                                                  color: AppColor.btnUpdateBg,
                                                ),
                                                child: Center(
                                                  child: Text(
                                                    "Update",
                                                    style:
                                                        Utils.regularTextStyle(
                                                            color: AppColor
                                                                .textColor2,
                                                            fontSize: AppDimens
                                                                .default_font),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                width: 5.w,
                                              ),
                                              PopupMenuButton(
                                                  child: Icon(
                                                    Icons.more_vert,
                                                    color: AppColor.textColor2,
                                                    size: 30,
                                                  ),
                                                  onSelected: (Menu item) {
                                                    setState(() {
                                                      String listB = data?[index]
                                                          .projectRights;
                                                      var b = (listB.split(','));
                                                      print("list ${b.length}");
                                                      print("list ${b.toString()}");

                                                      if (b.contains("6")) {
                                                        Navigator.push(context,
                                                            MaterialPageRoute(
                                                                builder: (_) {
                                                          return TeamMemberListScreen(
                                                            projectID:
                                                                data![index]
                                                                    .projectId,
                                                          );
                                                        })).then((value) {
                                                          data?[index]
                                                                  .members_count =
                                                              value;
                                                          setState(() {});
                                                        });
                                                      } else {
                                                        Toasts.showToast(
                                                            "You do not have access");
                                                      }
                                                    });
                                                  },
                                                  itemBuilder: (BuildContext
                                                          context) =>
                                                      <PopupMenuEntry<Menu>>[
                                                        const PopupMenuItem<
                                                            Menu>(
                                                          value: Menu.itemOne,
                                                          child: Text(
                                                              'Team Manage'),
                                                        ),
                                                      ]),
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                    Container(
                                      height: 50.w,
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
                                        padding: EdgeInsets.only(
                                            bottom: 3.w,
                                            right: 5.w,
                                            left: 5.w,
                                            top: 2.w),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            pageIndex == 0
                                                ? Container()
                                                : Text(
                                                    "Updates in Last 7 days -",
                                                    style:
                                                        Utils.regularTextStyle(
                                                            color: AppColor.red,
                                                            fontSize: AppDimens
                                                                .default_font),
                                                  ),
                                            SingleChildScrollView(
                                              scrollDirection: Axis.horizontal,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  commandTextWithIcon(
                                                      text: pageIndex == 0
                                                          ? "${double.parse(data?[index].projectProgress ?? "0.0").toStringAsFixed(0)}% progress"
                                                          : "${double.parse(data?[index].projectProgressSevenDays ?? "0.0").toStringAsFixed(0)}% progress",
                                                      icon: ImageAsset
                                                          .iconProgress),
                                                  commandTextWithIcon(
                                                      text: pageIndex == 0
                                                          ? "${data?[index].issues_count ?? "0"} - issues"
                                                          : "${data?[index].issues_count_seven_days ?? "0"} - issues",
                                                      icon:
                                                          ImageAsset.iconIssue),
                                                  commandTextWithIcon(
                                                      text:
                                                          "${data?[index].members_count ?? "0"} - members",
                                                      icon: ImageAsset
                                                          .iconMember),
                                                ],
                                              ),
                                            ),
                                            commandTextWithIcon(
                                                text:
                                                    "- items in stock | - item out of stock",
                                                icon: ImageAsset.iconStock),
                                            commandTextWithIcon(
                                                text: "Rs. - billed",
                                                icon: ImageAsset.iconReceipt),
                                            commandTextWithIcon(
                                                text: "Rs. - In | Rs. - Out",
                                                icon: ImageAsset.iconInOut),
                                            SizedBox(
                                              height: 3.w,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  "Click to review",
                                                  style: Utils.regularTextStyle(
                                                      color:
                                                          AppColor.textColor2,
                                                      fontSize: AppDimens
                                                          .default_font),
                                                ),
                                                Row(
                                                  children: [
                                                    Container(
                                                      height: 1.w,
                                                      width: 1.w,
                                                      decoration: BoxDecoration(
                                                          color: pageIndex == 0
                                                              ? AppColor
                                                                  .dotColor
                                                              : AppColor.gray,
                                                          shape:
                                                              BoxShape.circle),
                                                    ),
                                                    SizedBox(
                                                      width: 2.w,
                                                    ),
                                                    Container(
                                                      height: 1.w,
                                                      width: 1.w,
                                                      decoration: BoxDecoration(
                                                          color: pageIndex == 0
                                                              ? AppColor.gray
                                                              : AppColor
                                                                  .dotColor,
                                                          shape:
                                                              BoxShape.circle),
                                                    ),
                                                  ],
                                                ),
                                                Text(
                                                  "Swipe for Updates",
                                                  style: Utils.regularTextStyle(
                                                      color: pageIndex == 0
                                                          ? AppColor.textColor2
                                                          : AppColor.white,
                                                      fontSize: AppDimens
                                                          .default_font),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),
                        );
                      }),
            )
          ],
        ),
      ),
      floatingActionButton: InkWell(
        onTap: () {
          Get.toNamed(RouteHelper.createProject, arguments: 1);
        },
        child: Container(
          height: 15.w,
          width: 40.w,
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(ImageAsset.iconAdd), fit: BoxFit.cover)),
        ),
      ),
    ));
  }
}
