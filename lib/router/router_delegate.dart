import 'package:courseplease/screens/home/screen.dart';
import 'package:courseplease/widgets/small_circular_progress_indicator.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import 'app_configuration_with_lang.dart';
import 'app_state.dart';

class AppRouterDelegate extends RouterDelegate<AppConfigurationWithLang> with ChangeNotifier, PopNavigatorRouterDelegateMixin<AppConfigurationWithLang> {
  @override
  final navigatorKey = GlobalKey<NavigatorState>();
  final _appState = GetIt.instance.get<AppState>();

  AppRouterDelegate() {
    _appState.addListener(notifyListeners);
  }

  @override
  void dispose() {
    _appState.dispose();
    super.dispose();
  }

  /// Returns what to show in the browser URL.
  @override
  AppConfigurationWithLang get currentConfiguration {
    return AppConfigurationWithLang(
      configuration: _appState.getCurrentTabStackBloc().currentConfiguration,
      lang: _appState.langState.lang,
    );
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
  Future<void> setNewRoutePath(AppConfigurationWithLang configuration) async {
    await _appState.langState.setLang(configuration.lang);
  }
}
