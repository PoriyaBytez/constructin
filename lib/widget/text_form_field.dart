import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../utils/app_color.dart';
import '../utils/app_dimens.dart';
import '../utils/util.dart';

class CommandTextFormField extends StatelessWidget {
  String? title;
  String? hint;
  TextEditingController? controller;
  FocusNode? focusNode;
  TextInputType? textInputType;
  ValueChanged<String>? onChange;
  TextInputAction? textInputAction;
  bool readOnly;
  dynamic maxLines;
  Color? focusColor;
  FormFieldValidator<String>? validator;
  GestureTapCallback? onTab;

  CommandTextFormField(
      {Key? key,
      this.title,
      this.hint,
      this.focusNode,
      this.controller,
      this.textInputType,
      this.onChange,
      this.readOnly = false,
      this.validator,
      this.onTab,
      this.maxLines = 1,
      this.focusColor,
      this.textInputAction})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(3.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            onTap: onTab,
            controller: controller,
            readOnly: readOnly,
            focusNode: focusNode,
            keyboardType: textInputType,
            textInputAction: textInputAction,
            maxLines: maxLines,
            textCapitalization: TextCapitalization.sentences,
            onChanged: onChange,
            validator: validator,
            style: Utils.regularTextStyle(
                color: AppColor.textColor, fontSize: AppDimens.medium_font),
            decoration: InputDecoration(
                labelText: hint,
                labelStyle: Utils.regularTextStyle(
                    color: AppColor.hintText, fontSize: AppDimens.medium_font),
                fillColor: AppColor.textFormFieldBg,
                filled: true,
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: AppColor.textFormFieldBg),
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: AppColor.mainColor),
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
