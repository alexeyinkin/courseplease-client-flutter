import 'package:courseplease/router/page_configuration.dart';
import 'package:courseplease/router/lang_path_parser.dart';
import 'package:courseplease/screens/create_lesson/configurations.dart';
import 'package:courseplease/screens/edit_lesson/configurations.dart';
import 'package:courseplease/screens/edit_profile/configurations.dart';
import 'package:courseplease/screens/edit_teaching/configurations.dart';
import 'package:courseplease/screens/explore/configurations.dart';
import 'package:courseplease/screens/image/configurations.dart';
import 'package:courseplease/screens/learn/configurations.dart';
import 'package:courseplease/screens/lesson/configurations.dart';
import 'package:courseplease/screens/messages/configurations.dart';
import 'package:courseplease/screens/my_lesson_list/configurations.dart';
import 'package:courseplease/screens/my_profile/configurations.dart';
import 'package:courseplease/screens/teach/configurations.dart';
import 'package:courseplease/screens/teacher/configurations.dart';
import 'package:flutter/widgets.dart';

import 'app_configuration.dart';
import 'intl_provider.dart';

class AppRouteInformationParser extends RouteInformationParser<MyAppConfiguration> {
  final _langPathParser = LangPathParser();

  @override
  Future<MyAppConfiguration> parseRouteInformation(RouteInformation routeInformation) async {
    final uri = Uri.parse(routeInformation.location!);
    final langPath = _langPathParser.parse(uri.path);

    final lang = langPath.lang ?? (await getDeviceLocale()).languageCode;
    final ri = RouteInformation(
      location: langPath.path,
      state: routeInformation.state,
    );

    final topPageConfiguration = await _parseRouteInformationWithoutLang(ri);
    final appNormalizedState =
        AppNormalizedState.fromMapOrNull(routeInformation.state as Map<String, dynamic>?) ??
        topPageConfiguration.defaultAppNormalizedState;

    return MyAppConfiguration(
      topPageConfiguration: topPageConfiguration,
      appNormalizedState: appNormalizedState,
      lang: lang,
    );
  }

  Future<MyPageConfiguration> _parseRouteInformationWithoutLang(RouteInformation ri) async {
    return
        // The most probable.
        ExploreRootConfiguration.tryParse(ri) ??

        // Alphabetic.
        CreateLessonConfiguration.tryParse(ri) ??
        EditLessonConfiguration.tryParse(ri) ??
        EditProfileConfiguration.tryParse(ri) ??
        EditTeachingConfiguration.tryParse(ri) ??
        ImagePageConfiguration.tryParse(ri) ??
        LearnConfiguration.tryParse(ri) ??
        LessonConfiguration.tryParse(ri) ??
        MessagesConfiguration.tryParse(ri) ??
        MyLessonListConfiguration.tryParse(ri) ??
        MyProfileConfiguration.tryParse(ri) ??
        TeachConfiguration.tryParse(ri) ??
        TeacherConfiguration.tryParse(ri) ??

        // Default for their sub-paths, must go last.
        ExploreSubjectConfiguration.tryParse(ri) ??     // /explore/path

        // Home if nothing worked.
        ExploreRootConfiguration();
  }

  @override
  RouteInformation restoreRouteInformation(MyAppConfiguration configuration) {
    final riWithoutLang = configuration.topPageConfiguration.restoreRouteInformation();
    return RouteInformation(
      location: '/' + configuration.lang + (riWithoutLang.location ?? ''),
      state: configuration.appNormalizedState,
    );
  }
}
