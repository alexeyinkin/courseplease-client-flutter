import 'package:courseplease/router/app_configuration.dart';
import 'package:flutter/widgets.dart';

class CreateLessonConfiguration extends AppConfiguration {
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
}
