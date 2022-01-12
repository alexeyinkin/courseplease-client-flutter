import 'package:courseplease/router/app_configuration.dart';
import 'package:courseplease/router/home_state.dart';
import 'package:courseplease/router/screen_configuration.dart';
import 'package:flutter/widgets.dart';

class EditLessonConfiguration extends ScreenConfiguration {
  final int lessonId;

  EditLessonConfiguration({
    required this.lessonId,
  });

  @override
  RouteInformation restoreRouteInformation() {
    return RouteInformation(location: '/me/teaching/lessons/$lessonId');
  }

  @override
  AppNormalizedState get defaultAppNormalizedState {
    return AppNormalizedState(
      // TODO: Stack.
      homeTab: HomeTab.profile,
    );
  }
}
