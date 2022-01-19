import 'package:app_state/app_state.dart';
import 'package:model_interfaces/model_interfaces.dart';

import 'home_state.dart';
import 'page_configuration.dart';

class MyAppConfiguration {
  final MyPageConfiguration topPageConfiguration;
  final AppNormalizedState appNormalizedState;
  final String lang;

  MyAppConfiguration({
    required this.topPageConfiguration,
    required this.appNormalizedState,
    required this.lang,
  });
}

class AppNormalizedState implements Normalizable {
  final AppConfiguration appConfiguration;
  final HomeTab homeTab;

  AppNormalizedState({
    this.appConfiguration = const AppConfiguration.empty(),
    required this.homeTab,
  });

  static AppNormalizedState? fromMapOrNull(Map<String, dynamic>? map) {
    if (map == null) return null;

    final appBlocNormalizedState = AppConfiguration.fromMapOrNull(map['ac']);
    if (appBlocNormalizedState == null) return null;

    return AppNormalizedState(
      appConfiguration: appBlocNormalizedState,
      homeTab: HomeTab.values.byName(map['homeTab']),
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'ac': appConfiguration.toJson(),
      'homeTab': homeTab.name,
    };
  }
}
