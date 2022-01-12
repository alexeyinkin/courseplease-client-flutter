import 'package:app_state/app_state.dart';
import 'package:courseplease/router/screen_configuration.dart';
import 'package:courseplease/screens/learn/configurations.dart';
import 'package:courseplease/screens/learn/screen.dart';
import 'package:flutter/foundation.dart';

class LearnPage extends StatelessMaterialPage<ScreenConfiguration> {
  const LearnPage() : super(
    key: const ValueKey('LearnPage'),
    configuration: const LearnConfiguration(),
    child: const LearnScreen(),
  );
}
