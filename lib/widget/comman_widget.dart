import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../utils/app_asset.dart';
import '../utils/app_color.dart';
import '../utils/app_dimens.dart';
import '../utils/unil.dart';

Widget commandButton({required String name,
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
          style: Utils.regularTextStyle(
            color: strColor,
            fontSize: 5.w,
          ),
        ),
      ),
    ),
  );
}

Widget commandTextWithIcon({required String text, required String icon}) {
  return Row(
    children: [
      SizedBox(height: 5.w, width: 5.w, child: Image.asset(icon)),
      SizedBox(
        width: 2.w,
      ),
      Text(
        text,
        style: Utils.regularTextStyle(
            color: AppColor.textColor2, fontSize: AppDimens.default_font),
      ),
    ],
  );
}

Widget appBar(String title, GestureTapCallback? onTap) {
  return Container(
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
        children: [
          InkWell(
            onTap: onTap,
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
            title,
            style: Utils.mediumTextStyle(
                color: AppColor.textColor,
                fontSize: AppDimens.large_font),
          ),
        ],
      ),
    ),
  );
}

Widget planHorizontalList(int selectIndex1,int index,GestureTapCallback? onTap,) {
  return InkWell(
    onTap: onTap,
    child: Padding(
      padding: EdgeInsets.only(left: 2.w, right: 2.w, top: 6.w),
      child: Container(
        decoration: BoxDecoration(
            color: selectIndex1 == index
                ? AppColor.cBg
                : AppColor.white,
            borderRadius:
            BorderRadius.all(Radius.circular(10.0)),
            border: Border.all(
                color: selectIndex1 == index
                    ? AppColor.textColor2
                    : AppColor.textColor4,
                width: 2)),
        child: Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                Utils.list[index],
                style: Utils.mediumTextStyle(
                    color: selectIndex1 == index
                        ? AppColor.textColor2
                        : AppColor.textColor4),
              ),
            )),
      ),
    ),
  );
}


