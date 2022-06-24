import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../utils/app_asset.dart';
import '../../utils/app_color.dart';
import '../../utils/unil.dart';

class IssuesScreen extends StatefulWidget {
  const IssuesScreen({Key? key}) : super(key: key);

  @override
  State<IssuesScreen> createState() => _IssuesScreenState();
}

class _IssuesScreenState extends State<IssuesScreen> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        shrinkWrap: true,
        padding: EdgeInsets.all(3.w),
        itemCount: 5,
        itemBuilder: (context, index) {
          return Container(
            height: 50.w,
            width: 80.w,
            child: Card(
              child: Padding(
                padding: EdgeInsets.all(4.w),
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment:
                      MainAxisAlignment
                          .spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                  color:
                                  AppColor.green1,
                                  borderRadius:
                                  BorderRadius
                                      .circular(
                                      5)),
                              child: Padding(
                                padding:
                                const EdgeInsets
                                    .all(8.0),
                                child: Text(
                                  "Material",
                                  style: Utils
                                      .regularTextStyle(
                                      color: AppColor
                                          .green),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 5.w,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                  color: AppColor
                                      .btnUpdateBg,
                                  borderRadius:
                                  BorderRadius
                                      .circular(
                                      5)),
                              child: Padding(
                                padding:
                                const EdgeInsets
                                    .all(8.0),
                                child: Text(
                                  "Excavation",
                                  style: Utils
                                      .regularTextStyle(
                                      color: AppColor
                                          .textColor2),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                            height: 8.w,
                            width: 8.w,
                            child: Image.asset(
                                ImageAsset
                                    .icons_more)),
                      ],
                    ),
                    SizedBox(
                      height: 3.w,
                    ),
                    Text(
                      "Material shortage at site due to price hike and other reasons",
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: Utils.regularTextStyle(
                          color: AppColor.green),
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
                              image: DecorationImage(
                                  image: AssetImage(
                                      ImageAsset
                                          .ellipse))),
                        ),
                        SizedBox(
                          width: 2.w,
                        ),
                        Text(
                          "John Doe",
                          style:
                          Utils.regularTextStyle(
                              color: AppColor
                                  .textColor8,
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
                                      ImageAsset
                                          .iconSchedule))),
                        ),
                        SizedBox(
                          width: 2.w,
                        ),
                        Text(
                          "10:00 AM, 24th May 2022",
                          style:
                          Utils.regularTextStyle(
                              color: AppColor
                                  .textColor8,
                              fontSize: 2.4.w),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 3.w,
                    ),
                    Row(
                      mainAxisAlignment:
                      MainAxisAlignment
                          .spaceBetween,
                      children: [
                        Container(
                          height: 5.w,
                          width: 5.w,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage(
                                      ImageAsset
                                          .iconChat))),
                        ),
                        Container(
                          decoration: BoxDecoration(
                              borderRadius:
                              BorderRadius.all(
                                  Radius.circular(
                                      5)),
                              border: Border.all(
                                  color:
                                  AppColor.red1,
                                  width: 2)),
                          child: Padding(
                            padding:
                            const EdgeInsets.all(
                                8.0),
                            child: Text(
                              "Close issue",
                              style: Utils
                                  .regularTextStyle(
                                  color: AppColor
                                      .red1),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
