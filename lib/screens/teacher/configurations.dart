import 'package:app_state/app_state.dart';
import 'package:courseplease/router/app_configuration.dart';
import 'package:courseplease/router/home_state.dart';
import 'package:courseplease/router/page_configuration.dart';
import 'package:courseplease/screens/explore/configurations.dart';
import 'package:flutter/widgets.dart';

import 'page.dart';

class TeacherConfiguration extends MyPageConfiguration {
  final int teacherId;

  TeacherConfiguration({
    required this.teacherId,
  }) : super(
    key: TeacherPage.formatKey(teacherId: teacherId),
    factoryKey: TeacherPage.factoryKey,
    state: {'teacherId': teacherId},
  );

  static final _regExp = RegExp(r'^/u/(\d+)$');

  @override
  RouteInformation restoreRouteInformation() {
    return RouteInformation(location: '/u/$teacherId');
  }

  static TeacherConfiguration? tryParse(RouteInformation ri) {
    final matches = _regExp.firstMatch(ri.location ?? '');
    if (matches == null) return null;

    final teacherId = int.tryParse(matches[1] ?? '');
    if (teacherId == null) {
      return null; // TODO: Log error.
    }

    return TeacherConfiguration(
      teacherId: teacherId,
    );
  }

  @override
  AppNormalizedState get defaultAppNormalizedState {
    return AppNormalizedState(
      homeTab: HomeTab.explore,
      appConfiguration: AppConfiguration.singleStack(
        key: HomeTab.explore.name,
        pageConfigurations: [
          ExploreRootConfiguration(),
          this,
        ],
      ),
    );
  }
}
