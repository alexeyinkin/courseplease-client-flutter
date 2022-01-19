import 'package:app_state/app_state.dart';
import 'package:courseplease/router/app_configuration.dart';
import 'package:courseplease/router/home_state.dart';
import 'package:courseplease/router/page_configuration.dart';
import 'package:flutter/widgets.dart';

import 'page.dart';

class LearnConfiguration extends MyPageConfiguration {
  const LearnConfiguration() : super(
    key: LearnPage.factoryKey,
  );

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
      appConfiguration: AppConfiguration.singleStack(
        key: HomeTab.learn.name,
        pageConfigurations: [this],
      ),
    );
  }
}
