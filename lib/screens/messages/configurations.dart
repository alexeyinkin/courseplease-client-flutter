import 'package:app_state/app_state.dart';
import 'package:courseplease/router/app_configuration.dart';
import 'package:courseplease/router/home_state.dart';
import 'package:courseplease/router/page_configuration.dart';
import 'package:flutter/widgets.dart';

import 'page.dart';

class MessagesConfiguration extends MyPageConfiguration {
  const MessagesConfiguration() : super(
    key: MessagesPage.factoryKey,
  );
  static const _location = '/messages';

  @override
  RouteInformation restoreRouteInformation() {
    return const RouteInformation(location: _location);
  }

  static MessagesConfiguration? tryParse(RouteInformation routeInformation) {
    return routeInformation.location == _location
        ? const MessagesConfiguration()
        : null;
  }

  @override
  AppNormalizedState get defaultAppNormalizedState {
    return AppNormalizedState(
      homeTab: HomeTab.messages,
      appConfiguration: AppConfiguration.singleStack(
        key: HomeTab.messages.name,
        pageConfigurations: [this],
      ),
    );
  }
}
