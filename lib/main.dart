// @dart=2.9

import 'package:courseplease/router/app_state.dart';
import 'package:courseplease/router/app_state_back_button_dispatcher.dart';
import 'package:courseplease/router/route_information_parser.dart';
import 'package:courseplease/router/router_delegate.dart';
import 'package:courseplease/services/locator.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:easy_localization_loader/easy_localization_loader.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:url_strategy/url_strategy.dart';

final GlobalKey<NavigatorState> navigatorKey = new GlobalKey<NavigatorState>();

void main() async {
  setPathUrlStrategy();
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await Hive.initFlutter();
  await initializeServiceLocator();

  runApp(CoursePleaseAppLocalizer());
}

/// This should be a separate class so that context is filled with
/// extra stuff when the app's main widget is built.
class CoursePleaseAppLocalizer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appState = GetIt.instance.get<AppState>();

    return EasyLocalization(
      supportedLocales: [Locale('en'), Locale('ru')],
      path: 'assets/translations',
      startLocale: Locale(appState.langState.lang),
      assetLoader: YamlAssetLoader(),
      fallbackLocale: Locale('en'),
      child: CoursePleaseApp(),
    );
  }
}

class CoursePleaseApp extends StatefulWidget {
  static const _primaryColor = Color(0xFFDF0000);
  static const _darkInactiveColor = Color(0xFF808080);

  @override
  State<CoursePleaseApp> createState() => _CoursePleaseAppState();
}

class _CoursePleaseAppState extends State<CoursePleaseApp> {
  final _appState = GetIt.instance.get<AppState>();
  final _routerDelegate = AppRouterDelegate();
  final _routeInformationParser = AppRouteInformationParser();
  final _backButtonDispatcher = AppStateBackButtonDispatcher();

  @override
  void initState() {
    super.initState();
    _appState.addListener(_onAppStateChanged);
  }

  void _onAppStateChanged() async {
    if (context.locale.languageCode != _appState.langState.lang) {
      print('LANG changing to ' + _appState.langState.lang);

      // If changing lang by replacing it in the URL and pressing enter,
      // then without this delay UI is not updated for new lang.
      //
      // When switching the lang with a manual call to appState.langState.setLang,
      // this bug does not appear.
      //
      // Possibly some race condition in EasyLocalization's async initialization.
      // TODO: Find a minimal reproducible example. Maybe file a bug.
      //       Note that in minimal app it does not reproduce: https://stackoverflow.com/q/70141382/11382675
      //       Meanwhile maybe have some better workaround, detect the latter
      //       case and do not pause.
      // UPDATE 2021-11 Somehow it seems to work. Test again in Flutter 2.8.
      //await Future.delayed(Duration(seconds: 1));

      await context.setLocale(Locale(_appState.langState.lang));
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerDelegate: _routerDelegate,
      routeInformationParser: _routeInformationParser,
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      theme: _getDarkTheme(),
      backButtonDispatcher: _backButtonDispatcher,
    );
  }

  ThemeData _getLightTheme() {
    return ThemeData(
      brightness: Brightness.light,
      primaryColor: CoursePleaseApp._primaryColor,
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(primary: CoursePleaseApp._primaryColor),
      ),
    );
  }

  ThemeData _getDarkTheme() {
    return ThemeData(
      colorScheme: ColorScheme.dark(
        primary: CoursePleaseApp._primaryColor,
        onPrimary: Colors.white,
        secondary: CoursePleaseApp._primaryColor,
      ),
      toggleableActiveColor: Colors.white,
      accentColor: Colors.white,
      textTheme: TextTheme(
        caption: TextStyle(color: CoursePleaseApp._darkInactiveColor),
      ),
    );
  }
}
