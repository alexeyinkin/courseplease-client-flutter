import 'package:courseplease/router/lang_path_parser.dart';
import 'package:courseplease/screens/explore/configurations.dart';
import 'package:flutter/widgets.dart';

import 'app_configuration_with_lang.dart';
import 'intl_provider.dart';

class AppRouteInformationParser extends RouteInformationParser<AppConfigurationWithLang> {
  final _langPathParser = LangPathParser();

  @override
  Future<AppConfigurationWithLang> parseRouteInformation(RouteInformation routeInformation) async {
    final uri = Uri.parse(routeInformation.location!);
    final langPath = _langPathParser.parse(uri.path);
    final lang = langPath.lang ?? (await getDeviceLocale()).languageCode;

    return AppConfigurationWithLang(
      configuration: ExploreRootConfiguration(),
      lang: lang,
    );
  }

  @override
  RouteInformation restoreRouteInformation(AppConfigurationWithLang configuration) {
    return RouteInformation(
      location: '/' + configuration.lang + (configuration.configuration.restoreRouteInformation().location ?? ''),
    );
  }
}
