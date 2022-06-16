import 'package:flutter_contacts/contact.dart';

class CustomContact {
  final Contact contact;
  bool isChecked;

  CustomContact({
    required this.contact,
    this.isChecked = false,
  });
}
