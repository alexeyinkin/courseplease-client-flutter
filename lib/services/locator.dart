import 'package:courseplease/blocs/authentication.dart';
import 'package:courseplease/blocs/chats.dart';
import 'package:courseplease/blocs/contact_status.dart';
import 'package:courseplease/blocs/product_subject_cache.dart';
import 'package:courseplease/repositories/chat.dart';
import 'package:courseplease/repositories/chat_message.dart';
import 'package:courseplease/repositories/image.dart';
import 'package:courseplease/repositories/lesson.dart';
import 'package:courseplease/repositories/product_subject.dart';
import 'package:courseplease/repositories/teacher.dart';
import 'package:get_it/get_it.dart';
import 'filtered_model_list_factory.dart';
import 'model_cache_factory.dart';
import 'net/api_client.dart';

void initializeServiceLocator() {
  // Keep this order. Higher level services may use lower-level services.
  _initializeNetwork();
  _initializeRepositories();
  _initializeCaches();
  _initializeBlocs();
}

void _initializeNetwork() {
  final apiClient = ApiClient(lang: 'en'); // TODO: Use the device locale.

  GetIt.instance
      ..registerSingleton<ApiClient>(apiClient)
  ;
}

void _initializeRepositories() {
  GetIt.instance
      ..registerSingleton<ChatRepository>(ChatRepository())
      ..registerSingleton<ChatMessageRepository>(ChatMessageRepository())
      ..registerSingleton<EditorImageRepository>(EditorImageRepository())
      ..registerSingleton<GalleryImageRepository>(GalleryImageRepository())
      ..registerSingleton<LessonRepository>(LessonRepository())
      ..registerSingleton<ProductSubjectRepository>(ProductSubjectRepository())
      ..registerSingleton<TeacherRepository>(TeacherRepository())
  ;
}

void _initializeCaches() {
  GetIt.instance
      ..registerSingleton<ModelCacheCache>(ModelCacheCache())
      ..registerSingleton<FilteredModelListCache>(FilteredModelListCache())
      ..registerSingleton<ProductSubjectCacheBloc>(ProductSubjectCacheBloc(repository: GetIt.instance.get<ProductSubjectRepository>()))
  ;
}

void _initializeBlocs() {
  GetIt.instance
      ..registerSingleton<AuthenticationBloc>(AuthenticationBloc())
      ..registerSingleton<ChatsCubit>(ChatsCubit())
      ..registerSingleton<ContactStatusCubitFactory>(ContactStatusCubitFactory())
  ;
}
