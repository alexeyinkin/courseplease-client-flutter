import 'package:app_state/app_state.dart';
import 'package:model_interfaces/model_interfaces.dart';

import 'home_state.dart';
import 'screen_configuration.dart';

class AppConfiguration {
  final ScreenConfiguration screenConfiguration;
  final AppNormalizedState appNormalizedState;
  final String lang;

  AppConfiguration({
    required this.screenConfiguration,
    required this.appNormalizedState,
    required this.lang,
  });
}

class AppNormalizedState implements Normalizable {
  final AppBlocNormalizedState appBlocNormalizedState;
  final HomeTab homeTab;

  AppNormalizedState({
    this.appBlocNormalizedState = const AppBlocNormalizedState.empty(),
    required this.homeTab,
  });

  static AppNormalizedState? fromMapOrNull(Map<String, dynamic>? map) {
    if (map == null) return null;

    final appBlocNormalizedState = AppBlocNormalizedState.fromMapOrNull(map['appBlocNormalizedState']);
    if (appBlocNormalizedState == null) return null;

    return AppNormalizedState(
      appBlocNormalizedState: appBlocNormalizedState,
      homeTab: HomeTab.values.byName(map['homeTab']),
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'appBlocNormalizedState': appBlocNormalizedState.toJson(),
      'homeTab': homeTab.name,
    };
  }
}
