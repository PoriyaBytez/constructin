import 'dart:async';
import 'dart:convert';
import 'dart:io' show Platform;

import 'package:alt_sms_autofill/alt_sms_autofill.dart';
import 'package:constructin/utils/app_asset.dart';
import 'package:constructin/utils/app_color.dart';
import 'package:constructin/utils/unil.dart';
import 'package:constructin/widget/comman_widget.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../../bloc/login_bloc/login_bloc.dart';
import '../../bloc/login_bloc/login_event.dart';
import '../../bloc/login_bloc/login_state.dart';
import '../../helper/route_helper.dart';
import '../../utils/api_services.dart';
import '../../utils/app_dimens.dart';
import '../../utils/app_fonts.dart';
import '../../utils/app_string.dart';
import '../../utils/shared_preferences/preferences_key.dart';
import '../../utils/shared_preferences/preferences_manager.dart';
import '../../utils/toasts.dart';

class MobileNumberScreen extends StatefulWidget {
  const MobileNumberScreen({Key? key}) : super(key: key);

  @override
  State<MobileNumberScreen> createState() => _MobileNumberScreenState();
}

class _MobileNumberScreenState extends State<MobileNumberScreen> {
  final GlobalKey<FormState> formKey1 = GlobalKey<FormState>();
  final GlobalKey<FormState> formKey2 = GlobalKey<FormState>();
  TextEditingController numberController = TextEditingController();

  bool varification = false;
  String? code = "+91";
  String? code1 = "91";
  int? type = 1;
  String? deviceId;
  String verificationIdReceiver = "";
  LoginBloc loginBloc = LoginBloc();

  /// OTP Widget
  TextEditingController oneController = TextEditingController();
  TextEditingController twoController = TextEditingController();
  TextEditingController threeController = TextEditingController();
  TextEditingController fortController = TextEditingController();
  TextEditingController fiveController = TextEditingController();
  TextEditingController sixController = TextEditingController();

  late FocusNode oneFocusNode = FocusNode();
  late FocusNode twoFocusNode = FocusNode();
  late FocusNode threeFocusNode = FocusNode();
  late FocusNode fortFocusNode = FocusNode();
  late FocusNode fiveFocusNode = FocusNode();
  late FocusNode sixFocusNode = FocusNode();

  int secondsRemaining = 30;
  bool enableResend = false;
  bool isMobile = false;
  late Timer timer;
  bool isLoading = false;

  @override
  void initState() {
    getDevices();
    setState(() {
      deviceId = PreferencesManager.getString(
        PreferencesKey.fcmToken,
      );
    });
    loginBloc = BlocProvider.of<LoginBloc>(context);
    super.initState();
  }

