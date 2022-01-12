import 'package:courseplease/router/app_configuration.dart';
import 'package:courseplease/router/home_state.dart';
import 'package:courseplease/router/screen_configuration.dart';
import 'package:flutter/widgets.dart';

class MyProfileConfiguration extends ScreenConfiguration {
  @override
  RouteInformation restoreRouteInformation() {
    return RouteInformation(location: '/me');
  }

  @override
  AppNormalizedState get defaultAppNormalizedState {
    return AppNormalizedState(
      homeTab: HomeTab.profile,
    );
  }
}
