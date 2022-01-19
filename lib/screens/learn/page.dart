import 'package:app_state/app_state.dart';
import 'package:courseplease/router/page_configuration.dart';
import 'package:courseplease/screens/learn/configurations.dart';
import 'package:courseplease/screens/learn/screen.dart';
import 'package:flutter/foundation.dart';

class LearnPage extends StatelessMaterialPage<MyPageConfiguration> {
  static const factoryKey = 'LearnPage';

  const LearnPage() : super(
    key: const ValueKey(factoryKey),
    configuration: const LearnConfiguration(),
    child: const LearnScreen(),
  );
}
