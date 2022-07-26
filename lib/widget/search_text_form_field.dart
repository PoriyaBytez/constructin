import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../utils/app_asset.dart';
import '../utils/app_color.dart';
import '../utils/app_dimens.dart';
import '../utils/util.dart';

class SearchTextFormField extends StatefulWidget {
  ValueChanged<String>? onChanged;
  TextEditingController? searchController;
  String? labelText;

  SearchTextFormField({this.onChanged, this.searchController, this.labelText});

  @override
  State<SearchTextFormField> createState() => _SearchTextFormFieldState();
}

class _SearchTextFormFieldState extends State<SearchTextFormField> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(4.w),
      child: TextFormField(
        onChanged: widget.onChanged,
        controller: widget.searchController,
        keyboardType: TextInputType.text,
        style: Utils.regularTextStyle(
            color: AppColor.textColor, fontSize: AppDimens.medium_font),
        decoration: InputDecoration(
            labelText: widget.labelText,
            fillColor: AppColor.textFormFieldBg,
            filled: true,
            suffixIcon: Container(
                height: 2.w,
                width: 2.w,
                child: Padding(
                  padding: EdgeInsets.all(3.w),
                  child: Image.asset(ImageAsset.iconsSearch),
                )),
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: AppColor.textFormFieldBg),
                borderRadius: BorderRadius.all(Radius.circular(10))),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: AppColor.mainColor),
                borderRadius: BorderRadius.all(Radius.circular(10))),
            disabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: AppColor.red),
                borderRadius: BorderRadius.all(Radius.circular(10)))),
      ),
    );
  }
}
