import 'package:courseplease/blocs/contact_status.dart';
import 'package:courseplease/blocs/product_subject_cache.dart';
import 'package:courseplease/repositories/lesson.dart';
import 'package:courseplease/repositories/photo.dart';
import 'package:courseplease/repositories/product_subject.dart';
import 'package:courseplease/repositories/teacher.dart';
import 'package:courseplease/screens/choose_product_subject/choose_product_subject.dart';
import 'package:courseplease/screens/edit_integration/edit_integration.dart';
import 'package:courseplease/screens/edit_profile/edit_profile.dart';
import 'package:courseplease/screens/photo/photo.dart';
import 'package:courseplease/screens/home/home.dart';
import 'package:courseplease/screens/sign_in_webview/sign_in_webview.dart';
import 'package:courseplease/screens/sort_unsorted_media/sort_unsorted_media.dart';
import 'package:courseplease/screens/teacher/teacher.dart';
import 'package:courseplease/services/filtered_model_list_factory.dart';
import 'package:courseplease/services/model_cache_factory.dart';
import 'package:courseplease/services/net/api_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get_it/get_it.dart';
import 'blocs/authentication.dart';
import 'screens/lesson/lesson.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  final apiClient = ApiClient();
  apiClient.setLang('en');
  GetIt.instance
      ..registerSingleton<ApiClient>(apiClient);

  // TODO: Move GetIt initialization to a separate file.
  final productSubjectRepository = ProductSubjectRepository();

  GetIt.instance
      ..registerSingleton<ProductSubjectRepository>(productSubjectRepository)
      ..registerSingleton<GalleryPhotoRepository>(GalleryPhotoRepository())
      ..registerSingleton<UnsortedPhotoRepository>(UnsortedPhotoRepository())
      ..registerSingleton<TeacherRepository>(TeacherRepository())
      ..registerSingleton<LessonRepository>(LessonRepository())

      ..registerSingleton<ModelCacheCache>(ModelCacheCache())
      ..registerSingleton<FilteredModelListCache>(FilteredModelListCache())

      ..registerSingleton<ProductSubjectCacheBloc>(ProductSubjectCacheBloc(repository: productSubjectRepository))

      ..registerSingleton<AuthenticationBloc>(AuthenticationBloc())
      ..registerSingleton<ContactStatusCubitFactory>(ContactStatusCubitFactory())
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
        ChooseProductSubjectScreen.routeName: (context) => ChooseProductSubjectScreen(),
        EditIntegrationScreen.routeName:      (context) => EditIntegrationScreen(),
        EditProfileScreen.routeName:          (context) => EditProfileScreen(),
        GalleryPhotoLightboxScreen.routeName: (context) => GalleryPhotoLightboxScreen(),
        LessonScreen.routeName:               (context) => LessonScreen(),
        SignInWebviewScreen.routeName:        (context) => SignInWebviewScreen(),
        SortUnsortedMediaScreen.routeName:    (context) => SortUnsortedMediaScreen(),
        TeacherScreen.routeName:              (context) => TeacherScreen(),
        UnsortedPhotoLightboxScreen.routeName:(context) => UnsortedPhotoLightboxScreen(),
      },
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      onGenerateTitle: (BuildContext context) => AppLocalizations.of(context).appTitle,
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
