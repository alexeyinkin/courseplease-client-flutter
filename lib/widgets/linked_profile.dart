import 'package:courseplease/models/contact/editable_contact.dart';
import 'package:courseplease/screens/edit_integration/edit_integration.dart';
import 'package:courseplease/services/net/api_client.dart';
import 'package:courseplease/widgets/auth/auth_provider_icon.dart';
import 'package:flutter/material.dart';

class LinkedProfileWidget extends StatefulWidget {
  final MeResponseData meResponseData;
  final EditableContact contact;

  LinkedProfileWidget({
    @required this.meResponseData,
    @required this.contact,
  });

  @override
  State<LinkedProfileWidget> createState() => _LinkedProfileWidgetState();

  static bool shouldShow(EditableContact contact) {
    switch (contact.className) {
      case 'facebook':
      case 'instagram':
      case 'vk':
        return true;
    }

    return false;
  }
}

class _LinkedProfileWidgetState extends State<LinkedProfileWidget> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: AuthProviderIcon(name: widget.contact.className),
      title: Text(widget.contact.getTitle()),
      trailing: Icon(Icons.chevron_right),
      onTap: _handleTap,
    );
  }

  void _handleTap() {
    Navigator.of(context).pushNamed(
      EditIntegrationScreen.routeName,
      arguments: EditIntegrationScreenArguments(
        meResponseData: widget.meResponseData,
        contact:        EditableContact.from(widget.contact),
      ),
    );
  }
}
