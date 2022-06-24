import 'package:carousel_slider/carousel_slider.dart';
import 'package:constructin/helper/route_helper.dart';
import 'package:constructin/utils/app_color.dart';
import 'package:constructin/utils/app_dimens.dart';
import 'package:constructin/utils/unil.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../../utils/app_fonts.dart';
import '../../utils/app_string.dart';
import '../../widget/comman_widget.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  late CarouselSlider carouselSlider;

  @override
  void initState() {
    // TODO: implement initState
    Utils.getFCMToken();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              AppString.appName1,
              style: TextStyle(
                  fontSize: AppDimens.extra_large_font,
                  color: AppColor.mainColor,
                  fontFamily: AppFonts.gilroy,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 3.2),
            ),
            Text(
              AppString.readyToExperience,
              textAlign: TextAlign.start,
              style: Utils.regularTextStyle(
                  color: AppColor.textColor, fontSize: 18.00),
            ),
            SizedBox(
              height: 10.w,
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: commandButton(
                  name: AppString.signIn,
                  strColor: AppColor.white,
                  bg: AppColor.mainColor,
                  onPress: () {
                    Get.offAndToNamed(RouteHelper.mobileNumberScreen);
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
