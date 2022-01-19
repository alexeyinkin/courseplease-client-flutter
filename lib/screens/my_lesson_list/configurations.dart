import 'package:app_state/app_state.dart';
import 'package:courseplease/router/app_configuration.dart';
import 'package:courseplease/router/home_state.dart';
import 'package:courseplease/router/page_configuration.dart';
import 'package:courseplease/screens/edit_teaching/configurations.dart';
import 'package:courseplease/screens/my_profile/configurations.dart';
import 'package:flutter/widgets.dart';

import 'page.dart';

class MyLessonListConfiguration extends MyPageConfiguration {
  final int subjectId;

  MyLessonListConfiguration({
    required this.subjectId,
  }) : super(
    key: MyLessonListPage.formatKey(subjectId: subjectId),
    factoryKey: MyLessonListPage.factoryKey,
    state: {'subjectId': subjectId},
  );

  static final _regExp = RegExp(r'^/me/teaching/(\d+)/lessons$');

  @override
  RouteInformation restoreRouteInformation() {
    return RouteInformation(
      location: '/me/teaching/$subjectId/lessons',
    );
  }

  static MyLessonListConfiguration? tryParse(RouteInformation ri) {
    final matches = _regExp.firstMatch(ri.location ?? '');
    if (matches == null) return null;

    final subjectId = int.tryParse(matches[1] ?? '');
    if (subjectId == null) {
      return null; // TODO: Log error.
    }

    return MyLessonListConfiguration(
      subjectId: subjectId,
    );
  }

  @override
  AppNormalizedState get defaultAppNormalizedState {
    return AppNormalizedState(
      homeTab: HomeTab.profile,
      appConfiguration: AppConfiguration.singleStack(
        key: HomeTab.profile.name,
        pageConfigurations: [
          MyProfileConfiguration(),
          EditTeachingConfiguration(),
          this,
        ],
      ),
    );
  }
}
