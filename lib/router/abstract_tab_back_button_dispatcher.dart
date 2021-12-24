import 'package:courseplease/router/abstract_tab_state.dart';
import 'package:flutter/widgets.dart';

/// Attempts to pop a page from tab's state stack.
class AbstractTabBackButtonDispatcher extends RootBackButtonDispatcher {
  final AbstractTabState state;

  AbstractTabBackButtonDispatcher(this.state);

  @override
  Future<bool> invokeCallback(Future<bool> defaultValue) {
    return Future.value(state.popPage());
  }
}
