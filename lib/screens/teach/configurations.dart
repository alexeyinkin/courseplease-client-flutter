import 'package:courseplease/router/app_configuration.dart';
import 'package:courseplease/router/home_state.dart';
import 'package:courseplease/router/screen_configuration.dart';
import 'package:flutter/widgets.dart';

class TeachConfiguration extends ScreenConfiguration {
  const TeachConfiguration();

  static const _location = '/teach';

  @override
  RouteInformation restoreRouteInformation() {
    return const RouteInformation(location: _location);
  }

  static TeachConfiguration? tryParse(RouteInformation ri) {
    return ri.location == _location
        ? const TeachConfiguration()
        : null;
  }

  @override
  AppNormalizedState get defaultAppNormalizedState {
    return AppNormalizedState(
      // TODO: Stack.
      homeTab: HomeTab.teach,
    );
  }
}
