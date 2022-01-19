import 'package:app_state/app_state.dart';
import 'package:courseplease/router/page_configuration.dart';
import 'package:flutter/foundation.dart';

import 'bloc.dart';
import 'screen.dart';

class EditProfilePage extends BlocMaterialPage<MyPageConfiguration, EditProfileBloc> {
  static const factoryKey = 'EditProfilePage';

  EditProfilePage() : super(
    key: const ValueKey(factoryKey),
    bloc: EditProfileBloc(),
    createScreen: (b) => EditProfileScreen(bloc: b),
  );
}
