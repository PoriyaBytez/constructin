import 'package:constructin/model/team_model.dart';
import 'package:constructin/screen/team/team_mamber_list_screen.dart';
import 'package:constructin/utils/api_services.dart';
import 'package:constructin/utils/app_color.dart';
import 'package:constructin/utils/toasts.dart';
import 'package:constructin/widget/comman_widget.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:sizer/sizer.dart';

import '../../model/contact_model.dart';
import '../../utils/app_dimens.dart';
import '../../utils/util.dart';
import 'add_team_member_screen.dart';

class ContactScreen extends StatefulWidget {
  final int projectID;
  final int flag;

  const ContactScreen({Key? key, required this.projectID, required this.flag})
      : super(key: key);

  @override
  State<ContactScreen> createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {
  List<Contact>? contacts;
  List<Contact> list = [];
  late Contact contact;

  TextEditingController numberController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  String? code = "+91";
  String? code1 = "91";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // getContact();
  }

  void getContact() async {
    if (await FlutterContacts.requestPermission()) {
      contacts = await FlutterContacts.getContacts(
          withProperties: true, withPhoto: true);
      _populateContacts(contacts!);
      print(contacts);
      setState(() {});
    }
  }

  List<Contact> _contacts = [];
  List<CustomContact> _uiCustomContacts = [];
  List<CustomContact> _allContacts = [];
  bool _isLoading = false;

  void _populateContacts(Iterable<Contact> contacts) {
    _contacts = contacts.where((item) => item.displayName != null).toList();
    _contacts.sort((a, b) => a.displayName.compareTo(b.displayName));
    _allContacts =
        _contacts.map((contact) => CustomContact(contact: contact)).toList();
    setState(() {
      _uiCustomContacts = _allContacts;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColor.white,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                appBar("Contact", () {
                  if (widget.flag == 1) {
                    Get.back();
                  } else {
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (_) {
                      return AddTeamMemberScreen(
                        projectId: widget.projectID,
                      );
                    }));
                  }
                }),
                // Align(
                //     alignment: Alignment.topRight,
                //     child: InkWell(
                //       onTap: () {
                //         _onSubmit();
                //       },
                //       child: Padding(
                //         padding: EdgeInsets.all(3.w),
                //         child: Icon(
                //           Icons.done,
                //           size: 40,
                //         ),
                //       ),
                //     ))
              ],
            ),
            Padding(
              padding: EdgeInsets.all(3.w),
              child: Text(
                "Add New Contact",
                style: Utils.mediumTextStyle(color: AppColor.textColor3),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(3.w),
              child: TextFormField(
                controller: nameController,
                keyboardType: TextInputType.text,
                onChanged: (value) {
                  setState(() {});
                },
                style: Utils.regularTextStyle(
                    color: AppColor.textColor, fontSize: AppDimens.medium_font),
                decoration: InputDecoration(
                    hintText: "Enter Name",
                    hintStyle: Utils.regularTextStyle(color: AppColor.gray),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: AppColor.gray, width: 1),
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: AppColor.mainColor),
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    disabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: AppColor.red),
                        borderRadius: BorderRadius.all(Radius.circular(10)))),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(3.w),
              child: Row(
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
                        onChanged: (value) {
                          setState(() {});
                        },
                        decoration: InputDecoration(
                          hintText: "Enter Mobile Number",
                          hintStyle:
                              Utils.regularTextStyle(color: AppColor.gray),
                          border: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: AppColor.textFormFieldBg),
                            borderRadius: BorderRadius.only(
                              bottomRight: Radius.circular(10),
                              topRight: Radius.circular(10),
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: AppColor.mainColor),
                            borderRadius: BorderRadius.only(
                              bottomRight: Radius.circular(10),
                              topRight: Radius.circular(10),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(3.w),
              child: commandButton(
                  name: "Continue",
                  bg: AppColor.mainColor,
                  onPress: () {
                    if (numberController.text.isNotEmpty) {
                      print("projectId ${widget.projectID}");
                      ApiServices.postAddMember(nameController.text, code1!,
                              numberController.text, widget.projectID)
                          .then((value) {
                        if (value != false) {
                          setState(() {
                            TeamData data = TeamData(
                              teamDetails: value.teamDetails,
                              rights: value.rights,
                              registerUserId: value.registerUserId,
                              projectId: value.projectId,
                              projectRights: value.projectRights,
                              joined: value.joined,
                            );
                            if (widget.flag == 1) {
                              Navigator.pop(context, value);
                            } else {
                              Navigator.pushReplacement(context,
                                  MaterialPageRoute(builder: (_) {
                                return TeamMemberListScreen(
                                  teamData: data,
                                  projectID: widget.projectID,
                                );
                              }));
                            }
                          });
                        }
                      });
                    } else {
                      Toasts.showToast("Please select number.");
                    }
                  },
                  strColor: AppColor.white),
            ),
            /*Padding(
              padding: EdgeInsets.all(3.w),
              child: Text(
                "Contact List",
                style: Utils.mediumTextStyle(color: AppColor.textColor3),
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(3.w),
                child: (contacts) == null
                    ? Center(child: CircularProgressIndicator())
                    : ListView.separated(
                        itemCount: contacts!.length,
                        separatorBuilder: (context, index) {
                          return Container(
                            height: 0.5,
                            width: double.infinity,
                            color: AppColor.gray2,
                          );
                        },
                        itemBuilder: (BuildContext context, int index) {
                          CustomContact _contact = _uiCustomContacts[index];
                          return InkWell(
                              onTap: () {
                                setState(() {
                                  numberController.text = _contact
                                      .contact.phones[0].number
                                      .replaceFirst(code!, "")
                                      .replaceAll(" ", "");
                                  nameController.text =
                                      _contact.contact.displayName;
                                });
                              },
                              child: _buildListTile(_contact));
                        },
                      ),
              ),
            ),*/
          ],
        ),
      ),
    );
  }

  // ListTile _buildListTile(CustomContact c) {
  //   Uint8List? image = c.contact.photo;
  //   return ListTile(
  //     leading: (c.contact.photo != null)
  //         ? CircleAvatar(backgroundImage: MemoryImage(image!))
  //         : CircleAvatar(
  //             child: Text(
  //                 (c.contact.displayName[0] +
  //                     c.contact.displayName[1].toUpperCase()),
  //                 style: TextStyle(color: Colors.white)),
  //           ),
  //     title: Text(c.contact.displayName),
  //     subtitle: c.contact.phones.isNotEmpty
  //         ? Text(c.contact.phones[0].number)
  //         : Text(''),
  //     // trailing: Checkbox(
  //     //     activeColor: AppColor.mainColor,
  //     //     value: c.isChecked,
  //     //     onChanged: (bool? value) {
  //     //       setState(() {
  //     //         c.isChecked = value!;
  //     //       });
  //     //     }),
  //   );
  // }

  void _onSubmit() {
    _uiCustomContacts =
        _allContacts.where((contact) => contact.isChecked == true).toList();
    Navigator.pop(context, _uiCustomContacts);
  }
}
