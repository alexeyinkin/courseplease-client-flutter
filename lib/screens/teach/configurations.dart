import 'package:courseplease/router/app_configuration.dart';
import 'package:flutter/widgets.dart';

class TeachConfiguration extends AppConfiguration {
  const TeachConfiguration();

  @override
  RouteInformation restoreRouteInformation() {
    return const RouteInformation(location: '/teach');
  }
}
