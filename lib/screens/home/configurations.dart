import 'package:courseplease/router/app_configuration.dart';
import 'package:flutter/widgets.dart';

class HomeConfiguration extends AppConfiguration {
  @override
  RouteInformation restoreRouteInformation() {
    return RouteInformation(location: '/');
  }
}
