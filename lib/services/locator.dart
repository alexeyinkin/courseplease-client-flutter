import 'package:courseplease/blocs/ably/ably_native_protocol.dart';
import 'package:courseplease/blocs/ably/ably_sse.dart';
import 'package:courseplease/blocs/authentication.dart';
import 'package:courseplease/blocs/chat_message_factory.dart';
import 'package:courseplease/blocs/chat_message_send_queue.dart';
import 'package:courseplease/blocs/chats.dart';
import 'package:courseplease/blocs/contact_status.dart';
import 'package:courseplease/blocs/like.dart';
import 'package:courseplease/blocs/product_subject_cache.dart';
import 'package:courseplease/blocs/realtime_factory.dart';
import 'package:courseplease/blocs/server_sent_events.dart';
import 'package:courseplease/models/messaging/enum/chat_message_type.dart';
import 'package:courseplease/repositories/chat.dart';
import 'package:courseplease/repositories/chat_message.dart';
import 'package:courseplease/repositories/city_name.dart';
import 'package:courseplease/repositories/comment.dart';
import 'package:courseplease/repositories/country.dart';
import 'package:courseplease/repositories/delivery.dart';
import 'package:courseplease/repositories/gallery_lesson.dart';
import 'package:courseplease/repositories/image.dart';
import 'package:courseplease/repositories/language.dart';
import 'package:courseplease/repositories/money_account_transaction.dart';
import 'package:courseplease/repositories/my_lesson.dart';
import 'package:courseplease/repositories/product_subject.dart';
import 'package:courseplease/repositories/teacher.dart';
import 'package:courseplease/repositories/withdraw_account.dart';
import 'package:courseplease/repositories/withdraw_order.dart';
import 'package:courseplease/repositories/withdraw_service.dart';
import 'package:courseplease/router/app_state.dart';
import 'package:courseplease/screens/home/local_widgets/snacks.dart';
import 'package:courseplease/widgets/builders/factories/contact_params_widget_factory.dart';
import 'package:courseplease/services/messaging/chat_message_denormalizer.dart';
import 'package:courseplease/services/messaging/message_body_denormalizer_locator.dart';
import 'package:courseplease/services/shop/cbr_rate_loader.dart';
import 'package:courseplease/services/shop/currency_converter.dart';
import 'package:courseplease/services/sse/abstract.dart';
import 'package:courseplease/services/sse/chat_message_edit_sse_listener.dart';
import 'package:courseplease/services/sse/chat_sse_reloader.dart';
import 'package:courseplease/services/sse/incoming_chat_message_read_sse_listener.dart';
import 'package:courseplease/services/sse/incoming_chat_message_sse_listener.dart';
import 'package:courseplease/services/sse/outgoing_chat_message_read_sse_listener.dart';
import 'package:courseplease/services/sse/outgoing_chat_message_sse_listener.dart';
import 'package:courseplease/services/sse/sse_listener_locator.dart';
import 'package:courseplease/services/sse/sse_reloader_locator.dart';
import 'package:courseplease/widgets/messaging/enum/sse_type.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'chat_message_draft_persister.dart';
import 'chat_message_queue_persister.dart';
import 'filtered_model_list_factory.dart';
import 'messaging/content_denormalizer.dart';
import 'messaging/purchase_denormalizer.dart';
import 'messaging/refund_agree_denormalizer.dart';
import 'messaging/refund_disagree_denormalizer.dart';
import 'messaging/refund_request_denormalizer.dart';
import 'messaging/time_approve_denormalizer.dart';
import 'messaging/time_offer_denormalizer.dart';
import 'model_cache_factory.dart';
import 'net/api_client.dart';

