import 'package:courseplease/router/app_configuration.dart';
import 'package:flutter/widgets.dart';

class TeacherConfiguration extends AppConfiguration {
  final int teacherId;

  TeacherConfiguration({
    required this.teacherId,
  });

  @override
  RouteInformation restoreRouteInformation() {
    return RouteInformation(location: '/u/$teacherId');
  }
}
