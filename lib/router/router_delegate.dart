import 'package:courseplease/screens/home/screen.dart';
import 'package:courseplease/widgets/small_circular_progress_indicator.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import 'app_configuration.dart';
import 'app_state.dart';

class AppRouterDelegate extends RouterDelegate<MyAppConfiguration> with ChangeNotifier, PopNavigatorRouterDelegateMixin<MyAppConfiguration> {
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
  MyAppConfiguration? get currentConfiguration {
    return _appState.getConfiguration();
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
  Future<void> setNewRoutePath(MyAppConfiguration configuration) async {
    return _appState.setConfiguration(configuration);
  }
}
