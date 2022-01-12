import 'package:courseplease/router/app_configuration.dart';
import 'package:courseplease/router/home_state.dart';
import 'package:courseplease/router/screen_configuration.dart';
import 'package:flutter/widgets.dart';

class TeacherConfiguration extends ScreenConfiguration {
  final int teacherId;

  TeacherConfiguration({
    required this.teacherId,
  });

  @override
  RouteInformation restoreRouteInformation() {
    return RouteInformation(location: '/u/$teacherId');
  }

  @override
  AppNormalizedState get defaultAppNormalizedState {
    return AppNormalizedState(
      // TODO: Stack.
      homeTab: HomeTab.explore,
    );
  }
}
