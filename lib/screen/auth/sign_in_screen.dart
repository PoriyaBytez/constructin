import 'package:carousel_slider/carousel_slider.dart';
import 'package:constructin/utils/app_asset.dart';
import 'package:constructin/utils/app_color.dart';
import 'package:constructin/utils/app_dimens.dart';
import 'package:constructin/utils/unil.dart';
import 'package:flutter/material.dart';
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
  int _current = 0;

  List imgList = [
    ImageAsset.sign_in_image,
    ImageAsset.sign_in_image,
    ImageAsset.sign_in_image,
    ImageAsset.sign_in_image,
    ImageAsset.sign_in_image
  ];

  // final List<String> imgList = [
  //   'https://images.unsplash.com/photo-1520342868574-5fa3804e551c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=6ff92caffcdd63681a35134a6770ed3b&auto=format&fit=crop&w=1951&q=80',
  //   'https://images.unsplash.com/photo-1522205408450-add114ad53fe?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=368f45b0888aeb0b7b08e3a1084d3ede&auto=format&fit=crop&w=1950&q=80',
  //   'https://images.unsplash.com/photo-1519125323398-675f0ddb6308?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=94a1e718d89ca60a6337a6008341ca50&auto=format&fit=crop&w=1950&q=80',
  //   'https://images.unsplash.com/photo-1523205771623-e0faa4d2813d?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=89719a0d55dd05e2deae4120227e6efc&auto=format&fit=crop&w=1953&q=80',
  //   'https://images.unsplash.com/photo-1508704019882-f9cf40e475b4?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=8c6e5e3aba713b17aa1fe71ab4f0ae5b&auto=format&fit=crop&w=1352&q=80',
  // ];
  List stringList = [
    AppString.unifiedSiteExperience,
    AppString.sitePlanProgress,
    AppString.manpowerMaterial,
    AppString.accounts,
    AppString.collaborateProductivity,
  ];

  List<T> map<T>(List list, Function handler) {
    List<T> result = [];
    for (var i = 0; i < list.length; i++) {
      result.add(handler(i, list[i]));
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Spacer(),
            Text(
              AppString.appName,
              style: TextStyle(
                  fontSize: AppDimens.extra_large_font,
                  color: AppColor.mainColor,
                  fontFamily: AppFonts.gilroy,
                  fontWeight: FontWeight.w400,
                  letterSpacing: 5.2),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                carouselSlider = CarouselSlider(
                  items: imgList.map((imgUrl) {
                    return Builder(
                      builder: (BuildContext context) {
                        return Padding(
                          padding: const EdgeInsets.all(0.0),
                          child: Container(
                              width: MediaQuery.of(context).size.width,
                              margin: EdgeInsets.symmetric(horizontal: 10.0),
                              child: Image.asset(imgUrl)),
                        );
                      },
                    );
                  }).toList(),
                  options: CarouselOptions(
                      initialPage: 0,
                      autoPlay: true,
                      viewportFraction: 1.0,
                      reverse: false,
                      enableInfiniteScroll: true,
                      autoPlayInterval: Duration(seconds: 5),
                      autoPlayAnimationDuration: Duration(milliseconds: 2000),
                      scrollDirection: Axis.horizontal,
                      onPageChanged: (index, reason) {
                        setState(() {
                          _current = index;
                        });
                      }),
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: map<Widget>(imgList, (index, url) {
                    return Container(
                      width: 10.0,
                      height: 10.0,
                      margin:
                          EdgeInsets.symmetric(vertical: 15.0, horizontal: 5.0),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColor.black, width: 1.0),
                        color: _current == index
                            ? AppColor.mainColor
                            : AppColor.white,
                      ),
                    );
                  }),
                ),
                carouselSlider = CarouselSlider(
                  items: stringList.map((str) {
                    return Builder(
                      builder: (BuildContext context) {
                        return Container(
                          width: MediaQuery.of(context).size.width,
                          margin: EdgeInsets.symmetric(horizontal: 10.0),
                          child: Center(
                            child: Text(
                              str,
                              style: Utils.regularTextStyle(
                                  color: AppColor.mainColor, fontSize: 6.w),
                            ),
                          ),
                        );
                      },
                    );
                  }).toList(),
                  options: CarouselOptions(
                      height: 10.w,
                      initialPage: 0,
                      autoPlay: true,
                      reverse: false,
                      enlargeCenterPage: true,
                      viewportFraction: 1.0,
                      enableInfiniteScroll: true,
                      autoPlayInterval: Duration(seconds: 5),
                      autoPlayAnimationDuration: Duration(milliseconds: 2000),
                      scrollDirection: Axis.horizontal,
                      onPageChanged: (index, reason) {
                        setState(() {
                          _current = index;
                        });
                      }),
                ),
              ],
            ),
            Spacer(),
            Spacer(),
            Spacer(),
            Spacer(),
            Text(
              AppString.readyToExperience,
              textAlign: TextAlign.center,
              style: Utils.regularTextStyle(
                  color: AppColor.black, fontSize: 18.00),
            ),
            Padding(
              padding: EdgeInsets.all(15.0),
              child: commandButton(
                  name: AppString.signIn,
                  strColor: AppColor.mainColor,
                  bg: AppColor.white,
                  onPress: () {
                    
                  }),
            ),
            Spacer(),
          ],
        ),
      ),
    );
  }
}
