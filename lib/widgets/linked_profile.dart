import 'package:courseplease/blocs/contact_status.dart';
import 'package:courseplease/models/contact/editable_contact.dart';
import 'package:courseplease/screens/edit_integration/edit_integration.dart';
import 'package:courseplease/services/net/api_client.dart';
import 'package:courseplease/widgets/auth/auth_provider_icon.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class LinkedProfileWidget extends StatefulWidget {
  final MeResponseData meResponseData;
  final EditableContact contact;

  LinkedProfileWidget({
    @required this.meResponseData,
    @required this.contact,
  });

  @override
  State<LinkedProfileWidget> createState() {
    final contactStatusCubit = GetIt.instance.get<ContactStatusCubitFactory>().create(contact);

    return _LinkedProfileWidgetState(
      contactStatusCubit: contactStatusCubit,
    );
  }

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
  final ContactStatusCubit contactStatusCubit; // Nullable

  _LinkedProfileWidgetState({
    @required this.contactStatusCubit,
  });

  @override
  Widget build(BuildContext context) {
    if (contactStatusCubit != null) {
      contactStatusCubit.setContact(widget.contact);
    }

    return ListTile(
      leading: AuthProviderIcon(name: widget.contact.className),
      title: Text(widget.contact.getTitle()),
      subtitle: _getSubtitle(),
      trailing: Icon(Icons.chevron_right),
      onTap: _handleTap,
    );
  }

  Widget _getSubtitle() { // Nullable
    if (contactStatusCubit == null) return null;

    return StreamBuilder(
      stream: contactStatusCubit.outStatus,
      initialData: contactStatusCubit.initialStatus,
      builder: (context, snapshot) => _buildSubtitleWithStatus(snapshot.data),
    );
  }

  Widget _buildSubtitleWithStatus(ContactStatus status) {
    return Text(status.description);
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
