import 'package:courseplease/screens/home/home.dart';
import 'package:courseplease/widgets/small_circular_progress_indicator.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import 'app_state.dart';
import 'home_state.dart';

class AppRouterDelegate extends RouterDelegate<AppRoutePath> with ChangeNotifier, PopNavigatorRouterDelegateMixin<AppRoutePath> {
  @override
  final GlobalKey<NavigatorState> navigatorKey;
  final _appState = GetIt.instance.get<AppState>();

  AppRouterDelegate()
      : navigatorKey = GlobalKey<NavigatorState>()
  {
    _appState.addListener(notifyListeners);
  }

  @override
  void dispose() {
    _appState.dispose();
    super.dispose();
  }

  /// Returns what to show in the browser URL.
  @override
  AppRoutePath get currentConfiguration {
    final tab = _appState.homeState.homeTab;

    switch (tab) {
      case HomeTab.explore:
        final productSubject = _appState.exploreTabState.currentTreePositionBloc.state.currentObject;
        final tab = _appState.exploreTabState.tab;

        if (productSubject == null || tab == null) {
          return ExploreRoutePath(lang: _appState.langState.lang);
        }

        return ExploreSubjectRoutePath(
          lang: _appState.langState.lang,
          productSubject: productSubject,
          tab: tab,
        );

      case HomeTab.learn:
        return LearnRoutePath(lang: _appState.langState.lang);
      case HomeTab.teach:
        return TeachRoutePath(lang: _appState.langState.lang);
      case HomeTab.messages:
        return MessagesRoutePath(lang: _appState.langState.lang);
      case HomeTab.profile:
        return MeRoutePath(lang: _appState.langState.lang);
    }

    throw Exception('Unknown app state');
  }

  @override
  Widget build(BuildContext context) {
    if (!_appState.langState.isSetExplicitly) {
      return Scaffold(
        body: SmallCircularProgressIndicator(),
      );
    }

    return Navigator(
      key: navigatorKey,
      pages: [
        MaterialPage(
          key: ValueKey('HomePage'),
          child: HomeScreen(
            currentTab: _appState.homeState.homeTab,
          ),
        ),
      ],
      onPopPage: (route, result) {
        if (!route.didPop(result)) {
          return false;
        }

        return true;
      },
    );
  }

  @override
  Future<void> setNewRoutePath(AppRoutePath configuration) async {
    if (configuration is ExploreRoutePath) {
      _appState.homeState.homeTab = HomeTab.explore;
      await _appState.langState.setLang(configuration.lang);
    }

    if (configuration is LearnRoutePath) {
      _appState.homeState.homeTab = HomeTab.learn;
      await _appState.langState.setLang(configuration.lang);
    }

    if (configuration is TeachRoutePath) {
      _appState.homeState.homeTab = HomeTab.teach;
      await _appState.langState.setLang(configuration.lang);
    }

    if (configuration is MessagesRoutePath) {
      _appState.homeState.homeTab = HomeTab.messages;
      await _appState.langState.setLang(configuration.lang);
    }

    if (configuration is MeRoutePath) {
      _appState.homeState.homeTab = HomeTab.profile;
      await _appState.langState.setLang(configuration.lang);
    }
  }
}
