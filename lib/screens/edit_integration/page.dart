import 'package:app_state/app_state.dart';
import 'package:courseplease/models/contact/editable_contact.dart';
import 'package:courseplease/router/app_configuration.dart';
import 'package:courseplease/screens/edit_integration/bloc.dart';
import 'package:courseplease/screens/edit_integration/screen.dart';
import 'package:flutter/foundation.dart';

class EditIntegrationPage extends BlocMaterialPage<AppConfiguration, EditIntegrationBloc> {
  EditIntegrationPage({
    required EditableContact contactClone,
  }) : super(
    key: ValueKey('EditIntegrationPage_${contactClone.id}'),
    bloc: EditIntegrationBloc(contactClone: contactClone),
    createScreen: (b) => EditIntegrationScreen(bloc: b),
  );
}
