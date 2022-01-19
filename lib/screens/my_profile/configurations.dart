import 'package:app_state/app_state.dart';
import 'package:courseplease/router/app_configuration.dart';
import 'package:courseplease/router/home_state.dart';
import 'package:courseplease/router/page_configuration.dart';
import 'package:courseplease/screens/my_profile/page.dart';
import 'package:flutter/widgets.dart';

class MyProfileConfiguration extends MyPageConfiguration {
  const MyProfileConfiguration() : super(
    key: MyProfilePage.factoryKey,
  );

  static const _location = '/me';

  @override
  RouteInformation restoreRouteInformation() {
    return RouteInformation(location: _location);
  }

  static MyProfileConfiguration? tryParse(RouteInformation routeInformation) {
    return routeInformation.location == _location
        ? const MyProfileConfiguration()
        : null;
  }

  @override
  AppNormalizedState get defaultAppNormalizedState {
    return AppNormalizedState(
      homeTab: HomeTab.profile,
      appConfiguration: AppConfiguration.singleStack(
        key: MyProfilePage.factoryKey,
        pageConfigurations: [this],
      ),
    );
  }
}
