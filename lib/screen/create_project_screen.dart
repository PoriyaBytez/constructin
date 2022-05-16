import 'package:constructin/utils/app_string.dart';
import 'package:constructin/widget/text_form_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'dart:async';
import '../utils/app_asset.dart';
import '../utils/app_color.dart';
import '../utils/app_dimens.dart';
import '../utils/unil.dart';
import '../widget/comman_widget.dart';

class CreateProjectScreen extends StatefulWidget {
  const CreateProjectScreen({Key? key,this.restorationId}) : super(key: key);
  final String? restorationId;
  @override
  State<CreateProjectScreen> createState() => _CreateProjectScreenState();
}

class _CreateProjectScreenState extends State<CreateProjectScreen>with RestorationMixin {
  TextEditingController projectNameController = TextEditingController();
  TextEditingController clientNameController = TextEditingController();
  TextEditingController siteController = TextEditingController();
  TextEditingController startDateController = TextEditingController();
  TextEditingController endDateController = TextEditingController();
  TextEditingController saleValueController = TextEditingController();
  TextEditingController budgetController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  FocusNode projectNameNode = FocusNode();
  FocusNode clientNameNode = FocusNode();
  FocusNode siteNode = FocusNode();
  FocusNode startDateNode = FocusNode();
  FocusNode endDateNode = FocusNode();
  FocusNode saleValueNode = FocusNode();
  FocusNode budgetNode = FocusNode();

  bool nextPage = false;

  DateTime selectedDate = DateTime.now();

  @override
  String? get restorationId => widget.restorationId;

  final RestorableDateTime _selectedDate =
  RestorableDateTime(DateTime(2021, 7, 25));
  late final RestorableRouteFuture<DateTime?> restorableDatePickerRouteFuture =
  RestorableRouteFuture<DateTime?>(
    onComplete: _selectDate,
    onPresent: (NavigatorState navigator, Object? arguments) {
      return navigator.restorablePush(
        _datePickerRoute,
        arguments: _selectedDate.value.millisecondsSinceEpoch,
      );
    },
  );

