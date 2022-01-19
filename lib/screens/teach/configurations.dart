import 'package:app_state/app_state.dart';
import 'package:courseplease/router/app_configuration.dart';
import 'package:courseplease/router/home_state.dart';
import 'package:courseplease/router/page_configuration.dart';
import 'package:flutter/widgets.dart';

import 'page.dart';

class TeachConfiguration extends MyPageConfiguration {
  const TeachConfiguration() : super(
    key: TeachPage.factoryKey,
  );

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
      homeTab: HomeTab.teach,
      appConfiguration: AppConfiguration.singleStack(
        key: HomeTab.teach.name,
        pageConfigurations: [this],
      ),
    );
  }
}
