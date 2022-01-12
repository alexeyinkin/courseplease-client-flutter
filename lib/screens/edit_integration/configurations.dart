import 'package:courseplease/router/app_configuration.dart';
import 'package:courseplease/router/home_state.dart';
import 'package:courseplease/router/screen_configuration.dart';
import 'package:flutter/widgets.dart';

class EditIntegrationConfiguration extends ScreenConfiguration {
  final int contactId;

  EditIntegrationConfiguration({
    required this.contactId,
  });

  @override
  RouteInformation restoreRouteInformation() {
    return RouteInformation(location: '/me/contacts/$contactId');
  }

  @override
  AppNormalizedState get defaultAppNormalizedState {
    return AppNormalizedState(
      // TODO: Stack.
      homeTab: HomeTab.profile,
    );
  }
}