Future<void> initializeServiceLocator() async {
  // Keep this order. Higher level services may use lower-level services.
  _initializeNetwork();
  _initializeChatMessageDenormalizers();
  _initializeRepositories();
  _initializeCaches();
  _initializeSecureStorage();
  _initializeBlocs();
  _initializeSse();
  await _initializeServices();
  _initializeWidgetFactories();
  await _initializeAppState();
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
      ..registerSingleton<CityNameRepository>(CityNameRepository())
      ..registerSingleton<CommentRepository>(CommentRepository())
      ..registerSingleton<CountryRepository>(CountryRepository())
      ..registerSingleton<DeliveryRepository>(DeliveryRepository())
      ..registerSingleton<GalleryImageRepository>(GalleryImageRepository())
      ..registerSingleton<GalleryLessonRepository>(GalleryLessonRepository())
      ..registerSingleton<LanguageRepository>(LanguageRepository())
      ..registerSingleton<MoneyAccountTransactionRepository>(MoneyAccountTransactionRepository())
      ..registerSingleton<MyImageRepository>(MyImageRepository())
      ..registerSingleton<MyLessonRepository>(MyLessonRepository())
      ..registerSingleton<ProductSubjectRepository>(ProductSubjectRepository())
      ..registerSingleton<TeacherRepository>(TeacherRepository())
      ..registerSingleton<WithdrawAccountRepository>(WithdrawAccountRepository())
      ..registerSingleton<WithdrawOrderRepository>(WithdrawOrderRepository())
      ..registerSingleton<WithdrawServiceRepository>(WithdrawServiceRepository())
  ;
}

void _initializeCaches() {
  GetIt.instance
      ..registerSingleton<ModelCacheCache>(ModelCacheCache())
      ..registerSingleton<FilteredModelListCache>(FilteredModelListCache())
      ..registerSingleton<ProductSubjectCacheBloc>(ProductSubjectCacheBloc(repository: GetIt.instance.get<ProductSubjectRepository>()))
  ;
}

void _initializeSecureStorage() {
  GetIt.instance
      ..registerSingleton<FlutterSecureStorage>(FlutterSecureStorage())
  ;
}

void _initializeBlocs() {
  GetIt.instance
      ..registerSingleton<AuthenticationBloc>(AuthenticationBloc())
      ..registerSingleton<ChatMessageDraftPersisterService>(ChatMessageDraftPersisterService())
      ..registerSingleton<ChatMessageQueuePersisterService>(ChatMessageQueuePersisterService())
      ..registerSingleton<ChatMessageSendQueueCubit>(ChatMessageSendQueueCubit())
      ..registerSingleton<ChatsCubit>(ChatsCubit())
      ..registerSingleton<ChatMessageFactory>(ChatMessageFactory())
      ..registerSingleton<ContactStatusCubitFactory>(ContactStatusCubitFactory())
      ..registerSingleton<LikeCubit>(LikeCubit())
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
      ..add(ChatMessageTypeEnum.timeOffer, TimeOfferMessageBodyDenormalizer())
      ..add(ChatMessageTypeEnum.timeApprove, TimeApproveMessageBodyDenormalizer())
      ..add(ChatMessageTypeEnum.refundRequest, RefundRequestMessageBodyDenormalizer())
      ..add(ChatMessageTypeEnum.refundAgree, RefundAgreeMessageBodyDenormalizer())
      ..add(ChatMessageTypeEnum.refundDisagree, RefundDisagreeMessageBodyDenormalizer())
  ;

  return chatMessageDenormalizerLocator;
}

void _initializeSse() {
  final sseListenerLocator = _createSseListenerLocator();
  final sseReloaderLocator = _createSseReloaderLocator();
  final realtimeFactories = {
    'ably': kIsWeb ? AblySseCubitFactory() : AblyNativeProtocolCubitFactory(),
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
      ..add(SseTypeEnum.chatMessageEdit, ChatMessageEditSseListener())
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

Future<void> _initializeServices() async {
  GetIt.instance
      ..registerSingleton<CurrencyConverter>(await CbrRateLoader.loadConverterFromAssets())
  ;
}

void _initializeWidgetFactories() {
  GetIt.instance
      ..registerSingleton<ContactParamsWidgetFactory>(ContactParamsWidgetFactory())
  ;
}

Future<void> _initializeAppState() async {
  GetIt.instance
      ..registerSingleton<AppState>(await AppState.create())
      ..registerSingleton<SnacksBloc>(SnacksBloc())
  ;
}
