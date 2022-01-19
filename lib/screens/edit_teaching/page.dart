import 'package:app_state/app_state.dart';
import 'package:courseplease/router/page_configuration.dart';
import 'package:flutter/foundation.dart';

import 'bloc.dart';
import 'screen.dart';

class EditTeachingPage extends BlocMaterialPage<MyPageConfiguration, EditTeachingBloc> {
  static const factoryKey = 'EditTeachingPage';

  EditTeachingPage() : super(
    key: ValueKey(factoryKey),
    bloc: EditTeachingBloc(),
    createScreen: (b) => EditTeachingScreen(bloc: b),
  );
}
