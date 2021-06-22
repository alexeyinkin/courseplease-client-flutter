import 'dart:async';

import 'package:courseplease/blocs/chat_message_send_queue.dart';
import 'package:courseplease/models/filters/chat.dart';
import 'package:courseplease/models/filters/chat_message.dart';
import 'package:courseplease/models/messaging/chat.dart';
import 'package:courseplease/models/messaging/chat_message.dart';
import 'package:courseplease/models/messaging/sending_chat_message.dart';
import 'package:courseplease/models/user.dart';
import 'package:courseplease/repositories/chat.dart';
import 'package:courseplease/screens/home/local_blocs/home.dart';
import 'package:courseplease/services/filtered_model_list_factory.dart';
import 'package:courseplease/services/net/api_client.dart';
import 'package:get_it/get_it.dart';

import 'authentication.dart';
import 'bloc.dart';
import 'chat_list.dart';

class ChatsCubit extends Bloc {
  final _apiClient = GetIt.instance.get<ApiClient>();
  final _authenticationCubit = GetIt.instance.get<AuthenticationBloc>();
  final _cache = GetIt.instance.get<FilteredModelListCache>();
  final _chatRepository = GetIt.instance.get<ChatRepository>();
  final _sendQueueCubit = GetIt.instance.get<ChatMessageSendQueueCubit>();
  final ChatListCubit chatListCubit = ChatListCubit();
  late final StreamSubscription _queuedMessageSentSubscription;

  ChatsCubit() {
    _queuedMessageSentSubscription = _sendQueueCubit.outMessageSent.listen(
      _onQueuedMessageSent,
    );
  }

  void refreshChats() {
    final chatLists = _cache.getModelListsByObjectAndFilterTypes<int, Chat, ChatFilter>();
    for (final list in chatLists.values) {
      list.clearAndLoadFirstPage();
    }
  }

  void clearChatMessages() {
    final chatMessageLists = _cache.getModelListsByObjectAndFilterTypes<int, ChatMessage, ChatMessageFilter>();
    for (final entry in chatMessageLists.entries) {
      entry.value.clear();
    }
  }

  void refreshChatMessages(int chatId) {
    final chatMessageLists = _cache.getModelListsByObjectAndFilterTypes<int, ChatMessage, ChatMessageFilter>();
    final filter = ChatMessageFilter(chatId: chatId);
    final currentChatKey = filter.toString();

    for (final entry in chatMessageLists.entries) {
      if (entry.key == currentChatKey) {
        entry.value.clearAndLoadFirstPage();
      } else {
        entry.value.clear();
      }
    }
  }

  void onIncomingMessage(ChatMessage message) async {
    _prependMessageToChats(message, _MessageDirection.incoming);
    _prependMessageToLists(message);
  }

  void _onQueuedMessageSent(ChatMessageSentEvent event) {
    final messageId = event.response.messageId;

    if (messageId != null) {
      _addSentMessageFromQueue(event);
    } else {
      // Server debounced the duplicate request, the message is sent already.
      refreshChats();
      refreshChatMessages(event.response.chatId);
    }
  }

  void _addSentMessageFromQueue(ChatMessageSentEvent event) {
    final message = ChatMessage(
      id:             event.response.messageId!,
      chatId:         event.response.chatId,
      senderUserId:   event.request.senderUserId,
      type:           ChatMessageTypeEnum.content,
      dateTimeInsert: event.response.dateTimeInsert!,
      dateTimeEdit:   null,
      dateTimeRead:   null,
      body:           event.request.body,
    );

    onOutgoingMessage(message);
  }

  /// For queued messages constructed locally
  /// and for SSE notifications on messages from the other user's devices.
  void onOutgoingMessage(ChatMessage message) async {
    _prependMessageToChats(message, _MessageDirection.outgoing);
    _prependMessageToLists(message);
  }

  void _prependMessageToChats(ChatMessage message, _MessageDirection direction) async {
    final chat =
        _getChatFromAnyListAndPrependMessage(message, direction)
        ?? await _loadChatById(message.chatId);

    if (chat == null) return; // Deleted at server since the event generated.

    final chatLists = _cache.getModelListsByObjectAndFilterTypes<int, Chat, ChatFilter>();

    for (final list in chatLists.values) {
      // TODO: Check if chat matches the filter. Not an issue so far as ChatFilter has no fields.
      // TODO: Remove and add in one operation to not emit two states.
      list.removeObjectIds([chat.id]); // TODO: Speed up. Make 'removeObject'.
      list.addToBeginning([chat]);
    }
  }

  Chat? _getChatFromAnyListAndPrependMessage(ChatMessage message, _MessageDirection direction) {
    final chat = _getChatFromAnyList(message.chatId);
    if (chat == null) return null;

    switch (direction) {
      case _MessageDirection.incoming:
        return chat.withLastIncomingMessage(message);
      case _MessageDirection.outgoing:
        return chat.withLastOutgoingMessage(message);
    }
    throw Exception('Unknown message direction: ' + direction.toString());
  }

  Chat? _getChatFromAnyList(int chatId) {
    final chatLists = _cache.getModelListsByObjectAndFilterTypes<int, Chat, ChatFilter>();
    for (final list in chatLists.values) {
      final chat = list.getObject(chatId);
      if (chat != null) return chat;
    }
    return null;
  }

