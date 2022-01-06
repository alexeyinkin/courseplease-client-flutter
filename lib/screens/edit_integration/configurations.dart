import 'package:courseplease/router/app_configuration.dart';
import 'package:flutter/widgets.dart';

class EditIntegrationConfiguration extends AppConfiguration {
  final int contactId;

  EditIntegrationConfiguration({
    required this.contactId,
  });

  @override
  RouteInformation restoreRouteInformation() {
    return RouteInformation(location: '/me/contacts/$contactId');
  }
}
