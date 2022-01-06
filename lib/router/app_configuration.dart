import 'package:flutter/widgets.dart';

/// An equivalent of URL in Flutter docs.
/// Can be created from an app state to roughly describe it.
/// Application state can be created from it, this happens on starting via URL.
abstract class AppConfiguration {
  const AppConfiguration();
  RouteInformation restoreRouteInformation();
}
