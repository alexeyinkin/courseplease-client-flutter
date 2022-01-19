import 'package:app_state/app_state.dart';
import 'package:courseplease/router/app_configuration.dart';
import 'package:courseplease/router/home_state.dart';
import 'package:courseplease/router/page_configuration.dart';
import 'package:courseplease/screens/explore/explore_tab_enum.dart';
import 'package:courseplease/screens/explore/page.dart';
import 'package:courseplease/utils/utils.dart';
import 'package:flutter/widgets.dart';

import 'page.dart';

class ExploreRootConfiguration extends MyPageConfiguration {
  const ExploreRootConfiguration() : super(
    key: ExplorePage.factoryKey,
    state: const {'subjectId': null},
  );

  static const _location = '/explore';

  @override
  RouteInformation restoreRouteInformation() {
    return RouteInformation(location: _location);
  }

  @override
  AppNormalizedState get defaultAppNormalizedState {
    return AppNormalizedState(
      homeTab: HomeTab.explore,
      appConfiguration: AppConfiguration.singleStack(
        key: HomeTab.explore.name,
        pageConfigurations: [this],
      ),
    );
  }

  static ExploreRootConfiguration? tryParse(RouteInformation ri) {
    return ri.location == _location || ri.location == '/'
        ? const ExploreRootConfiguration()
        : null;
  }
}

class ExploreSubjectConfiguration extends MyPageConfiguration {
  final ExploreTab? tab;
  final int? subjectId;
  final String subjectPath;

  ExploreSubjectConfiguration({
    required this.tab,
    this.subjectId,
    required this.subjectPath,
  }) : super(
    key: ExplorePage.factoryKey,
    state: {
      'subjectId': subjectId,
      'subjectPath': subjectPath,
      'tab': tab?.name,
    },
  );

  static final _regExp = RegExp(r'^/explore/(.*)(/(\w+))?$');

  @override
  RouteInformation restoreRouteInformation() {
    final tabPart = tab == null ? '' : '/${tab!.name}';
    return RouteInformation(location: '/explore/$subjectPath$tabPart');
  }

  @override
  AppNormalizedState get defaultAppNormalizedState {
    return AppNormalizedState(
      homeTab: HomeTab.explore,
      appConfiguration: AppConfiguration.singleStack(
        key: HomeTab.explore.name,
        pageConfigurations: [this],
      ),
    );
  }

  static ExploreSubjectConfiguration? tryParse(RouteInformation ri) {
    // TODO: Query string to filter.
    final matches = _regExp.firstMatch(ri.location ?? '');
    if (matches == null) return null;

    final exploreTab = ExploreTab.values.byNameOrNull(matches[3] ?? '');
    return ExploreSubjectConfiguration(tab: exploreTab, subjectPath: matches[1] ?? '');
  }
}
