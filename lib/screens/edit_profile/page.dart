import 'package:app_state/app_state.dart';
import 'package:courseplease/router/screen_configuration.dart';
import 'package:flutter/foundation.dart';

import 'bloc.dart';
import 'screen.dart';

class EditProfilePage extends BlocMaterialPage<ScreenConfiguration, EditProfileBloc> {
  EditProfilePage() : super(
    key: const ValueKey('EditProfilePage'),
    bloc: EditProfileBloc(),
    createScreen: (b) => EditProfileScreen(bloc: b),
  );
}
