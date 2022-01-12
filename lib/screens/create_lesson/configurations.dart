import 'package:courseplease/router/app_configuration.dart';
import 'package:courseplease/router/home_state.dart';
import 'package:courseplease/router/screen_configuration.dart';
import 'package:flutter/widgets.dart';

class CreateLessonConfiguration extends ScreenConfiguration {
  final int? subjectId;

  CreateLessonConfiguration({
    required this.subjectId,
  });

  @override
  RouteInformation restoreRouteInformation() {
    final subjectIdPart = subjectId == null ? '' : '$subjectId/';

    return RouteInformation(
      location: '/me/teaching/${subjectIdPart}lessons/add',
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
