import 'package:constructin/utils/api_services.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

import '../../model/issue_model.dart';
import '../../utils/app_asset.dart';
import '../../utils/app_color.dart';
import '../../utils/app_string.dart';
import '../../utils/toasts.dart';
import '../../utils/util.dart';
import '../../widget/comman_widget.dart';
import '../issue_details_screen.dart';
import '../task/task_issue_screen.dart';

enum Menu { itemOne, itemTwo }

Widget widgetIssueList(List<IssueData>? issueList, setState) {
  return issueList!.isEmpty
      ? Center(
          child: Text("Data Not Found"),
        )
      : ListView.builder(
          shrinkWrap: true,
          padding:
              EdgeInsets.only(top: 3.w, right: 3.w, left: 3.w, bottom: 15.w),
          itemCount: issueList.length,
          itemBuilder: (context, index) {
            var outputFormat = DateFormat("hh:mm a, dd MMM, yyyy");
            var outputDate = outputFormat.format(issueList[index].createdAt!);
            return Stack(
              children: [
                SizedBox(
                  height: 48.w,
                  child: Card(
                    child: Padding(
                      padding: EdgeInsets.all(2.w),
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
                                        issueList[index].issueCategory?.title ??
                                            "",
                                        style: Utils.regularTextStyle(
                                            color: AppColor.green),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 5.w,
                                  ),
                                  issueList[index].task != null
                                      ? Container(
                                          decoration: BoxDecoration(
                                              color: AppColor.btnUpdateBg,
                                              borderRadius:
                                                  BorderRadius.circular(5)),
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              issueList[index].task.title,
                                              style: Utils.regularTextStyle(
                                                  color: AppColor.textColor2),
                                            ),
                                          ),
                                        )
                                      : Container(),
                                ],
                              ),
                              PopupMenuButton(
                                  child: Icon(
                                    Icons.more_vert,
                                    color: AppColor.textColor2,
                                    size: 30,
                                  ),
                                  onSelected: (Menu item) {
                                    if (item.index == 0) {
                                      setState(() {
                                        Navigator.push(context,
                                            MaterialPageRoute(builder: (_) {
                                          return TaskIssueScreen(
                                            tag: 0,
                                            edit: 1,
                                            id: issueList[index].id,
                                            issueData: issueList[index],
                                          );
                                        })).then((value) {
                                          if (value != null) {
                                            setState(() {
                                              issueList[index]
                                                      .issueCategory!
                                                      .title =
                                                  value.issueCategory!.title;
                                              issueList[index].title =
                                                  value.title;
                                            });
                                          }
                                        });
                                      });
                                    } else if (item.index == 1) {
                                      showMyDialog(context,
                                          "are you sure, delete this Issue?",
                                          () {
                                        ApiServices.postIssueDelete(
                                            issueList[index].id!);
                                        setState(() {
                                          issueList.removeAt(index);
                                          Navigator.pop(context);
                                        });

                                        // .then((value) => () {
                                        //       if (value == true) {
                                        //
                                        //       }
                                        //     });
                                      });
                                    }
                                  },
                                  itemBuilder: (BuildContext context) =>
                                      <PopupMenuEntry<Menu>>[
                                        const PopupMenuItem<Menu>(
                                          value: Menu.itemOne,
                                          child: Text('Issue edit'),
                                        ),
                                        const PopupMenuItem<Menu>(
                                          value: Menu.itemTwo,
                                          child: Text('Issue delete'),
                                        ),
                                      ]),
                            ],
                          ),
                          SizedBox(
                            height: 3.w,
                          ),
                          Text(
                            issueList[index].title ?? "",
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: Utils.regularTextStyle(
                                color: AppColor.textColor2),
                          ),
                          SizedBox(
                            height: 3.w,
                          ),
                          Row(
                            children: [
                              Container(
                                height: 10.w,
                                width: 10.w,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                        color: AppColor.black, width: 1)),
                                child:
                                    issueList[index].teamDetails?.image == null
                                        ? Icon(
                                            Icons.person,
                                            size: 8.w,
                                          )
                                        : CircleAvatar(
                                            radius: 200.0,
                                            backgroundImage: NetworkImage(
                                                AppString.basePath +
                                                    issueList[index]
                                                        .teamDetails
                                                        ?.image),
                                          ),
                              ),
                              SizedBox(
                                width: 2.w,
                              ),
                              Text(
                                issueList[index].teamDetails!.name ??
                                    issueList[index].teamDetails!.mobile ??
                                    "",
                                style: Utils.regularTextStyle(
                                    color: AppColor.textColor8,
                                    fontSize: 2.4.w),
                              ),
                              SizedBox(
                                width: 2.w,
                              ),
                              Container(
                                height: 8.w,
                                width: 8.w,
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image: AssetImage(
                                            ImageAsset.iconSchedule))),
                              ),
                              SizedBox(
                                width: 2.w,
                              ),
                              Text(
                                outputDate,
                                style: Utils.regularTextStyle(
                                    color: AppColor.textColor8,
                                    fontSize: 2.4.w),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 3.w,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              InkWell(
                                onTap: () {
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (_) {
                                    return IssueDetailsScreen(
                                      data: issueList[index],
                                    );
                                  })).then((value) {
                                    setState(() {
                                      issueList[index].commentCount = value;
                                    });
                                  });
                                },
                                child: Row(
                                  children: [
                                    Container(
                                      height: 5.w,
                                      width: 5.w,
                                      decoration: BoxDecoration(
                                          image: DecorationImage(
                                              image: AssetImage(
                                                  ImageAsset.iconChat))),
                                    ),
                                    SizedBox(
                                      width: 2,
                                    ),
                                    Text(
                                      issueList[index]
                                              .commentCount
                                              ?.toString() ??
                                          "0",
                                      style: Utils.regularTextStyle(),
                                    )
                                  ],
                                ),
                              ),
                              issueList[index].status == 1
                                  ? InkWell(
                                      onTap: () {
                                        closeBottomSheet(context, () {
                                          ApiServices.poseIssueClose(
                                                  issueList[index].id!)
                                              .then((value) {
                                            setState(() {
                                              issueList[index].status = value;
                                            });
                                          });
                                          Navigator.of(context).pop();
                                        });
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(5)),
                                            border: Border.all(
                                                color: AppColor.red1,
                                                width: 2)),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            AppString.strCloseIssue,
                                            style: Utils.regularTextStyle(
                                                color: AppColor.red1),
                                          ),
                                        ),
                                      ),
                                    )
                                  : Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        AppString.strCloseIssue,
                                        style: Utils.regularTextStyle(
                                            color: AppColor.red1),
                                      )),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                issueList[index].status != 1
                    ? Padding(
                        padding: EdgeInsets.all(1.w),
                        child: InkWell(
                          onTap: () {
                            Toasts.showToast("Issue close already");
                          },
                          child: Container(
                            height: 46.w,
                            decoration: BoxDecoration(
                                color: AppColor.white4,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5))),
                          ),
                        ),
                      )
                    : Container()
              ],
            );
          },
        );
}
