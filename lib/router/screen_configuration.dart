import 'package:courseplease/router/app_configuration.dart';
import 'package:flutter/widgets.dart';

/// An equivalent of URL in Flutter docs.
/// Can be created from an app state to roughly describe it.
/// Application state can be created from it, this happens on starting via URL.
abstract class ScreenConfiguration {
  const ScreenConfiguration();

  RouteInformation restoreRouteInformation();

  /// The configuration to be applied when navigating directly to this URL.
  AppNormalizedState get defaultAppNormalizedState;
}
