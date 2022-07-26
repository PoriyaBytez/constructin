import 'dart:convert';
import 'dart:io';

import 'package:constructin/model/user_model.dart';
import 'package:constructin/utils/api_services.dart';
import 'package:constructin/utils/app_color.dart';
import 'package:constructin/utils/app_dimens.dart';
import 'package:constructin/utils/app_string.dart';
import 'package:constructin/utils/shared_preferences/preferences_key.dart';
import 'package:constructin/utils/util.dart';
import 'package:constructin/widget/comman_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sizer/sizer.dart';

import '../utils/app_asset.dart';
import '../utils/shared_preferences/preferences_manager.dart';
import '../widget/text_form_field.dart';
import 'auth/sign_in_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController companyNameController = TextEditingController();
  TextEditingController roleController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  FocusNode nameNode = FocusNode();
  FocusNode companyNameNode = FocusNode();
  FocusNode roleNode = FocusNode();
  List<String> roleList = [];
  String? roleListValue;
  int selectRole = 0;
  File? imageFile;
  String imageUrl = '';

  bool selectRoles = false;

  @override
  void initState() {
    ApiServices.getCompanyRoleList().then((value) {
      for (int i = 0; i < value.data!.length; i++) {
        setState(() {
          roleList.add(value.data![i].role ?? "");
        });
      }
      intiValue();
    });
    super.initState();
  }

  intiValue() {
    String body = PreferencesManager.getString(PreferencesKey.userModel);
    print("body ${body.toString()}");
    setState(() {
      UserModel userModel = UserModel.fromJson(jsonDecode(body));
      nameController.text = userModel.data?.name ?? "";
      companyNameController.text = userModel.data?.companyName ?? "";
      roleListValue = roleList[userModel.data?.currentRoleId ?? 0];
      imageUrl = userModel.data?.image ?? "";
    });
  }

  getFromGallery(ImageSource source) async {
    XFile? pickedFile = (await ImagePicker().pickImage(
        source: source, maxWidth: 1000, maxHeight: 1000, imageQuality: 10));
    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile.path);
        print('size 72256 : ${imageFile?.lengthSync()}');
        print("imageFile : $imageFile");
        Navigator.pop(context);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: WillPopScope(
        onWillPop: () async {
          return false;
        },
        child: Scaffold(
          backgroundColor: AppColor.white,
          body: Form(
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
                          color: AppColor.bg,
                          blurRadius: 10.0,
                          offset: Offset(0.0, 0.75))
                    ],
                  ),
                  child: Padding(
                    padding: EdgeInsets.only(left: 5.w, top: 3.w, bottom: 3.w),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            InkWell(
                              onTap: () {
                                Navigator.pop(context, imageUrl);
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
                              width: 5.w,
                            ),
                            Text(
                              "My Profile",
                              style: Utils.mediumTextStyle(
                                  color: AppColor.textColor,
                                  fontSize: AppDimens.large_font),
                            ),
                          ],
                        ),
                        InkWell(
                          onTap: () {
                            showMyDialog(context,"are you sure, logout this application?",(){
                              PreferencesManager.clear();
                              PreferencesManager.remove(PreferencesKey.userModel);
                              PreferencesManager.remove(PreferencesKey.fcmToken);
                              PreferencesManager.remove(PreferencesKey.projectList);
                              PreferencesManager.remove(PreferencesKey.isContact);
                              Navigator.pushAndRemoveUntil(context,
                                  MaterialPageRoute(builder: (_) {
                                    return SignInScreen();
                                  }), (route) => false);
                            });
                          },
                          child: Padding(
                            padding: EdgeInsets.only(right: 3.w),
                            child: SizedBox(
                              height: 5.w,
                              width: 7.w,
                              child: Icon(
                                Icons.power_settings_new,
                                color: AppColor.red,
                                size: 8.w,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      SizedBox(
                        height: 10.w,
                      ),
                      Center(
                        child: Container(
                          height: 30.w,
                          width: 30.w,
                          child: Stack(
                            children: [
                              Center(
                                child: Container(
                                  height: 30.w,
                                  width: 30.w,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                          color: AppColor.black, width: 1)),
                                  child: imageFile == null
                                      ? imageUrl == ""
                                          ? Icon(
                                              Icons.person,
                                              size: 13.w,
                                            )
                                          : CircleAvatar(
                                              radius: 200.0,
                                              backgroundImage: NetworkImage(
                                                  AppString.basePath +
                                                      imageUrl),
                                            )
                                      : CircleAvatar(
                                          backgroundImage:
                                              FileImage(imageFile!),
                                          radius: 200.0,
                                        ),
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  Utils.pickImageDialog(context, () {
                                    getFromGallery(ImageSource.gallery);
                                  }, () {
                                    getFromGallery(ImageSource.camera);
                                  });
                                },
                                child: Align(
                                    alignment: Alignment.bottomRight,
                                    child: Padding(
                                      padding: EdgeInsets.only(bottom: 1.w),
                                      child: Container(
                                        height: 10.w,
                                        width: 10.w,
                                        decoration: BoxDecoration(
                                            color: AppColor.white,
                                            border: Border.all(
                                                color: AppColor.black,
                                                width: 1),
                                            shape: BoxShape.circle),
                                        child: Icon(
                                          Icons.camera_alt_outlined,
                                          color: AppColor.black,
                                        ),
                                      ),
                                    )),
                              ),
                            ],
                          ),
                        ),
                      ),
                      CommandTextFormField(
                        controller: nameController,
                        hint: "Enter your name",
                        focusNode: nameNode,
                        textInputAction: TextInputAction.next,
                        textInputType: TextInputType.text,
                        validator: (value) {
                          if (value == "") {
                            return "Please enter your name";
                          }
                          return null;
                        },
                        onChange: (value) {},
                      ),
                      CommandTextFormField(
                        controller: companyNameController,
                        hint: "Enter company name",
                        focusNode: companyNameNode,
                        textInputAction: TextInputAction.next,
                        textInputType: TextInputType.text,
                        onChange: (value) {},
                        validator: (value) {
                          if (value == "") {
                            return "Please enter company name";
                          }
                          return null;
                        },
                      ),
                      Padding(
                        padding: EdgeInsets.all(3.w),
                        child: Container(
                          height: 15.w,
                          decoration: BoxDecoration(
                              color: AppColor.textFormFieldBg,
                              border: Border.all(
                                  color: AppColor.textFormFieldBg, width: 1),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          child: Center(
                            child: DropdownButton<String>(
                              isExpanded: true,
                              underline: Container(
                                color: AppColor.textFormFieldBg,
                                height: 1,
                                width: double.infinity,
                              ),
                              // value: valueTarget,
                              hint: Text(
                                'Company Role',
                                style: Utils.regularTextStyle(
                                    color: AppColor.hintText, fontSize: 4.w),
                              ),
                              value: roleListValue,
                              iconEnabledColor: AppColor.textFormFieldBg,
                              dropdownColor: AppColor.textFormFieldBg,
                              icon: const Icon(
                                Icons.arrow_drop_down,
                                size: 30,
                                color: AppColor.textColor,
                              ),
                              elevation: 0,
                              style: Utils.regularTextStyle(
                                  color: AppColor.textColor,
                                  fontSize: AppDimens.medium_font),
                              onChanged: (String? newValue) {
                                setState(() {
                                  roleListValue = newValue!;
                                  selectRole = 1 + roleList.indexOf(newValue);
                                });
                              },
                              items: roleList.map<DropdownMenuItem<String>>(
                                  (String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Padding(
                                    padding: EdgeInsets.only(left: 3.w),
                                    child: Text(value),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                      ),
                      selectRoles
                          ? Padding(
                              padding: EdgeInsets.only(left: 5.w),
                              child: Text(
                                "Please select role",
                                style: TextStyle(
                                    color: AppColor.red1, fontSize: 12.0),
                              ),
                            )
                          : Container(),
                      SizedBox(
                        height: 30.w,
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 20.w, right: 20.w),
                        child: commandButton(
                            strColor: AppColor.white,
                            name: 'Save',
                            onPress: () {
                              if (roleListValue == '') {
                                setState(() {
                                  selectRoles = true;
                                });
                              } else {
                                setState(() {
                                  selectRoles = false;
                                });
                              }
                              if (_formKey.currentState!.validate()) {
                                ApiServices.editProfile(
                                        imageFile ?? "",
                                        nameController.text,
                                        companyNameController.text,
                                        selectRole)
                                    .then((value) {
                                  print("value $value");
                                  PreferencesManager.setString(
                                      PreferencesKey.userModel,
                                      jsonEncode(value));
                                  Navigator.pop(context, value.data?.image);
                                });
                              }
                            },
                            bg: AppColor.mainColor),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
