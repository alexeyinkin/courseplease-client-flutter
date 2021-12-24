import 'package:courseplease/router/abstract_tab_back_button_dispatcher.dart';
import 'package:courseplease/router/app_state.dart';
import 'package:flutter/widgets.dart';
import 'package:get_it/get_it.dart';

import 'explore_tab_back_button_dispatcher.dart';
import 'home_state.dart';

/// This app's root back button dispatcher.
/// Directs the request to the current tab on home screen.
class AppStateBackButtonDispatcher extends RootBackButtonDispatcher {
  final _state = GetIt.instance.get<AppState>();
  final _dispatchers = <HomeTab, BackButtonDispatcher>{};

  AppStateBackButtonDispatcher() {
    _dispatchers[HomeTab.explore] = ExploreTabBackButtonDispatcher(_state.exploreTabState);

    // TODO: Custom dispatchers for all tabs or anything that intercepts exiting the app by back button.
    _dispatchers[HomeTab.learn] = AbstractTabBackButtonDispatcher(_state.learnTabState);
    _dispatchers[HomeTab.teach] = AbstractTabBackButtonDispatcher(_state.teachTabState);
    _dispatchers[HomeTab.messages] = AbstractTabBackButtonDispatcher(_state.messagesTabState);
    _dispatchers[HomeTab.profile] = AbstractTabBackButtonDispatcher(_state.profileTabState);
  }

  @override
  Future<bool> invokeCallback(Future<bool> defaultValue) {
    return _getChildDispatcher().invokeCallback(defaultValue);
  }

  BackButtonDispatcher _getChildDispatcher() {
    final tab = _state.homeState.homeTab;
    return _dispatchers[tab] ?? (throw Exception('Unknown current tab: $tab'));
  }
}
