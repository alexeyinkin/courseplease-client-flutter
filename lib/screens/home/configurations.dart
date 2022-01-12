import 'package:courseplease/router/app_configuration.dart';
import 'package:courseplease/router/home_state.dart';
import 'package:courseplease/router/screen_configuration.dart';
import 'package:flutter/widgets.dart';

class HomeConfiguration extends ScreenConfiguration {
  const HomeConfiguration();

  static const _location = '/';

  @override
  RouteInformation restoreRouteInformation() {
    return RouteInformation(location: _location);
  }

  static HomeConfiguration? tryParse(RouteInformation ri) {
    return ri.location == _location
        ? const HomeConfiguration()
        : null;
  }

  @override
  AppNormalizedState get defaultAppNormalizedState {
    return AppNormalizedState(
      homeTab: HomeTab.explore,
    );
  }
}
