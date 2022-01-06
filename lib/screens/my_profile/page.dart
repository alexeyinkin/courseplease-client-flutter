import 'package:app_state/app_state.dart';
import 'package:courseplease/router/app_configuration.dart';
import 'package:flutter/widgets.dart';

import 'bloc.dart';
import 'screen.dart';

class MyProfilePage extends BlocMaterialPage<AppConfiguration, MyProfileBloc> {
  MyProfilePage() : super(
    key: const ValueKey('MyProfilePage'),
    bloc: MyProfileBloc(),
    createScreen: (b) => MyProfileScreen(bloc: b),
  );
}
