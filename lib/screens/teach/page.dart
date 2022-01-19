import 'package:app_state/app_state.dart';
import 'package:courseplease/router/page_configuration.dart';
import 'package:courseplease/screens/teach/configurations.dart';
import 'package:courseplease/screens/teach/screen.dart';
import 'package:flutter/foundation.dart';

class TeachPage extends StatelessMaterialPage<MyPageConfiguration> {
  static const factoryKey = 'TeachPage';

  const TeachPage() : super(
    key: const ValueKey(factoryKey),
    configuration: const TeachConfiguration(),
    child: const TeachScreen(),
  );
}
