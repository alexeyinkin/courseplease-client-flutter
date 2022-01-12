import 'package:courseplease/models/filters/my_lesson.dart';
import 'package:courseplease/router/app_configuration.dart';
import 'package:courseplease/router/home_state.dart';
import 'package:courseplease/router/screen_configuration.dart';
import 'package:flutter/widgets.dart';

class MyLessonListConfiguration extends ScreenConfiguration {
  final MyLessonFilter filter;

  MyLessonListConfiguration({
    required this.filter,
  });

  @override
  RouteInformation restoreRouteInformation() {
    return RouteInformation(
      location: '/me/teaching/${filter.subjectIds.first}/lessons',
    );
  }

  @override
  AppNormalizedState get defaultAppNormalizedState {
    return AppNormalizedState(
      // TODO: Stack.
      homeTab: HomeTab.profile,
    );
  }
}
