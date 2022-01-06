import 'package:app_state/app_state.dart';
import 'package:courseplease/router/app_configuration.dart';
import 'package:flutter/foundation.dart';

import 'bloc.dart';
import 'screen.dart';

class EditProfilePage extends BlocMaterialPage<AppConfiguration, EditProfileBloc> {
  EditProfilePage() : super(
    key: const ValueKey('EditProfilePage'),
    bloc: EditProfileBloc(),
    createScreen: (b) => EditProfileScreen(bloc: b),
  );
}
