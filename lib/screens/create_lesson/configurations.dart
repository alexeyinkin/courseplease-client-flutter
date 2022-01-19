import 'package:app_state/app_state.dart';
import 'package:courseplease/router/app_configuration.dart';
import 'package:courseplease/router/home_state.dart';
import 'package:courseplease/router/page_configuration.dart';
import 'package:courseplease/screens/edit_teaching/configurations.dart';
import 'package:courseplease/screens/my_lesson_list/configurations.dart';
import 'package:courseplease/screens/my_profile/configurations.dart';
import 'package:flutter/widgets.dart';

import 'page.dart';

class CreateLessonConfiguration extends MyPageConfiguration {
  final int? subjectId;

  CreateLessonConfiguration({
    required this.subjectId,
  }) : super(
    key: CreateLessonPage.formatKey(subjectId: subjectId),
    factoryKey: CreateLessonPage.factoryKey,
    state: {'subjectId': subjectId},
  );

  static final _regExp = RegExp(r'/me/teaching/((\d+)/)?lessons/add');

  @override
  RouteInformation restoreRouteInformation() {
    final subjectIdPart = subjectId == null ? '' : '$subjectId/';

    return RouteInformation(
      location: '/me/teaching/${subjectIdPart}lessons/add',
    );
  }

  static CreateLessonConfiguration? tryParse(RouteInformation ri) {
    final matches = _regExp.firstMatch(ri.location ?? '');
    if (matches == null) return null;

    final subjectId = int.tryParse(matches[2] ?? '');

    return CreateLessonConfiguration(
      subjectId: subjectId,
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
          if (subjectId != null) MyLessonListConfiguration(subjectId: subjectId!),
          this,
        ],
      ),
    );
  }
}
