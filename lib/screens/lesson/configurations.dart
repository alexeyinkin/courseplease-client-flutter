import 'package:app_state/app_state.dart';
import 'package:courseplease/router/home_state.dart';
import 'package:courseplease/router/app_configuration.dart';
import 'package:courseplease/router/page_configuration.dart';
import 'package:courseplease/screens/explore/configurations.dart';
import 'package:courseplease/screens/explore/explore_tab_enum.dart';
import 'package:flutter/widgets.dart';

import 'page.dart';

class LessonConfiguration extends MyPageConfiguration {
  final int lessonId;
  final String subjectPath;

  LessonConfiguration({
    required this.lessonId,
    required this.subjectPath,
  }) : super(
    key: LessonPage.formatKey(lessonId: lessonId),
    factoryKey: LessonPage.factoryKey,
    state: {'lessonId': lessonId},
  );

  static final _regExp = RegExp(r'^/explore/(.*)/lessons/(\d+)$');

  @override
  RouteInformation restoreRouteInformation() {
    return RouteInformation(
      location: '/explore/$subjectPath/lessons/$lessonId',
    );
  }

  static LessonConfiguration? tryParse(RouteInformation ri) {
    final matches = _regExp.firstMatch(ri.location ?? '');
    if (matches == null) return null;

    final subjectPath = matches[1];
    final lessonId = int.tryParse(matches[2] ?? '');

    if (subjectPath == null || lessonId == null) {
      return null; // TODO: Log error
    }

    return LessonConfiguration(
      lessonId: lessonId,
      subjectPath: subjectPath,
    );
  }

  @override
  AppNormalizedState get defaultAppNormalizedState {
    return AppNormalizedState(
      homeTab: HomeTab.explore,
      appConfiguration: AppConfiguration.singleStack(
        key: HomeTab.explore.name,
        pageConfigurations: [
          ExploreSubjectConfiguration(tab: ExploreTab.lessons, subjectPath: subjectPath),
          this,
        ],
      ),
    );
  }
}
