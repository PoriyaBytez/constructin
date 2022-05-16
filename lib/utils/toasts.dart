import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'app_color.dart';
import 'app_dimens.dart';

class Toasts {
  static void showToast(String? message,
      {Color textCol = AppColor.white,
      Color bgColor = AppColor.gray,
      ToastGravity gravity = ToastGravity.SNACKBAR,
      fontSize = AppDimens.medium_font,
      Toast toastLength = Toast.LENGTH_SHORT,
      int time = 1}) {
    if (message == null) return;
    Fluttertoast.showToast(
        msg: message,
        toastLength: toastLength,
        gravity: gravity,
        timeInSecForIosWeb: time,
        backgroundColor: bgColor,
        textColor: textCol,
        fontSize: fontSize);
  }
}
