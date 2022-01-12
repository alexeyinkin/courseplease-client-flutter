import 'package:app_state/app_state.dart';
import 'package:courseplease/router/app_configuration.dart';
import 'package:courseplease/router/home_state.dart';
import 'package:courseplease/router/screen_configuration.dart';
import 'package:courseplease/screens/explore/explore_tab_enum.dart';
import 'package:courseplease/screens/explore/page.dart';
import 'package:flutter/widgets.dart';

class ExploreRootConfiguration extends ScreenConfiguration {
  const ExploreRootConfiguration();

  static const _location = '/explore';

  @override
  RouteInformation restoreRouteInformation() {
    return RouteInformation(location: _location);
  }

  @override
  AppNormalizedState get defaultAppNormalizedState {
    return AppNormalizedState(
      homeTab: HomeTab.explore,
    );
  }

  static ExploreRootConfiguration? tryParse(RouteInformation ri) {
    return ri.location == _location
        ? const ExploreRootConfiguration()
        : null;
  }
}

class ExploreSubjectConfiguration extends ScreenConfiguration {
  final ExploreTab tab;
  final String productSubjectPath;

  ExploreSubjectConfiguration({
    required this.tab,
    required this.productSubjectPath,
  });

  static final _regExp = RegExp(r'^/explore/(.*)/(\w+)$');

  @override
  RouteInformation restoreRouteInformation() {
    return RouteInformation(location: '/explore/$productSubjectPath/${tab.name}');
  }

  @override
  AppNormalizedState get defaultAppNormalizedState {
    return AppNormalizedState(
      homeTab: HomeTab.explore,
      appBlocNormalizedState: AppBlocNormalizedState(
        stackStates: {
          HomeTab.explore.name: PageStackBlocNormalizedState(
            screenStates: [
              screenState,
            ],
          ),
        },
      ),
    );
  }

  ScreenBlocNormalizedState get screenState {
    return ScreenBlocNormalizedState(
      pageKey: ExplorePage.factoryKey,
      state: {
        'subjectPath': productSubjectPath,
        'tab': tab.name,
      },
    );
  }

  static ExploreSubjectConfiguration? tryParse(RouteInformation ri) {
    // TODO: Query string to filter.
    final matches = _regExp.firstMatch(ri.location ?? '');
    if (matches == null) return null;

    try {
      final exploreTab = ExploreTab.values.byName(matches[2] ?? '');
      return ExploreSubjectConfiguration(tab: exploreTab, productSubjectPath: matches[1] ?? '');
    } catch (ex) {
      return null;
    }
  }
}
