import 'package:app_state/app_state.dart';
import 'package:courseplease/router/app_configuration.dart';
import 'package:flutter/widgets.dart';

/// An equivalent of URL in Flutter docs.
/// Can be created from an app state to roughly describe it.
/// Application state can be created from it, this happens on starting via URL.
abstract class MyPageConfiguration extends PageConfiguration {
  const MyPageConfiguration({
    String? key,
    String? factoryKey,
    Map<String, dynamic> state = const {},
  }) : super(
    key: key,
    factoryKey: factoryKey,
    state: state,
  );

  RouteInformation restoreRouteInformation();

  /// The configuration to be applied when navigating directly to this URL.
  AppNormalizedState get defaultAppNormalizedState;
}