  Future<Chat?> _loadChatById(int chatId) async {
    return _chatRepository.loadById(chatId);
  }

  void _prependMessageToLists(ChatMessage message) {
    if (_shouldRefreshOnPrepend(message)) {
      refreshChatMessages(message.chatId);
      return;
    }

    final messageLists = _cache.getModelListsByObjectAndFilterTypes<int, ChatMessage, ChatMessageFilter>();

    for (final list in messageLists.values) {
      if (list.filter.chatId != message.chatId) continue;
      if (list.containsId(message.id)) continue;
      list.addToBeginning([message]);
    }
  }

  bool _shouldRefreshOnPrepend(ChatMessage message) {
    switch (message.type) {
      case ChatMessageTypeEnum.timeApprove:
        return true;
    }

    return false;
  }

  void onMessageEdit(ChatMessage message) async {
    _replaceMessageInChats(message);
    _replaceMessageInLists(message);
  }

  void _replaceMessageInChats(ChatMessage message) async {
    final chat = _getChatFromAnyList(message.chatId);
    if (chat == null) return;
    if (chat.lastMessage?.id != message.id) return;

    final updatedChat = chat.withLastMessage(message);
    final chatLists = _cache.getModelListsByObjectAndFilterTypes<int, Chat, ChatFilter>();

    for (final list in chatLists.values) {
      // TODO: Check if chat matches the filter. Not an issue so far as ChatFilter has no fields.
      list.replaceIfExist([updatedChat]);
    }
  }

  void _replaceMessageInLists(ChatMessage message) async {
    final messageLists = _cache.getModelListsByObjectAndFilterTypes<int, ChatMessage, ChatMessageFilter>();

    for (final list in messageLists.values) {
      if (list.filter.chatId != message.chatId) continue;
      list.replaceIfExist([message]);
    }
  }

  void send(SendingChatMessage message) {
    _sendQueueCubit.enqueue(message);
  }

  void markIncomingMessagesRead(List<ChatMessage> messages) async {
    // TODO: Send in chunks to not hit the limit.
    _apiClient.markChatMessagesRead(
      MarkChatMessagesReadRequest(
        messageIds: messages.map((message) => message.id).toList(),
      ),
    );

    for (final message in messages) {
      onIncomingMessageRead(message.chatId, message.id);
    }
  }

  /// For local read events
  /// and for SSE notifications on messages read on the other user's devices.
  void onIncomingMessageRead(int chatId, int messageId) {
    _markReadInMessageLists(chatId, messageId);
    _markReadInChatLists(chatId, messageId, true);
  }

  void onOutgoingMessageRead(int chatId, int messageId) {
    _markReadInMessageLists(chatId, messageId);
    _markReadInChatLists(chatId, messageId, false);
  }

  void _markReadInMessageLists(int chatId, int messageId) {
    final messageLists = _cache.getModelListsByObjectAndFilterTypes<int, ChatMessage, ChatMessageFilter>();

    for (final list in messageLists.values) {
      if (list.filter.chatId != chatId) continue;

      final listMessage = list.getObject(messageId);
      if (listMessage == null) continue;

      listMessage.dateTimeRead = DateTime.now().toUtc();
      list.onExternalObjectChange();
    }
  }

  void _markReadInChatLists(int chatId, int messageId, bool byMe) {
    final chatLists = _cache.getModelListsByObjectAndFilterTypes<int, Chat, ChatFilter>();

    for (final list in chatLists.values) {
      final chat = list.getObject(chatId);
      if (chat == null) continue;

      if (chat.lastMessage?.id == messageId) {
        chat.lastMessage!.dateTimeRead = DateTime.now().toUtc();
      }

      if (byMe && !chat.messageIdsMarkedAsRead.containsKey(messageId)) {
        chat.unreadByMeCount--;
        chat.messageIdsMarkedAsRead[messageId] = 1;
      }

      list.onExternalObjectChange();
    }
  }

  // TODO: Extract to some chat navigation service.
  //       This cubit should be dedicated to background services
  //       and not chat navigation.
  void showChatWithUser(User user) async {
    final authenticationState = _authenticationCubit.currentState;
    if (user.id == authenticationState.data?.user?.id) {
      return; // Cannot chat with oneself.
    }

    final homeScreenCubit = GetIt.instance.get<HomeScreenCubit>();
    homeScreenCubit.setCurrentTab(HomeScreenTab.messages);

    final chat = await _getChatByUser(user);
    chatListCubit.setCurrentChat(chat);
  }

  Future<Chat> _getChatByUser(User user) async {
    final chatRepository = GetIt.instance.get<ChatRepository>();
    final chat = await chatRepository.loadByUserId(user.id);

    if (chat != null) return chat;

    return Chat(
      id: 0,
      lastMessage: null,
      unreadByMeCount: 0,
      otherUsers: [user],
    );
  }

  /// Called when an empty chat is created to queue messages.
  /// At this point, it should be above other chats but has no message ID
  /// to sort it naturally above others.
  void onChatStarted(Chat chat) {
    final chatLists = _cache.getModelListsByObjectAndFilterTypes<int, Chat, ChatFilter>();

    for (final list in chatLists.values) {
      list.addToBeginning([chat]);
    }
  }

  @override
  void dispose() {
    _queuedMessageSentSubscription.cancel();
  }
}

enum _MessageDirection {
  incoming,
  outgoing,
}
