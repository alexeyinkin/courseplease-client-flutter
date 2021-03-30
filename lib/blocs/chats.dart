import 'dart:async';

import 'package:courseplease/blocs/chat_message_send_queue.dart';
import 'package:courseplease/models/filters/chat.dart';
import 'package:courseplease/models/filters/chat_message.dart';
import 'package:courseplease/models/messaging/chat.dart';
import 'package:courseplease/models/messaging/chat_message.dart';
import 'package:courseplease/models/messaging/sending_chat_message.dart';
import 'package:courseplease/repositories/chat.dart';
import 'package:courseplease/services/filtered_model_list_factory.dart';
import 'package:courseplease/services/net/api_client.dart';
import 'package:get_it/get_it.dart';

import 'bloc.dart';

class ChatsCubit extends Bloc {
  final _apiClient = GetIt.instance.get<ApiClient>();
  final _cache = GetIt.instance.get<FilteredModelListCache>();
  final _chatRepository = GetIt.instance.get<ChatRepository>();
  final _sendQueueCubit = GetIt.instance.get<ChatMessageSendQueueCubit>();
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
      refreshChatMessages(event.response.recipientChatId);
    }
  }

  void _addSentMessageFromQueue(ChatMessageSentEvent event) {
    final message = ChatMessage(
      id:             event.response.messageId!,
      chatId:         event.response.recipientChatId,
      senderUserId:   event.request.senderUserId,
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
    final messageLists = _cache.getModelListsByObjectAndFilterTypes<int, ChatMessage, ChatMessageFilter>();

    for (final list in messageLists.values) {
      if (list.filter.chatId != message.chatId) continue;
      if (list.containsId(message.id)) continue;
      list.addToBeginning([message]);
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

  @override
  void dispose() {
    _queuedMessageSentSubscription.cancel();
  }
}

enum _MessageDirection {
  incoming,
  outgoing,
}
