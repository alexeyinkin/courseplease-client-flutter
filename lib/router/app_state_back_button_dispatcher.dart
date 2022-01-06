import 'package:app_state/app_state.dart';
import 'package:courseplease/router/app_state.dart';
import 'package:flutter/widgets.dart';
import 'package:get_it/get_it.dart';

import 'home_state.dart';

/// This app's root back button dispatcher.
/// Directs the request to the current tab on home screen.
class AppStateBackButtonDispatcher extends RootBackButtonDispatcher {
  final _state = GetIt.instance.get<AppState>();
  final _dispatchers = <HomeTab, BackButtonDispatcher>{};

  AppStateBackButtonDispatcher() {
    _dispatchers[HomeTab.explore] = PageStackBackButtonDispatcher(_state.exploreTabBloc);
    _dispatchers[HomeTab.learn] = PageStackBackButtonDispatcher(_state.learnTabBloc);
    _dispatchers[HomeTab.teach] = PageStackBackButtonDispatcher(_state.teachTabBloc);
    _dispatchers[HomeTab.messages] = PageStackBackButtonDispatcher(_state.messagesTabBloc);
    _dispatchers[HomeTab.profile] = PageStackBackButtonDispatcher(_state.profileTabBloc);
  }

  @override
  Future<bool> invokeCallback(Future<bool> defaultValue) async {
    await _getChildDispatcher().invokeCallback(defaultValue);
    return true; // Prevents exiting the app.
  }

  BackButtonDispatcher _getChildDispatcher() {
    final tab = _state.homeState.homeTab;
    return _dispatchers[tab] ?? (throw Exception('Unknown current tab: $tab'));
  }
}
