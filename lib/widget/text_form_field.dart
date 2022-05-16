import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../utils/app_color.dart';
import '../utils/app_dimens.dart';
import '../utils/unil.dart';

class CommandTextFormField extends StatelessWidget {
  String? title;
  String? hint;
  TextEditingController? controller;
  FocusNode? focusNode;
  TextInputType? textInputType;
  ValueChanged<String>? onChange;
  TextInputAction? textInputAction;
  bool readOnly;

  CommandTextFormField(
      {Key? key,
      this.title,
      this.hint,
      this.focusNode,
      this.controller,
      this.textInputType,
      this.onChange,
      this.readOnly = false,
      this.textInputAction})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(3.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title!,
            style: Utils.regularTextStyle(
                color: AppColor.textColor, fontSize: AppDimens.medium_font),
          ),
          SizedBox(
            height: 2.w,
          ),
          TextFormField(
            controller: controller,
            readOnly: readOnly,
            focusNode: focusNode,
            keyboardType: textInputType,
            textInputAction: textInputAction,
            onChanged: onChange,
            style: Utils.regularTextStyle(
                color: AppColor.textColor, fontSize: AppDimens.medium_font),
            decoration: InputDecoration(
                hintText: hint,
                hintStyle: Utils.regularTextStyle(
                    color: AppColor.hintText, fontSize: AppDimens.medium_font),
                fillColor: AppColor.textFormFieldBg,
                filled: true,
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: AppColor.textFormFieldBg),
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: AppColor.textFormFieldBg),
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                disabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: AppColor.red),
                    borderRadius: BorderRadius.all(Radius.circular(10)))),
          )
        ],
      ),
    );
  }
}
