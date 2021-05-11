import 'package:courseplease/blocs/ably.dart';
import 'package:courseplease/blocs/authentication.dart';
import 'package:courseplease/blocs/chat_message_send_queue.dart';
import 'package:courseplease/blocs/chats.dart';
import 'package:courseplease/blocs/contact_status.dart';
import 'package:courseplease/blocs/product_subject_cache.dart';
import 'package:courseplease/blocs/realtime_factory.dart';
import 'package:courseplease/blocs/server_sent_events.dart';
import 'package:courseplease/models/messaging/chat_message.dart';
import 'package:courseplease/models/sse/server_sent_event.dart';
import 'package:courseplease/repositories/chat.dart';
import 'package:courseplease/repositories/chat_message.dart';
import 'package:courseplease/repositories/delivery.dart';
import 'package:courseplease/repositories/image.dart';
import 'package:courseplease/repositories/lesson.dart';
import 'package:courseplease/repositories/product_subject.dart';
import 'package:courseplease/repositories/teacher.dart';
import 'package:courseplease/screens/home/local_blocs/home.dart';
import 'package:courseplease/services/messaging/chat_message_denormalizer.dart';
import 'package:courseplease/services/messaging/message_body_denormalizer_locator.dart';
import 'package:courseplease/services/sse/abstract.dart';
import 'package:courseplease/services/sse/chat_sse_reloader.dart';
import 'package:courseplease/services/sse/incoming_chat_message_read_sse_listener.dart';
import 'package:courseplease/services/sse/incoming_chat_message_sse_listener.dart';
import 'package:courseplease/services/sse/outgoing_chat_message_read_sse_listener.dart';
import 'package:courseplease/services/sse/outgoing_chat_message_sse_listener.dart';
import 'package:courseplease/services/sse/sse_listener_locator.dart';
import 'package:courseplease/services/sse/sse_reloader_locator.dart';
import 'package:get_it/get_it.dart';
import 'chat_message_draft_persister.dart';
import 'chat_message_queue_persister.dart';
import 'filtered_model_list_factory.dart';
import 'messaging/content_denormalizer.dart';
import 'messaging/purchase_denormalizer.dart';
import 'messaging/time_offer_denormalizer.dart';
import 'model_cache_factory.dart';
import 'net/api_client.dart';

void initializeServiceLocator() {
  // Keep this order. Higher level services may use lower-level services.
  _initializeNetwork();
  _initializeChatMessageDenormalizers();
  _initializeRepositories();
  _initializeCaches();
  _initializeBlocs();
  _initializeSse();
}

void _initializeNetwork() {
  final apiClient = ApiClient(lang: 'en'); // TODO: Use the device locale.

  GetIt.instance
      ..registerSingleton<ApiClient>(apiClient)
  ;
}

void _initializeRepositories() {
  GetIt.instance
      ..registerSingleton<ChatMessageRepository>(ChatMessageRepository())
      ..registerSingleton<ChatRepository>(ChatRepository())
      ..registerSingleton<DeliveryRepository>(DeliveryRepository())
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
      ..registerSingleton<ChatMessageDraftPersisterService>(ChatMessageDraftPersisterService())
      ..registerSingleton<ChatMessageQueuePersisterService>(ChatMessageQueuePersisterService())
      ..registerSingleton<ChatMessageSendQueueCubit>(ChatMessageSendQueueCubit())
      ..registerSingleton<ChatsCubit>(ChatsCubit())
      ..registerSingleton<ContactStatusCubitFactory>(ContactStatusCubitFactory())
      ..registerSingleton<HomeScreenCubit>(HomeScreenCubit())
  ;
}

void _initializeChatMessageDenormalizers() {
  final locator = _createMessageBodyDenormalizerLocator();

  GetIt.instance
      ..registerSingleton<MessageBodyDenormalizerLocator>(locator)
      ..registerSingleton<ChatMessageDenormalizer>(ChatMessageDenormalizer())
  ;
}

MessageBodyDenormalizerLocator _createMessageBodyDenormalizerLocator() {
  final chatMessageDenormalizerLocator = MessageBodyDenormalizerLocator();

  chatMessageDenormalizerLocator
      ..add(ChatMessageTypeEnum.content, ContentMessageBodyDenormalizer())
      ..add(ChatMessageTypeEnum.purchase, PurchaseMessageBodyDenormalizer())
      ..add(ChatMessageTypeEnum.offerLessonStaticTime, TimeOfferMessageBodyDenormalizer())
  ;

  return chatMessageDenormalizerLocator;
}

void _initializeSse() {
  final sseListenerLocator = _createSseListenerLocator();
  final sseReloaderLocator = _createSseReloaderLocator();
  final realtimeFactories = {
    'ably': AblySseCubitFactory(),
  };

  GetIt.instance
      ..registerSingleton<SseListenerLocator>(sseListenerLocator)
      ..registerSingleton<SseReloaderLocator>(sseReloaderLocator)
      ..registerSingleton<ServerSentEventsCubit>(ServerSentEventsCubit())
      ..registerSingleton<RealtimeFactoryCubit>(RealtimeFactoryCubit(factories: realtimeFactories))
  ;
}

SseListenerLocator _createSseListenerLocator() {
  final sseListenerLocator = SseListenerLocator();

  sseListenerLocator
      ..add(SseTypeEnum.empty, EmptySseListener())
      ..add(SseTypeEnum.incomingChatMessage, IncomingChatMessageSseListener())
      ..add(SseTypeEnum.outgoingChatMessage, OutgoingChatMessageSseListener())
      ..add(SseTypeEnum.incomingChatMessageRead, IncomingChatMessageReadSseListener())
      ..add(SseTypeEnum.outgoingChatMessageRead, OutgoingChatMessageReadSseListener())
  ;

  return sseListenerLocator;
}

SseReloaderLocator _createSseReloaderLocator() {
  final sseReloaderLocator = SseReloaderLocator();

  sseReloaderLocator
      ..add(ChatSseReloader())
  ;

  return sseReloaderLocator;
}
