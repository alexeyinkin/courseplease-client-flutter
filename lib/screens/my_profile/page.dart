import 'package:app_state/app_state.dart';
import 'package:courseplease/router/screen_configuration.dart';
import 'package:flutter/widgets.dart';

import 'bloc.dart';
import 'screen.dart';

class MyProfilePage extends BlocMaterialPage<ScreenConfiguration, MyProfileBloc> {
  MyProfilePage() : super(
    key: const ValueKey('MyProfilePage'),
    bloc: MyProfileBloc(),
    createScreen: (b) => MyProfileScreen(bloc: b),
  );
}
