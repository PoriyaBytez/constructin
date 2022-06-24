import 'package:constructin/utils/shared_preferences/preferences_key.dart';
import 'package:constructin/utils/shared_preferences/preferences_manager.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import 'app_color.dart';
import 'app_dimens.dart';
import 'app_fonts.dart';

class Utils {
  static TextStyle regularTextStyle(
          {fontSize = AppDimens.default_font,
          color = AppColor.black,
          height = 1.0}) =>
      TextStyle(
          fontSize: fontSize,
          color: color,
          height: height,
          fontFamily: AppFonts.gilroy,
          fontWeight: FontWeight.w400,
          wordSpacing: 2.0);

  static TextStyle mediumTextStyle(
          {fontSize = AppDimens.default_font,
          color = AppColor.black,
          height = 1.0}) =>
      TextStyle(
        fontSize: fontSize,
        color: color,
        fontFamily: AppFonts.gilroy,
        height: height,
        fontWeight: FontWeight.w500,
      );

  static boldTextStyle(
          {fontSize = AppDimens.default_font,
          color = AppColor.black,
          height = 1.0,
          fontWeight = FontWeight.w700}) =>
      TextStyle(
        fontSize: fontSize,
        color: color,
        fontFamily: AppFonts.gilroy,
        height: height,
        fontWeight: fontWeight,
      );

  static semiBoldTextStyle(
          {fontSize = AppDimens.default_font,
          color = AppColor.black,
          height = 1.0,
          fontWeight = FontWeight.w500}) =>
      TextStyle(
        fontSize: fontSize,
        color: color,
        fontFamily: AppFonts.gilroy,
        height: height,
        fontWeight: fontWeight,
      );

  static getFCMToken() async {
    late FirebaseMessaging firebaseMessaging;
    firebaseMessaging = FirebaseMessaging.instance;
    await firebaseMessaging.getToken().then((value) {
      print("FCM Token :${value.toString()}");
      PreferencesManager.setString(
          PreferencesKey.fcmToken, value.toString().trim());
    });
  }

  static pickImageDialog(BuildContext context, GestureTapCallback? onTapGallery,
      GestureTapCallback? onTapCamera) {
    return showDialog(
        context: context,
        builder: (_) {
          return Dialog(
            child: Container(
              height: 40.w,
              width: 70.w,
              decoration: BoxDecoration(
                color: AppColor.white,
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              child: Column(
                children: [
                  SizedBox(
                    height: 2.w,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Select Image",
                      style: Utils.semiBoldTextStyle(
                          color: AppColor.mainColor,
                          fontSize: AppDimens.large_font,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                  SizedBox(
                    height: 2.w,
                  ),
                  Divider(),
                  SizedBox(
                    height: 2.w,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      GestureDetector(
                        onTap: onTapGallery,
                        child: Column(
                          children: [
                            Icon(Icons.photo,
                                size: 10.w, color: AppColor.black),
                            SizedBox(
                              height: 1.w,
                            ),
                            Text(
                              "Gallery",
                              style: Utils.mediumTextStyle(
                                  color: AppColor.textColor,
                                  fontSize: AppDimens.medium_font),
                            ),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: onTapCamera,
                        child: Column(
                          children: [
                            Icon(Icons.camera,
                                size: 10.w, color: AppColor.black),
                            SizedBox(
                              height: 1.w,
                            ),
                            Text(
                              "Camera",
                              style: Utils.mediumTextStyle(
                                  color: AppColor.textColor,
                                  fontSize: AppDimens.medium_font),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          );
        });
  }

  static openFullScreenDialog(BuildContext context, String image) {
    return showDialog(
        context: context,
        builder: (_) {
          return Dialog(
            child: Container(
              height: 90.w,
              width: 90.h,
              child: Image.network(image,fit: BoxFit.cover,),
            ),
          );
        });
  }

  static List<String> list = ['All', 'Not started', 'In progress', 'Slow', 'Delayed'];

  static  int daysElapsedSince(DateTime from, DateTime to) {
    from = DateTime(from.year, from.month, from.day);
    to = DateTime(to.year, to.month, to.day);
    return to.difference(from).inDays;
  }
}
