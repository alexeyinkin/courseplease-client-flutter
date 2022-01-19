import 'package:app_state/app_state.dart';
import 'package:courseplease/router/app_configuration.dart';
import 'package:courseplease/router/home_state.dart';
import 'package:courseplease/router/page_configuration.dart';
import 'package:courseplease/screens/edit_teaching/configurations.dart';
import 'package:courseplease/screens/my_profile/configurations.dart';
import 'package:flutter/widgets.dart';

import 'page.dart';

class EditLessonConfiguration extends MyPageConfiguration {
  final int lessonId;

  EditLessonConfiguration({
    required this.lessonId,
  }) : super(
    key: EditLessonPage.formatKey(lessonId: lessonId),
    factoryKey: EditLessonPage.factoryKey,
    state: {'lessonId': lessonId},
  );

  static final _regExp = RegExp(r'^/me/teaching/lessons/(\d+)$');

  @override
  RouteInformation restoreRouteInformation() {
    return RouteInformation(location: '/me/teaching/lessons/$lessonId');
  }

  static EditLessonConfiguration? tryParse(RouteInformation ri) {
    final matches = _regExp.firstMatch(ri.location ?? '');
    if (matches == null) return null;

    final lessonId = int.tryParse(matches[1] ?? '');
    if (lessonId == null) {
      return null; // TODO: Log error.
    }

    return EditLessonConfiguration(
      lessonId: lessonId,
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
