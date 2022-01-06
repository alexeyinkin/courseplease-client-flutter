import 'package:courseplease/router/app_configuration.dart';
import 'package:flutter/widgets.dart';

class LearnConfiguration extends AppConfiguration {
  const LearnConfiguration();

  @override
  RouteInformation restoreRouteInformation() {
    return const RouteInformation(location: '/learn');
  }
}
