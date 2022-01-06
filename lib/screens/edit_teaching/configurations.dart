import 'package:courseplease/router/app_configuration.dart';
import 'package:flutter/widgets.dart';

class EditTeachingConfiguration extends AppConfiguration {
  @override
  RouteInformation restoreRouteInformation() {
    return RouteInformation(location: '/me/teaching');
  }
}
