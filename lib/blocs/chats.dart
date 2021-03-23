import 'package:courseplease/models/filters/chat.dart';
import 'package:courseplease/models/filters/chat_message.dart';
import 'package:courseplease/models/messaging/chat.dart';
import 'package:courseplease/models/messaging/chat_message.dart';
import 'package:courseplease/repositories/chat.dart';
import 'package:courseplease/services/filtered_model_list_factory.dart';
import 'package:get_it/get_it.dart';

import 'bloc.dart';

class ChatsCubit extends Bloc {
  final _cache = GetIt.instance.get<FilteredModelListCache>();
  final _chatRepository = GetIt.instance.get<ChatRepository>();

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

  void _prependMessageToChats(ChatMessage message, _MessageDirection direction) async {
    final chat =
        _getChatFromAnyListAndPrependMessage(message, direction)
        ?? await _loadChatById(message.chatId);

    if (chat == null) return; // Deleted at server since the event generated.

    final chatLists = _cache.getModelListsByObjectAndFilterTypes<int, Chat, ChatFilter>();

    for (final list in chatLists.values) {
      // TODO: Check if chat matches the filter. Not an issue so far as ChatFilter has no fields.
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
        // TODO: chat.withLastOutgoingMessage(message);
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
      list.addToBeginning([message]);
    }
  }

  @override
  void dispose() {
  }
}

enum _MessageDirection {
  incoming,
  outgoing,
}
