import 'package:courseplease/models/contact/editable_contact.dart';
import 'package:courseplease/widgets/pad.dart';
import 'package:flutter/material.dart';
import 'auth/auth_provider_icon.dart';

class ContactTitleWidget extends StatelessWidget {
  final EditableContact contact;

  ContactTitleWidget({
    required this.contact,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        padRight(AuthProviderIcon(name: contact.className)),
        Text(contact.getTitle()),
      ],
    );
  }
}
