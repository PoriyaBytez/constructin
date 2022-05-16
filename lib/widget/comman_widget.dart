import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../utils/unil.dart';

Widget commandButton(
    {required String name,
    required Color bg,
    required VoidCallback onPress,
    required Color strColor}) {
  return InkWell(
    onTap: onPress,
    child: Container(
      height: 12.w,
      width: double.infinity,
      decoration: BoxDecoration(
        color: bg,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 10.0,
          ),
        ],
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Center(
        child: Text(
          name,
          style: Utils.regularTextStyle(color: strColor, fontSize: 5.w,),
        ),
      ),
    ),
  );
}


