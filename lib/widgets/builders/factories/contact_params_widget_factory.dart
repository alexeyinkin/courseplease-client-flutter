import 'package:courseplease/models/contact/contact.dart';
import 'package:courseplease/models/contact/contact_class_enum.dart';
import 'package:courseplease/models/contact/editable_contact.dart';
import 'package:courseplease/models/contact/instagram.dart';
import 'package:courseplease/screens/edit_integration/bloc.dart';
import 'package:courseplease/services/net/api_client.dart';
import 'package:flutter/material.dart';

// TODO: Do not import somebody else's local widgets.
import '../../../screens/edit_integration/local_widgets/instagram.dart';

typedef ContactParamsWidgetFactoryMethod = Widget Function(EditIntegrationBloc, MeResponseData, ContactParams);

class ContactParamsWidgetFactory {
  final _builders = <String, ContactParamsWidgetFactoryMethod>{
    ContactClassEnum.instagram: (eib, m, p) => InstagramContactParamsWidget(editIntegrationBloc: eib, meResponseData: m, params: p as InstagramContactParams),
  };

  bool canEdit(Contact contact) {
    return _builders.containsKey(contact.className);
  }

  Widget createWidget({
    required EditIntegrationBloc editIntegrationBloc,
    required MeResponseData meResponseData,
    required EditableContact contact,
  }) {
    final builder = _builders[contact.className];
    if (builder != null) return builder(editIntegrationBloc, meResponseData, contact.params);
    return Container();
  }
}