  static Route<DateTime> _datePickerRoute(
      BuildContext context,
      Object? arguments,
      ) {
    return DialogRoute<DateTime>(
      context: context,
      builder: (BuildContext context) {
        return DatePickerDialog(
          restorationId: 'date_picker_dialog',
          initialEntryMode: DatePickerEntryMode.calendarOnly,
          initialDate: DateTime.fromMillisecondsSinceEpoch(arguments! as int),
          firstDate: DateTime(2021),
          lastDate: DateTime(2022),
        );
      },
    );
  }

  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    registerForRestoration(_selectedDate, 'selected_date');
    registerForRestoration(
        restorableDatePickerRouteFuture, 'date_picker_route_future');
  }

  void _selectDate(DateTime? newSelectedDate) {
    if (newSelectedDate != null) {
      setState(() {
        _selectedDate.value = newSelectedDate;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
              'Selected: ${_selectedDate.value.day}/${_selectedDate.value.month}/${_selectedDate.value.year}'),
        ));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColor.white,
        body: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Container(
                  height: 15.w,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppColor.white,
                    boxShadow: const <BoxShadow>[
                      BoxShadow(
                          color: AppColor.gray1,
                          blurRadius: 1.0,
                          offset: Offset(0.0, 0.75))
                    ],
                  ),
                  child: Padding(
                    padding: EdgeInsets.only(left: 5.w, top: 3.w, bottom: 3.w),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: () {
                            setState(() {
                              nextPage = false;
                            });
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(0.0),
                            child: SizedBox(
                                height: 5.w,
                                width: 7.w,
                                child: Image.asset(ImageAsset.arrow_back)),
                          ),
                        ),
                        SizedBox(
                          width: 3.w,
                        ),
                        Text(
                          "Create Project",
                          style: Utils.regularTextStyle(
                              color: AppColor.textColor,
                              fontSize: AppDimens.large_font),
                        ),
                      ],
                    ),
                  ),
                ),
                nextPage
                    ? InkWell(
                     onTap: (){

                     },
                      child: Padding(
                          padding: EdgeInsets.only(right: 5.w, top: 5.w),
                          child: Align(
                            alignment: Alignment.topRight,
                            child: Container(
                              decoration: BoxDecoration(
                                  color: AppColor.textFormFieldBg,
                                  borderRadius: BorderRadius.circular(10)),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "Skip",
                                  style: Utils.regularTextStyle(),
                                ),
                              ),
                            ),
                          ),
                        ),
                    )
                    : Padding(
                        padding: EdgeInsets.only(right: 5.w, top: 5.w),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "",
                            style: Utils.regularTextStyle(),
                          ),
                        ),
                      ),
                Container(
                  height: 40.w,
                  width: 40.w,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: AssetImage(ImageAsset.under_maintenance),
                    ),
                  ),
                ),
                SizedBox(
                  height: 5.w,
                ),
                // nextPage
                //     ?
                Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: InkWell(
                                  onTap: (){
                                    restorableDatePickerRouteFuture.present();
                                  },
                                  child: CommandTextFormField(
                                    title: AppString.strStartDate,
                                    controller: startDateController,
                                    focusNode: startDateNode,
                                    readOnly: true,
                                    hint: AppString.strEnterDate,
                                    textInputAction: TextInputAction.next,
                                    textInputType: TextInputType.text,
                                    onChange: (value) {},
                                  ),
                                ),
                              ),

                              Expanded(
                                child: InkWell(
                                  onTap: (){


                                  },
                                  child: CommandTextFormField(
                                    title: AppString.strEndDate,
                                    controller: endDateController,
                                    focusNode: endDateNode,
                                    readOnly: true,
                                    hint: AppString.strEnterDate,
                                    textInputAction: TextInputAction.next,
                                    textInputType: TextInputType.text,
                                    onChange: (value) {},
                                  ),
                                ),
                              ),
                            ],
                          ),
                          CommandTextFormField(
                            title: AppString.strSaleValue,
                            controller: saleValueController,
                            focusNode: siteNode,
                            hint: AppString.strEnterValue,
                            textInputAction: TextInputAction.next,
                            textInputType: TextInputType.number,
                            onChange: (value) {},
                          ),
                          CommandTextFormField(
                            title: AppString.strBudgetValue,
                            controller: budgetController,
                            focusNode: budgetNode,
                            hint: AppString.strEnterValue,
                            textInputAction: TextInputAction.done,
                            textInputType: TextInputType.number,
                            onChange: (value) {},
                          ),
                          SizedBox(
                            height: 30.w,
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 3.w, right: 3.w),
                            child: commandButton(
                                name: AppString.strCreateProject,
                                strColor: AppColor.white,
                                bg: AppColor.mainColor,
                                onPress: () {}),
                          ),
                        ],
                      )
                    // :
                // Column(
                //         children: [
                //           CommandTextFormField(
                //             title: AppString.strProjectName,
                //             controller: projectNameController,
                //             focusNode: projectNameNode,
                //             hint: AppString.strEnterProjectName,
                //             textInputAction: TextInputAction.next,
                //             textInputType: TextInputType.text,
                //             onChange: (value) {},
                //           ),
                //           CommandTextFormField(
                //             title: AppString.strClientName,
                //             controller: clientNameController,
                //             focusNode: clientNameNode,
                //             hint: AppString.strEnterClientName,
                //             textInputAction: TextInputAction.next,
                //             textInputType: TextInputType.text,
                //             onChange: (value) {},
                //           ),
                //           CommandTextFormField(
                //             title: AppString.strSiteLocation,
                //             controller: siteController,
                //             focusNode: siteNode,
                //             hint: AppString.strEnterLocation,
                //             textInputAction: TextInputAction.next,
                //             textInputType: TextInputType.text,
                //             onChange: (value) {},
                //           ),
                //           SizedBox(
                //             height: 30.w,
                //           ),
                //           Padding(
                //             padding: EdgeInsets.only(left: 3.w, right: 3.w),
                //             child: commandButton(
                //                 name: AppString.strContinue,
                //                 strColor: AppColor.white,
                //                 bg: AppColor.mainColor,
                //                 onPress: () {
                //                   setState(() {
                //                     nextPage = true;
                //                   });
                //                 }),
                //           ),
                //         ],
                //       ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
