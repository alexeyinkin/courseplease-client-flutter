import 'package:courseplease/models/product_subject.dart';
import 'package:courseplease/router/app_configuration.dart';
import 'package:flutter/widgets.dart';

class LessonConfiguration extends AppConfiguration {
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
}
