import 'package:courseplease/router/app_configuration.dart';
import 'package:courseplease/router/home_state.dart';
import 'package:courseplease/router/screen_configuration.dart';
import 'package:flutter/widgets.dart';

class EditProfileConfiguration extends ScreenConfiguration {
  const EditProfileConfiguration();

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
      // TODO: Stack.
      homeTab: HomeTab.profile,
    );
  }
}