  getDevices() {
    if (Platform.isIOS) {
      type = 2;
    } else {
      type = 1;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColor.white,
        body: BlocListener<LoginBloc, LoginState>(
          listener: (context, state) {
            if (state is LoginLoading) {
            } else if (state is LoginSuccess) {
              PreferencesManager.setString(
                  PreferencesKey.userModel, jsonEncode(state.userModel));
              AppString.basePath = state.userModel?.data?.basePath ?? "";
              ApiServices.getProjectList().then((value) {
                if (value!.data!.isEmpty) {
                  print("home");
                  Get.offAndToNamed(RouteHelper.home);
                } else {
                  print("projectList");
                  Get.offAndToNamed(RouteHelper.projectList);
                }
              });
            }
          },
          child: SingleChildScrollView(
            child: SizedBox(
              height: 96.h,
              width: double.infinity,
              child: varification ? otpScreen() : getOtp(),
            ),
          ),
        ),
      ),
    );
  }

  Widget otpScreen() {
    return Stack(
      children: [
        Form(
          key: formKey2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 3.w,
              ),
              InkWell(
                onTap: () {
                  setState(() {
                    varification = false;
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: SizedBox(
                      height: 5.w,
                      width: 10.w,
                      child: Image.asset(ImageAsset.arrow_back)),
                ),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Spacer(),
                    Text(
                      "${AppString.strOTPsenton} $code ${numberController.text}",
                      style: TextStyle(
                          fontSize: 18.0,
                          color: AppColor.textColor,
                          fontFamily: AppFonts.gilroy,
                          fontWeight: FontWeight.w400,
                          overflow: TextOverflow.clip),
                    ),
                    SizedBox(
                      height: 15.w,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 15.w, right: 15.w),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          otpWidget(
                            controller: oneController,
                            focusNode: oneFocusNode,
                            textInputAction: TextInputAction.next,
                            onChanged: (value) {
                              if (value.length == 1) {
                                setState(() {
                                  FocusScope.of(context).nextFocus();
                                });
                              }
                            },
                          ),
                          otpWidget(
                            controller: twoController,
                            focusNode: twoFocusNode,
                            textInputAction: TextInputAction.next,
                            onChanged: (value) {
                              if (value.length == 1) {
                                setState(() {
                                  FocusScope.of(context).nextFocus();
                                });
                              }
                            },
                          ),
                          otpWidget(
                            controller: threeController,
                            focusNode: threeFocusNode,
                            textInputAction: TextInputAction.next,
                            onChanged: (value) {
                              if (value.length == 1) {
                                setState(() {
                                  FocusScope.of(context)
                                      .requestFocus(fortFocusNode);
                                });
                              }
                            },
                          ),
                          otpWidget(
                            controller: fortController,
                            focusNode: fortFocusNode,
                            textInputAction: TextInputAction.next,
                            onChanged: (value) {
                              if (value.length == 1) {
                                setState(() {
                                  FocusScope.of(context)
                                      .requestFocus(fiveFocusNode);
                                });
                              }
                            },
                          ),
                          otpWidget(
                            controller: fiveController,
                            focusNode: fiveFocusNode,
                            textInputAction: TextInputAction.next,
                            onChanged: (value) {
                              if (value.length == 1) {
                                setState(() {
                                  FocusScope.of(context)
                                      .requestFocus(sixFocusNode);
                                });
                              }
                            },
                          ),
                          otpWidget(
                            controller: sixController,
                            focusNode: sixFocusNode,
                            textInputAction: TextInputAction.done,
                            onChanged: (value) {
                              if (value.length == 1) {
                                setState(() {
                                  sixFocusNode.unfocus();
                                });
                              }
                            },
                            onFieldSubmitted: (term) {
                              sixFocusNode.unfocus();
                            },
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 15.w,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 10.w, right: 10.w),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          enableResend == false
                              ? Text(
                                  '$secondsRemaining secs.',
                                  style: Utils.regularTextStyle(
                                      color: AppColor.textColor,
                                      fontSize: AppDimens.large_font),
                                )
                              : Container(),
                          enableResend
                              ? InkWell(
                                  onTap: () {
                                    _resendCode();
                                  },
                                  child: Text(
                                    'Resend OTP',
                                    style: Utils.regularTextStyle(
                                        color: AppColor.textColor,
                                        fontSize: AppDimens.large_font),
                                  ),
                                )
                              : Container(),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 5.w,
                    ),
                    Spacer(),
                    enableResend
                        ? Container()
                        : Padding(
                            padding: EdgeInsets.only(
                                left: 5.w, right: 5.w, bottom: 15.w),
                            child: commandButton(
                                name: "Verify",
                                bg: AppColor.mainColor,
                                onPress: () {
                                  if (oneController.text.isEmpty) {
                                    Toasts.showToast("Please enter OTP");
                                  }
                                  if (oneController.text.isNotEmpty) {
                                    setState(() {
                                      isLoading = true;
                                    });
                                    verifyOTP();
                                  }
                                },
                                strColor: AppColor.white),
                          ),
                  ],
                ),
              ),
            ],
          ),
        ),
        isLoading
            ? Container(
                height: 100.h,
                width: 100.w,
                color: AppColor.gray4,
                child: Center(
                  child: CircularProgressIndicator(
                    color: AppColor.textColor,
                  ),
                ),
              )
            : Container(),
      ],
    );
  }

  Widget getOtp() {
    return Stack(
      children: [
        Form(
          key: formKey1,
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Spacer(),
                Center(
                  child: Text(
                    AppString.strUnlock,
                    style: TextStyle(
                        fontSize: AppDimens.extra_large_font,
                        color: AppColor.mainColor,
                        fontFamily: AppFonts.gilroy,
                        fontWeight: FontWeight.w400,
                        letterSpacing: 5.2),
                  ),
                ),
                Center(
                  child: RichText(
                    text: TextSpan(
                      children: <TextSpan>[
                        TextSpan(
                            text: 'your ',
                            style: Utils.regularTextStyle(
                                color: AppColor.black,
                                fontSize: AppDimens.large_font)),
                        TextSpan(
                            text: '360° site management',
                            style: Utils.regularTextStyle(
                                color: AppColor.mainColor,
                                fontSize: AppDimens.large_font)),
                        TextSpan(
                            text: ' experience',
                            style: Utils.regularTextStyle(
                                color: AppColor.black,
                                fontSize: AppDimens.large_font)),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 20.w,
                ),
                Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(bottom: 1.8),
                      child: Container(
                        height: 14.5.w,
                        decoration: BoxDecoration(
                          border: Border.all(color: AppColor.gray, width: 1),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            bottomLeft: Radius.circular(10),
                          ),
                        ),
                        child: CountryCodePicker(
                          textStyle: Utils.regularTextStyle(
                              fontSize: AppDimens.large_font),
                          onChanged: (value) {
                            print("contry Code ${value.dialCode}");
                            setState(() {
                              code = value.dialCode;
                              code1 = value.dialCode?.replaceFirst("+", "");
                              print("code $code");
                            });
                          },
                          // Initial selection and favorite can be one of code ('IT') OR dial_code('+39')
                          initialSelection: 'In',
                          favorite: const ['+91', 'In'],
                          // optional. Shows only country name and flag
                          showCountryOnly: true,
                          // optional. Shows only country name and flag when popup is closed.
                          showOnlyCountryWhenClosed: false,
                          // optional. aligns the flag and the Text left
                          alignLeft: false,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: SizedBox(
                        height: 15.w,
                        width: 100,
                        child: TextFormField(
                          style: Utils.regularTextStyle(
                              fontSize: AppDimens.large_font),
                          controller: numberController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            hintText: "Enter Mobile Number",
                            hintStyle:
                                Utils.regularTextStyle(color: AppColor.gray),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.only(
                                bottomRight: Radius.circular(10),
                                topRight: Radius.circular(10),
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                isMobile
                    ? Text(
                        "Please enter mobile number",
                        style: TextStyle(
                          fontSize: AppDimens.default_font,
                          color: AppColor.red,
                          fontFamily: AppFonts.gilroy,
                          fontWeight: FontWeight.w400,
                        ),
                      )
                    : Container(),
                Spacer(),
                Padding(
                  padding: EdgeInsets.only(left: 5.w, right: 5.w, bottom: 15.w),
                  child: commandButton(
                      name: "Get OTP",
                      bg: AppColor.mainColor,
                      onPress: () {
                        if (numberController.text.isEmpty) {
                          setState(() {
                            isMobile = true;
                          });
                        } else {
                          setState(() {
                            isMobile = false;
                          });
                        }
                        if (numberController.text.isNotEmpty) {
                          setState(() {
                            isLoading = true;
                          });

                          verifyPhoneNumber(context);
                        }
                      },
                      strColor: AppColor.white),
                ),
                InkWell(
                  onTap: () {},
                  child: Center(
                    child: RichText(
                      text: TextSpan(
                        children: <TextSpan>[
                          TextSpan(
                              text: 'I accept the ',
                              style: Utils.regularTextStyle(
                                  color: AppColor.black,
                                  fontSize: AppDimens.large_font)),
                          TextSpan(
                              text: 'Terms and Conditions',
                              style: Utils.regularTextStyle(
                                  color: AppColor.mainColor,
                                  fontSize: AppDimens.large_font)),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10.w)
              ],
            ),
          ),
        ),
        isLoading
            ? Container(
                height: 100.h,
                width: 100.w,
                color: AppColor.gray4,
                child: Center(
                  child: CircularProgressIndicator(
                    color: AppColor.textColor,
                  ),
                ),
              )
            : Container()
      ],
    );
  }

  Future<void> verifyPhoneNumber(BuildContext context) async {
    print("no : $code${numberController.text}");

    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: "$code${numberController.text}",
      verificationCompleted: (PhoneAuthCredential credential) async {
        // await FirebaseAuth.instance.signInWithCredential(credential);
      },
      verificationFailed: (FirebaseAuthException e) {
        if (e.code == 'invalid-phone-number') {
          setState(() {
            isLoading = false;
          });
          Toasts.showToast('phone number is not valid.');
          print('The provided phone number is not valid.');
        } else {
          setState(() {
            isLoading = false;
          });
          Toasts.showToast('Re-try after same time.');
        }
      },
      codeSent: (String verificationId, int? resendToken) async {
        // Toasts.showToast(verificationId.toString());
        setState(() {
          varification = true;
          isLoading = false;
          verificationIdReceiver = verificationId;
          startTimer();
        });
        await initSmsListener();
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        print("codeAutoRetrievalTimeout : ${verificationId.toString()}");
        // Toasts.showToast("code Auto Retrieval Timeout");
      },
    );
  }

  Future<void> initSmsListener() async {
    String? comingSms;
    try {
      comingSms = await AltSmsAutofill().listenForSms;
      print("====>Message: ${comingSms?.split(" ")[0]}");
      autofillOTP(comingSms?.split(" ")[0].toString());
    } on PlatformException {
      comingSms = 'Failed to get Sms.';
      print("====>Message: ${comingSms.codeUnits}");
    }
  }

  autofillOTP(String? otp) {
    for (int i = 0; i < otp.toString().length; i++) {
      setState(() {
        oneController.text = otp.toString()[0];
        twoController.text = otp.toString()[1];
        threeController.text = otp.toString()[2];
        fortController.text = otp.toString()[3];
        fiveController.text = otp.toString()[4];
        sixController.text = otp.toString()[5];
      });
    }
  }

  verifyOTP() async {
    String smsCode = "";
    setState(() {
      smsCode =
          "${oneController.text}${twoController.text}${threeController.text}${fortController.text}${fiveController.text}${sixController.text}";
    });
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationIdReceiver, smsCode: smsCode);

    try {
      await FirebaseAuth.instance
          .signInWithCredential(credential)
          .then((value) {
        setState(() {
          isLoading = false;
        });
        loginBloc.add(LoginButtonPressed(
            countryCode: code1,
            mobile: numberController.text,
            type: type,
            deviceId: deviceId));
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      Toasts.showToast("The code has expired. Please re-send code");
    }
  }

  startTimer() {
    timer = Timer.periodic(Duration(seconds: 1), (_) {
      if (secondsRemaining != 0) {
        setState(() {
          secondsRemaining--;
        });
      } else {
        setState(() {
          oneController.text = "";
          twoController.text = "";
          threeController.clear();
          fortController.clear();
          fiveController.clear();
          sixController.clear();
          enableResend = true;
        });
      }
    });
  }

  void _resendCode() {
    setState(() {
      timer.cancel();
      secondsRemaining = 30;
      enableResend = false;
      verifyPhoneNumber(context);
    });
  }

  @override
  dispose() {
    timer.cancel();
    AltSmsAutofill().unregisterListener();
    super.dispose();
  }

  otpWidget(
      {TextEditingController? controller,
      FocusNode? focusNode,
      ValueChanged<String>? onChanged,
      ValueChanged<String>? onFieldSubmitted,
      TextInputAction? textInputAction}) {
    return Container(
      height: 10.w,
      width: 10.w,
      decoration: BoxDecoration(
        color: AppColor.otpBox,
        borderRadius: BorderRadius.all(
          Radius.circular(2.w),
        ),
      ),
      child: TextFormField(
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        controller: controller,
        maxLength: 1,
        cursorColor: AppColor.white,
        focusNode: focusNode,
        onFieldSubmitted: onFieldSubmitted,
        onChanged: onChanged,
        style:
            Utils.regularTextStyle(fontSize: 18.0, color: AppColor.textColor),
        textInputAction: textInputAction,
        decoration: InputDecoration(
          counterText: "",
          contentPadding: EdgeInsets.zero,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(2.w),
            ),
            borderSide: BorderSide(color: AppColor.otpBox, width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(2.w),
            ),
            borderSide: BorderSide(color: AppColor.otpBox, width: 1),
          ),
        ),
      ),
    );
  }
}
