import 'package:app_state/app_state.dart';
import 'package:courseplease/router/page_configuration.dart';
import 'package:flutter/widgets.dart';

import 'bloc.dart';
import 'screen.dart';

class MyProfilePage extends BlocMaterialPage<MyPageConfiguration, MyProfileBloc> {
  static const factoryKey = 'MyProfilePage';

  MyProfilePage() : super(
    key: const ValueKey(factoryKey),
    bloc: MyProfileBloc(),
    createScreen: (b) => MyProfileScreen(bloc: b),
  );
}
