import 'package:app_state/app_state.dart';
import 'package:courseplease/router/app_configuration.dart';
import 'package:courseplease/router/home_state.dart';
import 'package:courseplease/router/page_configuration.dart';
import 'package:courseplease/screens/my_profile/configurations.dart';
import 'package:flutter/widgets.dart';

import 'page.dart';

class EditProfileConfiguration extends MyPageConfiguration {
  const EditProfileConfiguration() : super(
    key: EditProfilePage.factoryKey,
  );

  static const _location = '/me/edit';

  @override
  RouteInformation restoreRouteInformation() {
    return RouteInformation(location: _location);
  }

  static EditProfileConfiguration? tryParse(RouteInformation ri) {
    return ri.location == _location
        ? const EditProfileConfiguration()
        : null;
  }

  @override
  AppNormalizedState get defaultAppNormalizedState {
    return AppNormalizedState(
      homeTab: HomeTab.profile,
      appConfiguration: AppConfiguration.singleStack(
        key: HomeTab.profile.name,
        pageConfigurations: [
          const MyProfileConfiguration(),
          this,
        ],
      ),
    );
  }
}
