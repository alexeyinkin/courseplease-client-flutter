import 'package:courseplease/router/app_configuration.dart';
import 'package:flutter/widgets.dart';

class EditLessonConfiguration extends AppConfiguration {
  final int lessonId;

  EditLessonConfiguration({
    required this.lessonId,
  });

  @override
  RouteInformation restoreRouteInformation() {
    return RouteInformation(location: '/me/teaching/lessons/$lessonId');
  }
}
