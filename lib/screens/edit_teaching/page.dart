import 'package:app_state/app_state.dart';
import 'package:courseplease/router/app_configuration.dart';
import 'package:flutter/foundation.dart';

import 'configurations.dart';
import 'screen.dart';

class EditTeachingPage extends StatelessMaterialPage<AppConfiguration> {
  EditTeachingPage() : super(
    key: ValueKey('EditTeachingPage'),
    child: EditTeachingScreen(),
    configuration: EditTeachingConfiguration(),
  );
}
