import 'package:courseplease/router/app_configuration.dart';
import 'package:flutter/widgets.dart';

class EditProfileConfiguration extends AppConfiguration {
  const EditProfileConfiguration();

  @override
  RouteInformation restoreRouteInformation() {
    return RouteInformation(location: '/me/edit');
  }
}
