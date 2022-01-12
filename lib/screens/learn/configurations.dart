import 'package:courseplease/router/app_configuration.dart';
import 'package:courseplease/router/home_state.dart';
import 'package:courseplease/router/screen_configuration.dart';
import 'package:flutter/widgets.dart';

class LearnConfiguration extends ScreenConfiguration {
  const LearnConfiguration();

  static const _location = '/learn';

  @override
  RouteInformation restoreRouteInformation() {
    return RouteInformation(location: _location);
  }

  static LearnConfiguration? tryParse(RouteInformation ri) {
    return ri.location == _location
        ? const LearnConfiguration()
        : null;
  }

  @override
  AppNormalizedState get defaultAppNormalizedState {
    return AppNormalizedState(
      homeTab: HomeTab.learn,
    );
  }
}
