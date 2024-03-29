import 'package:courseplease/blocs/contact_status.dart';
import 'package:courseplease/models/common.dart';
import 'package:courseplease/models/contact/contact_class_enum.dart';
import 'package:courseplease/models/contact/editable_contact.dart';
import 'package:courseplease/router/app_state.dart';
import 'package:courseplease/screens/edit_integration/page.dart';
import 'package:courseplease/services/net/api_client.dart';
import 'package:courseplease/widgets/auth/auth_provider_icon.dart';
import 'package:courseplease/widgets/icon_text_status.dart';
import 'package:courseplease/widgets/builders/factories/contact_params_widget_factory.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class LinkedProfileWidget extends StatefulWidget {
  final MeResponseData meResponseData;
  final EditableContact contact;

  LinkedProfileWidget({
    required this.meResponseData,
    required this.contact,
  }) : super(
    key: ValueKey(contact.getChecksum()),
  );

  @override
  State<LinkedProfileWidget> createState() {
    return _LinkedProfileWidgetState(
      contact: contact,
    );
  }

  static bool shouldShow(EditableContact contact) {
    switch (contact.className) {
      case ContactClassEnum.facebook:
      case ContactClassEnum.google:
      case ContactClassEnum.instagram:
      case ContactClassEnum.vk:
        return true;
    }

    return false;
  }
}

class _LinkedProfileWidgetState extends State<LinkedProfileWidget> {
  final ContactStatusCubit? _contactStatusCubit;
  final _contactParamsWidgetFactory = GetIt.instance.get<ContactParamsWidgetFactory>();

  _LinkedProfileWidgetState({
    required EditableContact contact,
  }) :
      _contactStatusCubit = GetIt.instance.get<ContactStatusCubitFactory>().create(contact)
  ;

  @override
  void dispose() {
    _contactStatusCubit?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_contactStatusCubit == null) {
      return _buildWithStatus(null);
    }

    return StreamBuilder<ReadableProfileSyncStatus>(
      stream: _contactStatusCubit!.outStatus,
      builder: (context, snapshot) => _buildWithStatus(snapshot.data),
    );
  }

  Widget _buildWithStatus(ReadableProfileSyncStatus? status) {
    return ListTile(
      leading: AuthProviderIcon(name: widget.contact.className),
      title: Text(widget.contact.getTitle()),
      subtitle: _getSubtitle(status),
      trailing: _getTrailing(),
      onTap: _handleTap,
    );
  }

  Widget? _getSubtitle(ReadableProfileSyncStatus? status) {
    if (status == null || status.description == '') {
      return null;
    }

    switch (status.status.runStatus) {
      case RunStatus.error:
        return IconTextWidget(
          iconName: StatusIconEnum.error,
          text: status.description,
        );
    }
    return Text(status.description);
  }

  Widget? _getTrailing() {
    if (!_canEdit()) return null;

    return Icon(Icons.chevron_right);
  }

  void _handleTap() {
    if (!_canEdit()) return;

    GetIt.instance.get<AppState>().pushPage(
      EditIntegrationPage(
        contactClone: EditableContact.from(widget.contact),
      ),
    );
  }

  bool _canEdit() {
    return _contactParamsWidgetFactory.canEdit(widget.contact);
  }
}
