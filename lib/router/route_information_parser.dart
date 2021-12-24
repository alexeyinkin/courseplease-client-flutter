import 'package:courseplease/router/lang_path_parser.dart';
import 'package:courseplease/models/interfaces/with_homogenous_parent_intname.dart';
import 'package:flutter/widgets.dart';

import 'app_state.dart';
import 'intl_provider.dart';

class AppRouteInformationParser extends RouteInformationParser<AppRoutePath> {
  final _langPathParser = LangPathParser();

  @override
  Future<AppRoutePath> parseRouteInformation(RouteInformation routeInformation) async {
    final uri = Uri.parse(routeInformation.location!);
    final langPath = _langPathParser.parse(uri.path);
    final lang = langPath.lang ?? (await getDeviceLocale()).languageCode;

    switch (langPath.path) {
      case '/':
      case '/explore':
        return ExploreRoutePath(lang: lang);
      case '/learn':
        return LearnRoutePath(lang: lang);
      case '/teach':
        return TeachRoutePath(lang: lang);
      case '/messages':
        return MessagesRoutePath(lang: lang);
      case '/me':
        return MeRoutePath(lang: lang);
    }

    throw Exception('Unknown path');
  }

  @override
  RouteInformation restoreRouteInformation(AppRoutePath path) {
    if (path is ExploreRoutePath) {
      final uri = Uri(path: '/' + path.lang + '/explore');
      final str = uri.toString();
      return RouteInformation(location: str);
    }

    if (path is ExploreSubjectRoutePath) {
      final uri = Uri(path: '/' + path.lang + '/explore/' + WithHomogenousParentIntName.getIntNamePath(path.productSubject, '/') + '/' + path.tab.name);
      final str = uri.toString();
      return RouteInformation(location: str);
    }

    if (path is LearnRoutePath) {
      final uri = Uri(path: '/' + path.lang + '/learn');
      final str = uri.toString();
      return RouteInformation(location: str);
    }

    if (path is TeachRoutePath) {
      final uri = Uri(path: '/' + path.lang + '/teach');
      final str = uri.toString();
      return RouteInformation(location: str);
    }

    if (path is MessagesRoutePath) {
      final uri = Uri(path: '/' + path.lang + '/messages');
      final str = uri.toString();
      return RouteInformation(location: str);
    }

    if (path is MeRoutePath) {
      final uri = Uri(path: '/' + path.lang + '/me');
      final str = uri.toString();
      return RouteInformation(location: str);
    }

    return RouteInformation();
  }
}
