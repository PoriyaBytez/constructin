import 'package:constructin/utils/shared_preferences/preferences_key.dart';
import 'package:constructin/utils/shared_preferences/preferences_manager.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

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
      print("Tokensss :${value.toString()}");
      PreferencesManager.setString(PreferencesKey.fcmToken, value.toString().trim());
    });
  }
}
