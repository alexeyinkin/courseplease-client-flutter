import 'package:app_state/app_state.dart';
import 'package:courseplease/router/app_configuration.dart';
import 'package:courseplease/router/home_state.dart';
import 'package:courseplease/router/page_configuration.dart';
import 'package:courseplease/screens/my_profile/configurations.dart';
import 'package:flutter/widgets.dart';

import 'page.dart';

class EditTeachingConfiguration extends MyPageConfiguration {
  const EditTeachingConfiguration() : super(
    key: EditTeachingPage.factoryKey,
  );
  static const _location = '/me/teaching';

  @override
  RouteInformation restoreRouteInformation() {
    return RouteInformation(location: _location);
  }

  static EditTeachingConfiguration? tryParse(RouteInformation routeInformation) {
    return routeInformation.location == _location
        ? const EditTeachingConfiguration()
        : null;
  }

  @override
  AppNormalizedState get defaultAppNormalizedState {
    return AppNormalizedState(
      homeTab: HomeTab.profile,
      appConfiguration: AppConfiguration.singleStack(
        key: HomeTab.profile.name,
        pageConfigurations: [
          MyProfileConfiguration(),
          this,
        ],
      ),
    );
  }
}
