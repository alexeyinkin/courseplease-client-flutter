import 'package:courseplease/router/screen_configuration.dart';
import 'package:courseplease/router/lang_path_parser.dart';
import 'package:courseplease/screens/edit_profile/configurations.dart';
import 'package:courseplease/screens/explore/configurations.dart';
import 'package:courseplease/screens/home/configurations.dart';
import 'package:courseplease/screens/learn/configurations.dart';
import 'package:courseplease/screens/messages/configurations.dart';
import 'package:courseplease/screens/teach/configurations.dart';
import 'package:flutter/widgets.dart';

import 'app_configuration.dart';
import 'intl_provider.dart';

class AppRouteInformationParser extends RouteInformationParser<AppConfiguration> {
  final _langPathParser = LangPathParser();

  @override
  Future<AppConfiguration> parseRouteInformation(RouteInformation routeInformation) async {
    final uri = Uri.parse(routeInformation.location!);
    final langPath = _langPathParser.parse(uri.path);

    final lang = langPath.lang ?? (await getDeviceLocale()).languageCode;
    final ri = RouteInformation(
      location: langPath.path,
      state: routeInformation.state,
    );

    final screenConfiguration = await _parseRouteInformationWithoutLang(ri);
    final appNormalizedState =
        AppNormalizedState.fromMapOrNull(routeInformation.state as Map<String, dynamic>?) ??
        screenConfiguration.defaultAppNormalizedState;

    return AppConfiguration(
      screenConfiguration: screenConfiguration,
      appNormalizedState: appNormalizedState,
      lang: lang,
    );
  }

  Future<ScreenConfiguration> _parseRouteInformationWithoutLang(RouteInformation ri) async {
    return
        // The most probable.
        HomeConfiguration.tryParse(ri) ??

        // Alphabetic.
        EditProfileConfiguration.tryParse(ri) ??
        ExploreRootConfiguration.tryParse(ri) ??
        ExploreSubjectConfiguration.tryParse(ri) ??
        LearnConfiguration.tryParse(ri) ??
        MessagesConfiguration.tryParse(ri) ??
        TeachConfiguration.tryParse(ri) ??

        // Home if nothing worked.
        HomeConfiguration();
  }

  @override
  RouteInformation restoreRouteInformation(AppConfiguration configuration) {
    final riWithoutLang = configuration.screenConfiguration.restoreRouteInformation();
    return RouteInformation(
      location: '/' + configuration.lang + (riWithoutLang.location ?? ''),
      state: configuration.appNormalizedState,
    );
  }
}
