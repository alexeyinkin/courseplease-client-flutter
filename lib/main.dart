import 'package:courseplease/blocs/contact_status.dart';
import 'package:courseplease/blocs/product_subject_cache.dart';
import 'package:courseplease/repositories/lesson.dart';
import 'package:courseplease/repositories/image.dart';
import 'package:courseplease/repositories/product_subject.dart';
import 'package:courseplease/repositories/teacher.dart';
import 'package:courseplease/screens/choose_product_subject/choose_product_subject.dart';
import 'package:courseplease/screens/edit_integration/edit_integration.dart';
import 'package:courseplease/screens/edit_profile/edit_profile.dart';
import 'package:courseplease/screens/edit_teaching/edit_teaching.dart';
import 'package:courseplease/screens/image/image.dart';
import 'package:courseplease/screens/home/home.dart';
import 'package:courseplease/screens/sign_in_webview/sign_in_webview.dart';
import 'package:courseplease/screens/edit_image_list/edit_image_list.dart';
import 'package:courseplease/screens/teacher/teacher.dart';
import 'package:courseplease/services/filtered_model_list_factory.dart';
import 'package:courseplease/services/model_cache_factory.dart';
import 'package:courseplease/services/net/api_client.dart';
import 'package:courseplease/utils/yaml_asset_loader.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
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
      ..registerSingleton<GalleryImageRepository>(GalleryImageRepository())
      ..registerSingleton<EditorImageRepository>(EditorImageRepository())
      ..registerSingleton<TeacherRepository>(TeacherRepository())
      ..registerSingleton<LessonRepository>(LessonRepository())

      ..registerSingleton<ModelCacheCache>(ModelCacheCache())
      ..registerSingleton<FilteredModelListCache>(FilteredModelListCache())

      ..registerSingleton<ProductSubjectCacheBloc>(ProductSubjectCacheBloc(repository: productSubjectRepository))

      ..registerSingleton<AuthenticationBloc>(AuthenticationBloc())
      ..registerSingleton<ContactStatusCubitFactory>(ContactStatusCubitFactory())
  ;
  runApp(CoursePleaseAppWrapper());
}

class CoursePleaseAppWrapper extends StatefulWidget {
  @override
  State<CoursePleaseAppWrapper> createState() => _CoursePleaseAppWrapperState();
}

class _CoursePleaseAppWrapperState extends State<CoursePleaseAppWrapper> {
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
      home: Home(),
      routes: {
        ChooseProductSubjectScreen.routeName: (context) => ChooseProductSubjectScreen(),
        EditIntegrationScreen.routeName:      (context) => EditIntegrationScreen(),
        EditProfileScreen.routeName:          (context) => EditProfileScreen(),
        EditTeachingScreen.routeName:         (context) => EditTeachingScreen(),
        FixedIdsImageLightboxScreen.routeName:(context) => FixedIdsImageLightboxScreen(),
        ViewImageLightboxScreen.routeName:    (context) => ViewImageLightboxScreen(),
        LessonScreen.routeName:               (context) => LessonScreen(),
        SignInWebviewScreen.routeName:        (context) => SignInWebviewScreen(),
        EditImageListScreen.routeName:        (context) => EditImageListScreen(),
        TeacherScreen.routeName:              (context) => TeacherScreen(),
        EditImageLightboxScreen.routeName:    (context) => EditImageLightboxScreen(),
      },
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
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
