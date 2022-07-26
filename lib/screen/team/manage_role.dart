import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:sizer/sizer.dart';

import '../../model/team_model.dart';
import '../../utils/app_asset.dart';
import '../../utils/app_color.dart';
import '../../utils/app_dimens.dart';
import '../../utils/util.dart';
import '../../widget/comman_widget.dart';

class ManageRole extends StatefulWidget {
  int? projectId;
  TeamData? teamData;

  ManageRole({
    this.projectId,
    this.teamData,
  });

  @override
  State<ManageRole> createState() => _ManageRoleState();
}

class _ManageRoleState extends State<ManageRole> {
  int? joinded;
  List b = [];

  @override
  void initState() {
    joinded = widget.teamData!.joined;
    String projectRight = widget.teamData!.projectRights ?? "";

    if (projectRight.isNotEmpty) {
      b = projectRight.split(',');
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
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
                          "Manage Role",
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
            Padding(
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
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                          color: AppColor.textColor, width: 1)),
                                ),
                                SizedBox(
                                  width: 2.w,
                                ),
                                SizedBox(
                                  width: 30.w,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        widget.teamData!.teamDetails?.name ??
                                            "-",
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: Utils.regularTextStyle(),
                                      ),
                                      SizedBox(
                                        height: 2.w,
                                      ),
                                      Text(
                                        widget.teamData!.teamDetails?.mobile ??
                                            "",
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
                              joinded == 1 ? "joined" : "Not joined",
                              style: Utils.regularTextStyle(
                                  fontSize: AppDimens.indicator_size,
                                  color: AppColor.green),
                            ),
                            InkWell(
                              onTap: () {
                                setState(() {});
                              },
                              child: Row(
                                children: [
                                  Text(
                                    "${b.length} roles",
                                    style: Utils.regularTextStyle(
                                        color: AppColor.textColor2),
                                  ),
                                  Icon(
                                    widget.teamData!.teamDetails?.isShow == true
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
                  Column(
                    children: [
                      ListView.builder(
                          itemCount: widget.teamData!.rights!.length,
                          shrinkWrap: true,
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
                                          value: widget
                                              .teamData!.rights![i].isAllow,
                                          onChanged: (bool? value) {
                                            print("value  bool $value");
                                            setState(() {
                                              widget.teamData!.rights![i]
                                                  .isAllow = value;
                                            });
                                          }),
                                      Text(
                                        "${widget.teamData!.rights![i].title} - ",
                                        style: Utils.mediumTextStyle(
                                            fontSize: AppDimens.indicator_size,
                                            color: AppColor.textColor),
                                      ),
                                      Expanded(
                                        child: Text(
                                          widget.teamData!.rights![i]
                                                  .description ??
                                              "",
                                          style: Utils.regularTextStyle(
                                              fontSize:
                                                  AppDimens.indicator_size,
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
                            widget.teamData!.rights!.asMap().entries.map((e) {
                              if (widget.teamData!.rights![e.key].isAllow ==
                                  true) {
                                projectRights.add(e.key + 1);
                              }
                            }).toList();
                            print(projectRights.join(','));
                            // ApiServices.postRoleAssignee(
                            //     widget.teamData!.registerUserId!,
                            //     widget.teamData!.projectId!,
                            //    projectRights.isEmpty ? null : projectRights.join(',')).then((value) {
                            //       if(value == true){
                            //         Navigator.pop(context);
                            //         Get.offAndToNamed(RouteHelper.teamMemberList,arguments: widget.teamData!.projectId!);
                            //       }
                            // });
                          },
                          strColor: AppColor.textColor3)
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
