import 'package:app_state/app_state.dart';
import 'package:courseplease/router/screen_configuration.dart';
import 'package:courseplease/screens/teach/configurations.dart';
import 'package:courseplease/screens/teach/screen.dart';
import 'package:flutter/foundation.dart';

class TeachPage extends StatelessMaterialPage<ScreenConfiguration> {
  const TeachPage() : super(
    key: const ValueKey('TeachPage'),
    configuration: const TeachConfiguration(),
    child: const TeachScreen(),
  );
}
