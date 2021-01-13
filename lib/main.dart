import 'package:courseplease/blocs/product_subject_cache.dart';
import 'package:courseplease/repositories/lesson.dart';
import 'package:courseplease/repositories/photo.dart';
import 'package:courseplease/repositories/product_subject.dart';
import 'package:courseplease/repositories/teacher.dart';
import 'package:courseplease/screens/photo/photo.dart';
import 'package:courseplease/screens/home/home.dart';
import 'package:courseplease/screens/teacher/teacher.dart';
import 'package:courseplease/services/filtered_model_list_factory.dart';
import 'package:courseplease/services/model_cache_factory.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'screens/lesson/lesson.dart';

void main() {
  // TODO: Move GetIt initialization to a separate file.
  final productSubjectRepository = ProductSubjectRepository();

  GetIt.instance
      ..registerSingleton<ProductSubjectRepository>(ProductSubjectRepository())
      ..registerSingleton<PhotoRepository>(PhotoRepository())
      ..registerSingleton<TeacherRepository>(TeacherRepository())
      ..registerSingleton<LessonRepository>(LessonRepository())

      ..registerSingleton<ModelCacheFactory>(ModelCacheFactory())
      ..registerSingleton<FilteredModelListFactory>(FilteredModelListFactory())

      ..registerSingleton<ProductSubjectCacheBloc>(ProductSubjectCacheBloc(repository: productSubjectRepository))
  ;
  runApp(CoursePleaseApp());
}

class CoursePleaseApp extends StatefulWidget {
  @override
  State<CoursePleaseApp> createState() => CoursePleaseAppState();
}

class CoursePleaseAppState extends State<CoursePleaseApp> {
  static const _primaryColor = Color(0xFFDF0000);
  static const _darkInactiveColor = Color(0xFF808080);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Home(),
      routes: {
        PhotoLightboxScreen.routeName:  (context) => PhotoLightboxScreen(),
        LessonScreen.routeName:         (context) => LessonScreen(),
        TeacherScreen.routeName:        (context) => TeacherScreen(),
      },
      theme: _getDarkTheme(),
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
