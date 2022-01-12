import 'package:courseplease/router/app_configuration.dart';
import 'package:courseplease/router/home_state.dart';
import 'package:courseplease/router/screen_configuration.dart';
import 'package:flutter/widgets.dart';

class MessagesConfiguration extends ScreenConfiguration {
  const MessagesConfiguration();
  static const _location = '/messages';

  @override
  RouteInformation restoreRouteInformation() {
    return const RouteInformation(location: _location);
  }

  static MessagesConfiguration? tryParse(RouteInformation routeInformation) {
    return routeInformation.location == _location
        ? const MessagesConfiguration()
        : null;
  }

  @override
  AppNormalizedState get defaultAppNormalizedState {
    return AppNormalizedState(
      homeTab: HomeTab.messages,
    );
  }
}
