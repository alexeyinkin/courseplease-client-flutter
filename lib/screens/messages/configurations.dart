import 'package:courseplease/router/app_configuration.dart';
import 'package:flutter/widgets.dart';

class MessagesConfiguration extends AppConfiguration {
  const MessagesConfiguration();

  @override
  RouteInformation restoreRouteInformation() {
    return const RouteInformation(location: '/messages');
  }
}
