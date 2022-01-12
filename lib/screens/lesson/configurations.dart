import 'package:courseplease/models/product_subject.dart';
import 'package:courseplease/router/home_state.dart';
import 'package:courseplease/router/app_configuration.dart';
import 'package:courseplease/router/screen_configuration.dart';
import 'package:flutter/widgets.dart';

class LessonConfiguration extends ScreenConfiguration {
  final int lessonId;
  final ProductSubject productSubject;

  LessonConfiguration({
    required this.lessonId,
    required this.productSubject,
  });

  @override
  RouteInformation restoreRouteInformation() {
    return RouteInformation(
      location: '/explore/${productSubject.slashedPath}/lessons/$lessonId',
    );
  }

  @override
  AppNormalizedState get defaultAppNormalizedState {
    return AppNormalizedState(
      // TODO: Stack.
      homeTab: HomeTab.explore,
    );
  }
}
