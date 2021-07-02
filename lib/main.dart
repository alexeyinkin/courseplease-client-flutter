// @dart=2.9

import 'package:courseplease/screens/home/home.dart';
import 'package:courseplease/screens/routes.dart';
import 'package:courseplease/services/locator.dart';
import 'package:courseplease/utils/yaml_asset_loader.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

final GlobalKey<NavigatorState> navigatorKey = new GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await Hive.initFlutter();
  initializeServiceLocator();

  runApp(CoursePleaseAppWrapper());
}

class CoursePleaseAppWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return EasyLocalization(
      supportedLocales: [Locale('en'), Locale('ru')],
      path: 'assets/translations',
      assetLoader: YamlAssetLoader(),
      fallbackLocale: Locale('en'),
      child: CoursePleaseApp(),
    );
  }
}

class CoursePleaseApp extends StatelessWidget {
  static const _primaryColor = Color(0xFFDF0000);
  static const _darkInactiveColor = Color(0xFF808080);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomeScreen(),
      routes: routeBuilders,
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      theme: _getDarkTheme(),
      navigatorKey: navigatorKey,
    );
  }

  ThemeData _getLightTheme() {
    return ThemeData(
      brightness: Brightness.light,
      primaryColor: _primaryColor,
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(primary: _primaryColor),
      ),
    );
  }

  ThemeData _getDarkTheme() {
    return ThemeData(
      colorScheme: ColorScheme.dark(
        primary: _primaryColor,
        onPrimary: Colors.white,
        secondary: _primaryColor,
      ),
      toggleableActiveColor: Colors.white,
      accentColor: Colors.white,
      textTheme: TextTheme(
        caption: TextStyle(color: _darkInactiveColor),
      ),
    );
  }
}
